//
//  SHRouter.m
//  SHLink
//
//  Created by 钱凯 on 15/1/22.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHRouter.h"
#import "SHDeviceConnector.h"
#import "Packet.h"
#import "Reachability.h"

#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>

@implementation SHRouter

+ (instancetype)currentRouter {
    static dispatch_once_t onceToken;
    static SHRouter *sharedInstance;
    dispatch_once(&onceToken,^{
        sharedInstance = [[SHRouter alloc] init];
        sharedInstance.ip = @"192.168.0.1";
        sharedInstance.tcpPort = 10246;
        sharedInstance.username = @"admin";
        sharedInstance.password = @"111111";
        
        struct sockaddr_in deviceAddr;
        bzero(&deviceAddr, sizeof(deviceAddr));
        deviceAddr.sin_family = AF_INET;
        deviceAddr.sin_port = htons(sharedInstance.tcpPort);
        deviceAddr.sin_len = sizeof(deviceAddr);
        inet_pton(AF_INET, [sharedInstance.ip UTF8String], &deviceAddr.sin_addr.s_addr);
        
        sharedInstance.hostAddr = deviceAddr;
    });
    return sharedInstance;
}

- (BOOL)updateRouterInfo {
    
    if ([Reachability reachabilityWithAddress:&_hostAddr].currentReachabilityStatus == NotReachable) {
        NSLog(@"NOT Reachable");
        return NO;
    }
    NSError *error = nil;
    [self getClientListWithError:&error];
    
    return YES;
}

/**
 *  Get router's latest client list.
 *
 *  @param error nil if success.
 *
 *  @return client list array.
 */
- (NSArray *)getClientListWithError:(NSError **)error {
    
    NSData *commandJson = [NSJSONSerialization dataWithJSONObject:@{@"REQ_TYPE":@SHRequestType_GetClientList} options:0 error:nil];

    NSData *receviceJson =  [SHDeviceConnector syncSendCommandWithIp:self.ip Port:self.tcpPort Username:self.username Password:self.password Command:commandJson TimeoutInSec:2 Error:error];
    
    if (*error) {
        NSLog(@"%@",[*error localizedDescription]);
        return nil;
    }
    
    if (receviceJson) {
        NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:receviceJson options:0 error:nil];
        if (receiveDic) {
            self.clientList = receiveDic[@"CLIENTS"];
            return self.clientList;
        }
    }
    
    return nil;
}

@end
