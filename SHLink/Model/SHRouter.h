//
//  SHRouter.h
//  SHLink
//
//  Created by 钱凯 on 15/1/22.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHDevice.h"

typedef NS_ENUM(int, _WanConfigType) {
    WanConfigTypePPPOE = 1,
    WanConfigTypeDHCP = 2,
    WanConfigTypeStatic = 3,
};

@interface SHRouter : SHDevice

//a puppy die for that, sorry
@property (nonatomic) BOOL loginNeedDismiss;

//another puppy die.
@property (nonatomic) BOOL directLogin;

/**
 *  Router's tcp socket addr, used to test reachability.
 */
@property (nonatomic) struct sockaddr_in hostAddr;

/**
 *  Port we connect to communicate with router.
 */
@property (nonatomic) unsigned short tcpPort;

/**
 *  Clist list of the router, call getClientListWithError: to refresh.
 */
@property (nonatomic, retain) NSArray *clientList;

/**
 *  Is the wan port connected
 */
@property (nonatomic) BOOL wanIsConnected;

/**
 *  Lan ip mask
 */
@property (nonatomic) NSString *LanMask;

/**
 *  Wan ip mask
 */
@property (nonatomic) NSString *wanMask;

/**
 *  Wan ip gateway
 */
@property (nonatomic) NSString *wanGateway;

/**
 *  IP DNS address
 */
@property (nonatomic) NSString *dns1;

/**
 *  IP DNS backup address
 */
@property (nonatomic) NSString *dns2;

/**
 *  Packet num router has sent.
 */
@property (nonatomic) long long txPktNum;

/**
 *  Packet num router has recrived.
 */
@property (nonatomic) long long rxPktNum;

/**
 *  Wifi ssid
 */
@property (nonatomic) NSString *ssid;

/**
 *  Wifi channel
 */
@property (nonatomic) int channel;

/**
 *  Wifi key
 */
@property (nonatomic) NSString *wifiKey;

/**
 *  Router's current wan config type.
 */
@property (nonatomic) _WanConfigType currentWanCfgType;

/**
 *  PPPoE username
 */
@property (nonatomic) NSString *pppoeUsername;

/**
 *  PPPoE Password
 */
@property (nonatomic) NSString *pppoePassword;

/**
 *  Get the shared instance of SHRouter.
 *
 *  @return The shared instance.
 */
+(instancetype)currentRouter;

- (BOOL)updateRouterInfo;

/**
 *  Get router's latest client list, which will update the clientList property.
 *
 *  @param error nil if success.
 *
 *  @return client list array.
 */
- (NSArray *)getClientListWithError:(NSError **)error;

/**
 *  Get router's current network setting info, if success, will update properties.
 *
 *  @param error error
 *
 *  @return Info dic if success, nil if failed.
 */
- (NSDictionary *)getNetworkSettingInfoWithError:(NSError **)error;

/**
 *  Set router's login account.
 *
 *  @param username New username to set.
 *  @param password New password to set.
 *  @param error    error
 *
 *  @return YES if success.
 */
- (BOOL)setRouterAccountWithUsername:(NSString *)username Password:(NSString *)password WithError:(NSError **)error;

/**
 *  Set router's WiFi, if success, will update properties.
 *
 *  @param ssid    New ssid to set.
 *  @param key     New WiFi key to set.
 *  @param channel New WiFi channel to set, 0 means auto.
 *  @param error   error
 *
 *  @return YES if success.
 */
- (BOOL)setWifiWithSsid:(NSString *)ssid WifiKey:(NSString *)key Channel:(int)channel Error:(NSError **)error;

/**
 *  Set router's lan config, if success, will update properties.
 *
 *  @param ip    Ip address to set.
 *  @param mask  Mask address to set.
 *  @param error Error
 *
 *  @return YES if success.
 */
- (BOOL)setLanIP:(NSString *)ip Mask:(NSString *)mask Error:(NSError **)error;

/**
 *  Set router's wan type to PPPoE.
 *
 *  @param pppoeUsername PPPoE username
 *  @param pppoePassword PPPoE password
 *  @param error         Error
 *
 *  @return YES if success.
 */
- (BOOL)setWanPPPoEWithUsername:(NSString *)pppoeUsername Password:(NSString *)pppoePassword Error:(NSError **)error;

/**
 *  Set router's wan type to DHCP.
 *
 *  @param error Error
 *
 *  @return YES if success.
 */
- (BOOL)setWanDHCPWithError:(NSError **)error;

/**
 *  Set router's wan type to static ip.
 *
 *  @param wanIp      Wan ip address
 *  @param wanMask    Wan mask address
 *  @param wanGateway Wan getway address
 *  @param dns1       DNS address
 *  @param dns2       Backup DNS address
 *  @param error      Error
 *
 *  @return YES if success.
 */
- (BOOL)setWanStaticIPWithIP:(NSString *)wanIp Mask:(NSString *)wanMask Gateway:(NSString *)wanGateway Dns1:(NSString *)dns1 Dns2:(NSString *)dns2 Error:(NSError **)error;

@end
