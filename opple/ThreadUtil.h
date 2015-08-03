//
//  ThreadUtil.h
//  opple
//
//  Created by zhen yang on 15/7/15.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreadUtil : NSObject
+(void)executeInMainThread:(dispatch_block_t)runnable;
+(void)execute:(dispatch_block_t)runnable;
@end
