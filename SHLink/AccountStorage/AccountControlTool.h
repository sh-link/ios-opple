//
//  AccountControlTool.h
//  Skylight
//
//  Created by  Qiankai on 7/10/14.
//  Copyright (c) 2014 TP-LINK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountControlTool : NSObject

/** Get a storaged password(utf8) by mac address */
+(NSString *)getStoragedPasswordWithMac:(NSString *)mac;

/** Get a storaged username(utf8) by mac address */
+(NSString *)getStoragedUserNameWithMac:(NSString *)mac;

/**
 *  Storage account info into disk.
 *
 *  @param username Username to storage.
 *  @param password Password to storage.
 *  @param mac      Mac address, used as dic key.
 */
+(void)storageUserName:(NSString *)username Password:(NSString *)password ForMac:(NSString *)mac;

@end
 