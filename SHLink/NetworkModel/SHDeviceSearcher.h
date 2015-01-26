//
//  SHDeviceSeacher.h
//  SHLink
//
//  Created by 钱凯 on 15/1/22.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//
//  搜索、登陆设备，提供同步和异步两种接口

#import <Foundation/Foundation.h>
#import "SHDevice.h"

@protocol SHDeviceSearcherDelegate;

@interface SHDeviceSearcher : NSObject

@property (nonatomic, weak) id<SHDeviceSearcherDelegate> delegate;

/**
 *  omnipotent Initialization
 *
 *  @param delegate delegate for callback.
 *  @param timeout  Search timeout in seconds.
 *
 *  @return Instancetype of SHDeviceSearcher.
 */
-(instancetype)initWithDelegate:(id<SHDeviceSearcherDelegate>)delegate SearchTimeoutInSec:(int)
timeout;

/**
 *  Async search device, call back with delegate.
 *
 *  @param port UDP port we search on, default is 10245.
 *
 *  @return YES if no error happens(not gurantee device found)
 */
-(BOOL)asyncSearchDeviceWithPort:(unsigned short)port;

/**
 *  Sync search device.
 *
 *  @param port UDP port we search on, default is 10245.
 *
 *  @return Nil if no device found.
 */
-(SHDevice *)syncSearchDeviceWithPort:(unsigned short)port;

/**
 *  Sync search device.
 *
 *  @param port UDP port we search on, default is 10245.
 *  @param timeout  Search timeout in seconds, default is 2sec.
 *
 *  @return Nil if no device found.
 */
+(SHDevice *)syncSearchDeviceWithPort:(unsigned short)port TimeoutInSec:(int)timeout;

+(BOOL)syncChallengeDeviceWithIp:(NSString *)ip Port:(unsigned short)port Username:(NSString *)usernameString Password:(NSString *)passwordString TimeoutInSec:(int)timeout;

@end


@protocol SHDeviceSearcherDelegate <NSObject>
 
-(void)didFindDeviceWithIp:(NSString *)ip Mac:(NSString *)mac;

@end