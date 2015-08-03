//
//  IPUtil.h
//  SHLink
//
//  Created by zhen yang on 15/7/11.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPUtil : NSObject
+(BOOL)isIPValid:(NSString*)ip;
+(BOOL)isPureInt:(NSString*)string;

+(BOOL)isMaskValid:(NSString*)mask;
+(NSString*)getBinary:(char)hex;


+(BOOL)isIPMaskGatewayValid:(NSString*)ip mask:(NSString*)mask gateway:(NSString*)gateway;
+(NSString *)deviceIPAddress;
+(NSString*)deviceMaskAddress;
+(void)getIPBytesWithStr:(NSString*)ip address:(char*)address;
+(void)getMaskBytesWithStr:(NSString*)mask address:(char*)address;

+(void)printBytes:(char*)chars len:(int)length;

+(NSString*)getBytes:(char*)chars length:(int)len;


+(BOOL)isEqual:(NSString*)ip mask:(NSString*)mask router_ip:(NSString*)router_ip router_mask:(NSString*)mask;
@end
