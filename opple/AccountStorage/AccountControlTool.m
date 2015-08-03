//
//  AccountControlTool.m
//  Skylight
//
//  Created by  Qiankai on 7/10/14.
//  Copyright (c) 2014 TP-LINK. All rights reserved.
//

/** WARNING: */
/** DO NOT CHANGE KEYs AFTER RELEASE */
#define STORAGE_DIC_KEY @"shLink_passwordDicKey"
#define PASSWORD_KEY @"password"
#define USERNAME_KEY @"username"


#import "AccountControlTool.h"

@implementation AccountControlTool


+(NSString *)getStoragedPasswordWithMac:(NSString *)mac
{
    id dic = [[NSUserDefaults standardUserDefaults] objectForKey:STORAGE_DIC_KEY];
    
    if (dic == nil) {
        return nil;
    }
    
    id accountDic = [dic objectForKey:mac];
    NSString *password = [accountDic objectForKey:PASSWORD_KEY];
    return password;
}

+(NSString *)getStoragedUserNameWithMac:(NSString *)mac
{
    id dic = [[NSUserDefaults standardUserDefaults] objectForKey:STORAGE_DIC_KEY];
    
    if (dic == nil) {
        return nil;
    }
    
    id accountDic = [dic objectForKey:mac];
    NSString *username = [accountDic objectForKey:USERNAME_KEY];
    return username;
}

+(void)storageUserName:(NSString *)username Password:(NSString *)password ForMac:(NSString *)mac
{
    id dic = [[NSUserDefaults standardUserDefaults] objectForKey:STORAGE_DIC_KEY];
    
    if (dic == nil) {
        NSDictionary *accountDic = [[NSDictionary alloc] initWithObjectsAndKeys:username, USERNAME_KEY, password, PASSWORD_KEY, nil];
        NSDictionary *newDic = [[NSDictionary alloc] initWithObjectsAndKeys:accountDic,mac,nil];
        [[NSUserDefaults standardUserDefaults] setObject:newDic forKey:STORAGE_DIC_KEY];
    }
    else {
        //For dictionary got from user defaults is immutable, we copy it to mutable dic and add new key and write back.
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:STORAGE_DIC_KEY]];
        
        NSDictionary *accountDic = [[NSDictionary alloc] initWithObjectsAndKeys:username, USERNAME_KEY, password, PASSWORD_KEY, nil];
        
        [newDic setObject:accountDic forKey:mac];
        //Write back
        [[NSUserDefaults standardUserDefaults] setObject:newDic forKey:STORAGE_DIC_KEY];
    }
}


@end
