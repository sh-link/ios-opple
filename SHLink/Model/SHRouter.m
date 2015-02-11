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
        sharedInstance.tcpPort = 10246;
        
        sharedInstance.ip = @"192.168.0.1";
        sharedInstance.username = @"admin";
        sharedInstance.password = @"111111";
    });
    return sharedInstance;
}

#pragma mark - Public APIs
#pragma mark -

- (BOOL)updateRouterInfo {
    
    struct sockaddr_in deviceAddr = self.hostAddr;
    if ([Reachability reachabilityWithAddress:&deviceAddr].currentReachabilityStatus == NotReachable) {
        return NO;
    }
    
//    NSError *error = nil;
    [self getClientListWithError:nil];
    [self getNetworkSettingInfoWithError:nil];
    
    return YES;
}

- (NSArray *)getClientListWithError:(NSError **)error {
    
    NSData *commandJson = [NSJSONSerialization dataWithJSONObject:@{@"REQ_TYPE":@SHRequestType_GetClientList} options:0 error:nil];
    
    NSData *receviceJson = [SHDeviceConnector syncSendCommandWithIp:self.ip Port:self.tcpPort Username:self.username Password:self.password Command:commandJson TimeoutInSec:3.0 Error:error];
    
    if (error && *error) {
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

- (NSDictionary *)getNetworkSettingInfoWithError:(NSError **)error {
    
    NSData *commandJson = [NSJSONSerialization dataWithJSONObject:@{@"REQ_TYPE":@SHRequestType_GetNetworkInfo} options:0 error:nil];
    
    NSData *receviceJson = [SHDeviceConnector syncSendCommandWithIp:self.ip Port:self.tcpPort Username:self.username Password:self.password Command:commandJson TimeoutInSec:3.0 Error:error];
    
    if (error && *error) {
        NSLog(@"%@",[*error localizedDescription]);
        return nil;
    }
    
    if (receviceJson) {
        NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:receviceJson options:0 error:nil];
        if (receiveDic) {
            
            NSLog(@"network info: %@",receiveDic);
            
            NSDictionary *wlanCfg = receiveDic[@"WLAN_CFG"];
            self.ssid = wlanCfg[@"SSID"];
            self.channel = [wlanCfg[@"CHANNEL"] intValue];
            self.wifiKey = wlanCfg[@"KEY"];
            
            NSDictionary *wanCfg = receiveDic[@"WAN_CFG"];
            self.wanIsConnected = [wanCfg[@"WAN_ISCONNECTED"] intValue] == 1;
            self.mask = wanCfg[@"MASK"];
            self.gateway = wanCfg[@"GATEWAY"];
            self.dns1 = wanCfg[@"DNS1"];
            self.dns2 = wanCfg[@"DNS2"];
            self.txPktNum = [wanCfg[@"TX_BYTES"] longLongValue];
            self.rxPktNum = [wanCfg[@"RX_BYTES"] longLongValue];
            
            return receiveDic;
        }
    }
    
    return nil;
}

- (BOOL)setRouterAccountWithUsername:(NSString *)username Password:(NSString *)password WithError:(NSError **)error {
    
    NSData *commandJson = [NSJSONSerialization dataWithJSONObject:@{@"REQ_TYPE":@SHRequestType_SetAccount, @"USER":username, @"PASSWORD":password} options:0 error:nil];
    
    NSData *receviceJson = [SHDeviceConnector syncSendCommandWithIp:self.ip Port:self.tcpPort Username:self.username Password:self.password Command:commandJson TimeoutInSec:3.0 Error:error];
    
    if ((error && *error) || !receviceJson) {
        NSLog(@"%@",[*error localizedDescription]);
        return NO;
    }
    
    self.username = username;
    self.password = password;
    
    return YES;
}

- (BOOL)setWifiWithSsid:(NSString *)ssid WifiKey:(NSString *)key Channel:(int)channel Error:(NSError **)error {
    
    NSData *commandJson = [NSJSONSerialization dataWithJSONObject:@{@"REQ_TYPE":@SHRequestType_SetSsid, @"SSID":ssid, @"KEY":key, @"CHANNEL":[NSNumber numberWithInt:channel]} options:0 error:nil];
    
    NSData *receviceJson = [SHDeviceConnector syncSendCommandWithIp:self.ip Port:self.tcpPort Username:self.username Password:self.password Command:commandJson TimeoutInSec:3.0 Error:error];
    
    if ((error && *error) || !receviceJson) {
        NSLog(@"%@",[*error localizedDescription]);
        return NO;
    }
    
    self.wifiKey = key;
    self.ssid = ssid;
    self.channel = channel;
    
    return YES;
}

#pragma mark - Tools
#pragma mark -



#pragma mark - Properties
#pragma mark -

- (struct sockaddr_in)hostAddr {
    
    NSString *ip = self.ip ? self.ip : @"192.168.0.1";
    unsigned short tcpPort = self.tcpPort == 0 ? 10246 : self.tcpPort;

    struct sockaddr_in deviceAddr;
    bzero(&deviceAddr, sizeof(deviceAddr));
    deviceAddr.sin_family = AF_INET;
    deviceAddr.sin_port = htons(tcpPort);
    deviceAddr.sin_len = sizeof(deviceAddr);
    inet_pton(AF_INET, [ip UTF8String], &deviceAddr.sin_addr.s_addr);
    
    return deviceAddr;
}

@end
