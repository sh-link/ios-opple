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
        
        sharedInstance.lanIp = @"192.168.0.1";
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
//    [self getClientListWithError:nil];
//    [self getNetworkSettingInfoWithError:nil];
    
    return YES;
}

- (NSArray *)getClientListWithError:(NSError **)error {
    
    NSData *commandJson = [NSJSONSerialization dataWithJSONObject:@{@"REQ_TYPE":@SHRequestType_GetClientList} options:0 error:nil];
    NSLog(@"%@",self.lanIp);
    NSData *receviceJson = [SHDeviceConnector syncSendCommandWithIp:self.lanIp Port:self.tcpPort Username:self.username Password:self.password Command:commandJson TimeoutInSec:3.0 Error:error];
    
    if ((error && *error) || !receviceJson) {
        if (error && *error)  NSLog(@"%@",[*error localizedDescription]);
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
    
    NSData *receviceJson = [SHDeviceConnector syncSendCommandWithIp:self.lanIp Port:self.tcpPort Username:self.username Password:self.password Command:commandJson TimeoutInSec:3.0 Error:error];
    
    if ((error && *error) || !receviceJson) {
        if (error && *error)  NSLog(@"%@",[*error localizedDescription]);
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
            self.wanIp = wanCfg[@"IP"];
            self.wanMask = wanCfg[@"MASK"];
            self.wanGateway = wanCfg[@"GATEWAY"];
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
    
    NSData *receviceJson = [SHDeviceConnector syncSendCommandWithIp:self.lanIp Port:self.tcpPort Username:self.username Password:self.password Command:commandJson TimeoutInSec:3.0 Error:error];
    
    if ((error && *error) || !receviceJson) {
        if (error && *error)  NSLog(@"%@",[*error localizedDescription]);
        return NO;
    }
    
    self.username = username;
    self.password = password;
    
    return YES;
}

- (BOOL)setWifiWithSsid:(NSString *)ssid WifiKey:(NSString *)key Channel:(int)channel Error:(NSError **)error {
    
    NSData *commandJson = [NSJSONSerialization dataWithJSONObject:@{@"REQ_TYPE":@SHRequestType_SetSsid, @"SSID":ssid, @"KEY":key, @"CHANNEL":[NSNumber numberWithInt:channel]} options:0 error:nil];
    
    NSData *receviceJson = [SHDeviceConnector syncSendCommandWithIp:self.lanIp Port:self.tcpPort Username:self.username Password:self.password Command:commandJson TimeoutInSec:3.0 Error:error];
    
    if ((error && *error) || !receviceJson) {
        if (error && *error)  NSLog(@"%@",[*error localizedDescription]);
        return NO;
    }
    
    self.wifiKey = key;
    self.ssid = ssid;
    self.channel = channel;
    
    return YES;
}

- (BOOL)setLanIP:(NSString *)ip Mask:(NSString *)mask Error:(NSError **)error {
    
    NSData *commandJson = [NSJSONSerialization dataWithJSONObject:@{@"REQ_TYPE":@SHRequestType_SetLan, @"IP":ip, @"MASK":mask} options:0 error:nil];
    
    NSData *receviceJson = [SHDeviceConnector syncSendCommandWithIp:self.lanIp Port:self.tcpPort Username:self.username Password:self.password Command:commandJson TimeoutInSec:3.0 Error:error];
    
    if ((error && *error) || !receviceJson) {
        if (error && *error)  NSLog(@"%@",[*error localizedDescription]);
        return NO;
    }
    
    self.lanIp= ip;
    self.LanMask = mask;
    
    return YES;
}

- (BOOL)setWanPPPoEWithUsername:(NSString *)pppoeUsername Password:(NSString *)pppoePassword Error:(NSError **)error {
    NSDictionary *cfgDic = @{@"UserName":pppoeUsername, @"PassWd": pppoePassword};
    BOOL ret = [self setWanWithType:WanConfigTypePPPOE ConfigDic:cfgDic Error:error];
    
    if (ret) {
        self.currentWanCfgType = WanConfigTypePPPOE;
        self.pppoeUsername = pppoeUsername;
        self.pppoePassword= pppoePassword;
    }
    
    return  ret;
}

- (BOOL)setWanDHCPWithError:(NSError **)error {
    
    NSDictionary *cfgDic = @{};
    
    BOOL ret = [self setWanWithType:WanConfigTypeDHCP ConfigDic:cfgDic Error:error];
    
    if (ret) {
        self.currentWanCfgType = WanConfigTypeDHCP;
    }
    
    return  ret;
}

- (BOOL)setWanStaticIPWithIP:(NSString *)wanIp Mask:(NSString *)wanMask Gateway:(NSString *)wanGateway Dns1:(NSString *)dns1 Dns2:(NSString *)dns2 Error:(NSError **)error {
    
    NSDictionary *cfgDic = @{@"IP": wanIp, @"MASK": wanMask, @"GATEWAY": wanGateway, @"DNS1": dns1, @"DNS2": dns2};
    
    BOOL ret = [self setWanWithType:WanConfigTypeStatic ConfigDic:cfgDic Error:error];
    
    if (ret) {
        
        self.currentWanCfgType = WanConfigTypeStatic;
        self.wanIp = wanIp;
        self.wanMask = wanMask;
        self.wanGateway = wanGateway;
        self.dns1 = dns1;
        self.dns2 = dns2;
    }
    
    return  ret;
}

#pragma mark - Tools
#pragma mark -

- (BOOL)setWanWithType:(_WanConfigType)type ConfigDic:(NSDictionary *)dic Error:(NSError **)error {
    
    NSData *commandJson = [NSJSONSerialization dataWithJSONObject:@{@"REQ_TYPE":@SHRequestType_SetWan, @"WAN_TYPE":[NSNumber numberWithInt:type], @"WAN_CFG":dic} options:0 error:nil];
    
    NSData *receviceJson = [SHDeviceConnector syncSendCommandWithIp:self.lanIp Port:self.tcpPort Username:self.username Password:self.password Command:commandJson TimeoutInSec:3.0 Error:error];
    
    if ((error && *error) || !receviceJson) {
        if (error && *error)  NSLog(@"%@",[*error localizedDescription]);
        return NO;
    }
    
    return YES;
}

#pragma mark - Properties
#pragma mark -

- (struct sockaddr_in)hostAddr {
    
    NSString *ip = self.lanIp ? self.lanIp : @"192.168.0.1";
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
