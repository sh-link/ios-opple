//
//  SHDevice.m
//  SHLink
//
//  Created by 钱凯 on 15/1/22.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHDevice.h"

@implementation SHDevice

-(void)setUsername:(NSString *)username {
    _username = username;
    
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
}

-(void)setPassword:(NSString *)password {
    _password = password;
    
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
}

@end
