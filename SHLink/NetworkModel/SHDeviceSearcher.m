//
//  SHDeviceSeacher.m
//  SHLink
//
//  Created by 钱凯 on 15/1/22.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHDeviceSearcher.h"
#import "Packet.h"
#import "md5.h"
#import "des.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <string.h>

//0xdeadbeafcafebabedeadbeafcafebabe
static unsigned char SHDesSrc[8] = {0xde,0xad,0xbe,0xaf,0xca,0xfe,0xba,0xbe};

@implementation SHDeviceSearcher
{
    int _timeout;
    int _sockFd;
}

-(instancetype)initWithDelegate:(id<SHDeviceSearcherDelegate>)delegate SearchTimeoutInSec:(int)timeout {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _timeout = timeout;
    }
    return self;
}

//TODO
-(BOOL)asyncSearchDeviceWithPort:(unsigned short)port {
    return YES;
}

//TODO
-(SHDevice *)syncSearchDeviceWithPort:(unsigned short)port {
    return nil;
}

+(SHDevice *)syncSearchDeviceWithPort:(unsigned short)port TimeoutInSec:(int)timeout {
    
    struct sockaddr_in broadcastAddr;
    int sockFd = -1;
    int ret;
    int flag;
    int broadcast = 1;
    fd_set rset;
    struct timeval tval;
    char readBuf[256];
    char ip[INET_ADDRSTRLEN];
    _SHDetect detectPacket;

    sockFd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockFd < 0) {
        return nil;
    }
    if ((ret = setsockopt(sockFd, SOL_SOCKET, SO_BROADCAST, &broadcast, sizeof(broadcast))) != 0) {
        return nil;
    }
    flag = fcntl(sockFd, F_GETFL, 0);
    fcntl(sockFd, F_SETFL, flag | O_NONBLOCK);
    
    bzero(&broadcastAddr, sizeof(broadcastAddr));
    broadcastAddr.sin_family = AF_INET;
    broadcastAddr.sin_port = htons(port);
    broadcastAddr.sin_addr.s_addr = htonl(INADDR_BROADCAST);
    broadcastAddr.sin_len = sizeof(broadcastAddr);
    
    bzero(&detectPacket, sizeof(detectPacket));
    *(int *)detectPacket.header.type = htonl(SHPacketType_Detect);
    
    if (sendto(sockFd, &detectPacket, sizeof(detectPacket), 0, (struct sockaddr *)&broadcastAddr, sizeof(broadcastAddr)) <= 0) {
        close(sockFd);
        return nil;
    }
    
    tval.tv_sec = timeout;
    tval.tv_usec = 0;
    
    FD_ZERO(&rset);
    FD_SET(sockFd, &rset);
    
    if (select(sockFd + 1, &rset, NULL, NULL, &tval) == 0) {
        close(sockFd);
        return nil;
    }
    
    if (recvfrom(sockFd, readBuf, sizeof(readBuf), 0, NULL, NULL) <= 0) {
        close(sockFd);
        return nil;
    }
    
    close(sockFd);
    
    _SHDetectReply *reply = (_SHDetectReply *)readBuf;
    
    if (PACKET_CHECK_TYPE(SHPacketType_DetectReply, reply)) {
        
        SHDevice *device = [[SHDevice alloc] init];
        
        device.ip = [NSString stringWithUTF8String:inet_ntop(AF_INET, reply->ip, ip, INET_ADDRSTRLEN)];
        device.mac = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",reply->mac[0],reply->mac[1],reply->mac[2],reply->mac[3],reply->mac[4],reply->mac[5]];
        
        return device;
    }
    
    return nil;
}

+(BOOL)syncChallengeDeviceWithIp:(NSString *)ip Port:(unsigned short)port Username:(NSString *)usernameString Password:(NSString *)passwordString TimeoutInSec:(int)timeout {
    
    struct sockaddr_in deviceAddr;
    int sockFd;
    int flag;
    int ret;
    fd_set wset,rset;
    struct timeval tval;
    _SHChallenge challengePacket;
    md5_state_t mst;
    md5_byte_t digest[16];
    char userID[16], password[16];
    char readBuf[256];
    _SHChallengeReply *reply;
    
    sockFd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockFd <= 0) {
        return NO;
    }
    flag = fcntl(sockFd, F_GETFL, 0);
    fcntl(sockFd, F_SETFL, flag | O_NONBLOCK);
    
    bzero(&deviceAddr, sizeof(deviceAddr));
    deviceAddr.sin_family = AF_INET;
    deviceAddr.sin_port = htons(port);
    if (inet_pton(AF_INET, [ip UTF8String], &deviceAddr.sin_addr.s_addr) <= 0) {
        return NO;
    }
    deviceAddr.sin_len = sizeof(deviceAddr);
    
    
    if ((ret = connect(sockFd, (struct sockaddr *)&deviceAddr, sizeof(struct sockaddr_in))) < 0) {
        if (errno != EINPROGRESS) {
            close(sockFd);
            return NO;
        }
    }
    
    FD_ZERO(&wset);
    FD_SET(sockFd,&wset);
    tval.tv_sec = timeout;
    tval.tv_usec = 0;
    
    if ((ret = select(sockFd + 1, NULL, &wset, NULL, &tval)) == 0) {
        //timeout
        close(sockFd);
        return NO;
    }
    if (!FD_ISSET(sockFd,&wset)) {
        close(sockFd);
        return NO;
    }
    
    bzero(&challengePacket, sizeof(challengePacket));
    *(int *)challengePacket.header.type = htonl(SHPacketType_Challenge);
    *(int *)challengePacket.length = htonl(0);
    strcpy((char *)challengePacket.userId, [usernameString UTF8String]);

    bzero(userID, 16);
    bzero(password, 16);
    strcpy(userID, [usernameString UTF8String]);
    strcpy(password, [passwordString UTF8String]);
    
    bzero(digest, 16);
    md5_init(&mst);
    md5_append(&mst, (unsigned char *)userID, 16);
    md5_append(&mst, (unsigned char *)password, 16);
    md5_finish(&mst, digest);

    des((const char *)SHDesSrc, (const char *)digest, (const char *)challengePacket.challenge, DES_ENCRYPT);

    if (write(sockFd, &challengePacket, sizeof(challengePacket)) < sizeof(challengePacket)) {
        close(sockFd);
        return NO;
    }
    
    FD_ZERO(&rset);
    FD_SET(sockFd, &rset);
    
    if ((ret = select(sockFd + 1, &rset, NULL, NULL, &tval)) == 0) {
        //time out
        close(sockFd);
        return NO;
    }
    
    if ((ret = (int)read(sockFd, readBuf, 1024)) <= 0) {
        close(sockFd);
        return NO;
    }
    
    reply = (_SHChallengeReply *)readBuf;
    
    if (PACKET_CHECK_TYPE(SHPacketType_ChallengeReply, reply)) {
        int status = ntohl(*(int *)reply->status);
        NSLog(@"SUCCESS wtih status: %d",status);
    }
    
    close(sockFd);
    return YES;
}



@end
