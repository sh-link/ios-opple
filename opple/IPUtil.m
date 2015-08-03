//
//  IPUtil.m
//  SHLink
//
//  Created by zhen yang on 15/7/11.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "IPUtil.h"
#import "StringUtil.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
@implementation IPUtil

+(BOOL)isEqual:(NSString *)ip mask:(NSString *)mask router_ip:(NSString *)router_ip router_mask:(NSString *)router_mask
{
    if([StringUtil isEmpty:ip] || [StringUtil isEmpty:mask] || [StringUtil isEmpty:router_ip] || [StringUtil isEmpty:router_mask])
    {
        return true;
    }
    //测试
//    ip=@"192.168.1.11";
//    mask = @"255.255.255.0";
//    router_ip = @"192.168.1.110";
//    router_mask = @"255.255.255.0";
    int ipInt = [self ip2Int:ip];
    int maskInt = [self ip2Int:mask];
    int router_ipInt = [self ip2Int:router_ip];
    int router_maskInt = [self ip2Int:router_mask];
    return (ipInt & maskInt) == (router_ipInt & router_maskInt);
}

+(int)ip2Int:(NSString*)ipStr
{
    //拆分
    NSArray *ips = [ipStr componentsSeparatedByString:@"."];
    int ip1 = [ips[0] intValue];
    int ip2 = [ips[1] intValue];
    int ip3 = [ips[2] intValue];
    int ip4 = [ips[3] intValue];
    
    return ip1 * 256 * 3 + ip2 * 256 * 2 + ip3 * 256 * 1 + ip4;
}

+ (NSString *)deviceIPAddress {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;  
}

+(void)getIPBytesWithStr:(NSString*)ip address:(char*)address
{
    NSArray *ips = [ip componentsSeparatedByString:@"."];
    if(ips.count < 4)
    {
        return;
    }
    int ip1 = [ips[0] intValue];
    int ip2 = [ips[1] intValue];
    int ip3 = [ips[2] intValue];
    int ip4 = [ips[3] intValue];
    address[0] = ip1;
    address[1] = ip2;
    address[2] = ip3;
    address[3] = ip4;
}

+(void)getMaskBytesWithStr:(NSString*)mask address:(char*)address
{
    NSArray *masks = [mask componentsSeparatedByString:@"."];
    int mask1 = [masks[0] intValue];
    int mask2 = [masks[1] intValue];
    int mask3 = [masks[2] intValue];
    int mask4 = [masks[3] intValue];
    address[0] = mask1;
    address[1] = mask2;
    address[2] = mask3;
    address[3] = mask4;
}

+ (NSString *)deviceMaskAddress {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;
}

+(void)printBytes:(char*)chars len:(int)len
{
    NSMutableString *str = [NSMutableString new];
    for(int i = 0; i < len; i++)
    {
        unsigned char ch = (unsigned char)chars[i];
        
        [str appendString:[NSString stringWithFormat:@"%u ",ch]];
    }
    DLog(@"str -- %@", str);
}

+(BOOL)isIPMaskGatewayValid:(NSString *)ip mask:(NSString *)mask gateway:(NSString *)gateway
{
    [StringUtil trim:ip];
    [StringUtil trim:mask];
    [StringUtil trim:gateway];
    NSArray *ips = [ip componentsSeparatedByString:@"."];
    int ip1 = [ips[0] intValue];
    int ip2 =  [ips[1] intValue];
    int ip3 = [ips[2] intValue];
    int ip4 = [ips[3] intValue];
    int ipInt = ip1 * 8*8*8 + ip2 *8*8 + ip3 * 8 + ip4;
    
    NSArray *masks = [mask componentsSeparatedByString:@"."];
    int mask1 = [masks[0] intValue];
    int mask2 = [masks[1] intValue];
    int mask3 = [masks[2] intValue];
    int mask4 = [masks[3] intValue];
    int maskInt = mask1 *8*8*8 + mask2*8*8 + mask3 *8 + mask4;
    
    NSArray *gateways = [gateway componentsSeparatedByString:@"."];
    int gateway1 = [gateways[0] intValue];
    int gateway2 = [gateways[1] intValue];
    int gateway3 = [gateways[2] intValue];
    int gateway4 = [gateways[3] intValue];
    int gatewayInt = gateway1 *8*8*8 + gateway2*8*8 + gateway3*8 + gateway4;
    
    return (ipInt&maskInt) == (maskInt&gatewayInt);
    
}


+(BOOL)isIPValid:(NSString*)ip
{
    if(ip == nil)
    {
        return false;
    }
    
    ip = [StringUtil trim:ip];
    
    if(ip.length == 0)
    {
        return false;
    }
    
    NSArray *seperateIPs = [ip componentsSeparatedByString:@"."];
    if(seperateIPs.count != 4)
    {
        return false;
    }
    
    //分别检查四个部分
    NSString *ip1Str = seperateIPs[0];
    NSString *ip2Str = seperateIPs[1];
    NSString *ip3Str = seperateIPs[2];
    NSString *ip4Str = seperateIPs[3];
    

    
    if(!([self isPureInt:ip1Str] && [self isPureInt:ip2Str] && [self isPureInt:ip3Str] && [self isPureInt:ip4Str]))
    {
        return false;
    }
    
    int ip1  = [ip1Str intValue];
    int ip2 = [ip2Str intValue];
    int ip3 = [ip3Str intValue];
    int ip4 = [ip4Str intValue];
    
    if(ip1 < 0 || ip1 > 255)
    {
        return false;
    }
    if(ip2 < 0 || ip2 > 255)
    {
        return false;
    }
    if(ip3 < 0 || ip3 > 255)
    {
        return false;
    }
    if(ip4 < 0 || ip4 > 255)
    {
        return false;
    }
    
    for(NSString *str in seperateIPs)
    {
        NSLog(@"str = %@", str);
    }
    return true;
}



+(BOOL)isMaskValid:(NSString*)mask
{
    if(![self isIPValid:mask])
    {
        return false;
    }
    
    //拆分
    NSArray *ips = [mask componentsSeparatedByString:@"."];
    NSString *ip1Str = ips[0];
    NSString *ip2Str = ips[1];
    NSString *ip3Str = ips[2];
    NSString *ip4Str = ips[3];
    
    int ip1 = [ip1Str intValue];
    int ip2 = [ip2Str intValue];
    int ip3 = [ip3Str intValue];
    int ip4 = [ip4Str intValue];
    
    char bytes[4];
    bytes[0] = ip1;
    bytes[1] = ip2;
    bytes[2] = ip3;
    bytes[3] = ip4;
    
    NSString *hexStr = @"";
    for(int i = 0 ; i < 4; i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    
    NSMutableString *binaryStr = [NSMutableString new];
    for(int i = 0; i < hexStr.length; i++)
    {
        [binaryStr appendString:[self getBinary:[hexStr characterAtIndex:i]]];
    }
    
    
    NSLog(@"mask normal = %@  || hex = %@ || binary = %@", mask, hexStr, binaryStr);
    
    //找出第一个0出现的位置
    int index;
    NSRange range = [binaryStr rangeOfString:@"0"];
    if(range.location != NSNotFound)
    {
        //找到了
        index = range.location;
        //截取从此后开始的所有字符串
        NSString *searchStr = [binaryStr substringFromIndex:index + 1];
        range = [searchStr rangeOfString:@"1"];
        
        if(range.location != NSNotFound)
        {
            return  false;
        }
        else
        {
            return true;
        }
        
    }
    else
    {
        return true;
    }
    
}

+(BOOL)isPureInt:(NSString*)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+(NSString*)getBinary:(char)hexChar
{
    NSString *hex = [NSString stringWithFormat:@"%c", hexChar];
    if([@"f" isEqualToString:hex])
    {
        return @"1111";
    }
    else if([@"e" isEqualToString:hex])
    {
        return @"1110";
    }
    else if([@"d" isEqualToString:hex])
    {
        return @"1101";
    }
    else if([@"c" isEqualToString:hex])
    {
        return @"1100";
    }
    else if([@"b" isEqualToString:hex])
    {
        return @"1011";
    }
    else if([@"a" isEqualToString:hex])
    {
        return @"1010";
    }
    else if([@"9" isEqualToString:hex])
    {
        return @"1001";
    }
    else if([@"8" isEqualToString:hex])
    {
        return @"1000";
    }
    else if([@"7" isEqualToString:hex])
    {
        return @"0111";
    }
    else if([@"6" isEqualToString:hex])
    {
        return @"0110";
    }
    else if([@"5" isEqualToString:hex])
    {
        return @"0101";
    }
    else if([@"4" isEqualToString:hex])
    {
        return @"0100";
    }
    else if([@"3" isEqualToString:hex])
    {
        return @"0011";
    }
    else if([@"2" isEqualToString:hex])
    {
        return @"0010";
    }
    else if([@"1" isEqualToString:hex])
    {
        return @"0001";
    }
    else if([@"0" isEqualToString:hex])
    {
        return @"0000";
    }
    return nil;
}


+(NSString*)getBytes:(char*)chars length:(int)len
{
    NSMutableString *result = [NSMutableString new];
    for(int i = 0; i < len; i++)
    {
        unsigned char ch = chars[i];
        //高四位
        //低四位
        unsigned char low = ch&0x0f;
        unsigned char high = (ch >> 4) & 0x0f;
        [result appendString:[NSString stringWithFormat:@"%x%x:", high, low]];
    }
    [result deleteCharactersInRange:NSMakeRange(result.length - 1, 1)];
    return result;
}

@end
