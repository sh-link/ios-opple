//
//  ThreadUtil.m
//  opple
//
//  Created by zhen yang on 15/7/15.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "ThreadUtil.h"

@implementation ThreadUtil
+(void)executeInMainThread:(dispatch_block_t)runnable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        runnable();
        //DLog(@"当前线程是 : %@", [NSThread currentThread]);
    });
}

+(void)execute:(dispatch_block_t)runnable
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        runnable();
        //DLog(@"当前线程是 : %@", [NSThread currentThread]);
    });
}
@end
