//
//  DialogUtil.m
//  SHLink
//
//  Created by zhen yang on 15/4/3.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "DialogUtil.h"
#import <UIKit/UIKit.h>
@implementation DialogUtil
+(void)createAndShowDialogWithTitle:(NSString *)title message:(NSString *)message
{
    if(title != nil && title.length == 0)
    {
        title = nil;
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alertView show];
}
@end
