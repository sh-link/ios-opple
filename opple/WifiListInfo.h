//
//  WifiListInfo.h
//  opple
//
//  Created by zhen yang on 15/7/22.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifiListInfo : NSObject
@property (nonatomic, strong) NSString *ssid;
@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *encryptWay;
@property (nonatomic, strong) NSString *channel;
@end
