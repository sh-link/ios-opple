//
//  StringUtil.m
//  SHLink
//
//  Created by zhen yang on 15/7/11.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil
+(NSString*)trim:(NSString *)str
{
    return str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+(BOOL)isEmpty:(NSString*)str
{
    if(str == nil)
    {
        return true;
    }
    str = [self trim:str];
    if(str.length ==0)
    {
        return true;
    }
    else
    {
        return false;
    }
}
@end
