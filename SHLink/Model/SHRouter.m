//
//  SHRouter.m
//  SHLink
//
//  Created by 钱凯 on 15/1/22.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHRouter.h"

@implementation SHRouter

+ (instancetype)currentRouter {
    
    static dispatch_once_t onceToken;
    static SHRouter *sharedInstance;
    dispatch_once(&onceToken,^{
        sharedInstance = [[SHRouter alloc] init];
    });
    
    return sharedInstance;
    
}



@end
