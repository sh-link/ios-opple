//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MJ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

/**显示一个提示,默认1.5秒后会自动消失*/
+ (void)showSuccess:(NSString *)success;
/**显示一个失败提示,默认1.5秒后自动消失*/
+ (void)showError:(NSString *)error;
/**显示一个提示信息,需要手工关闭*/
+ (MBProgressHUD *)showMessage:(NSString *)message;
/**关闭hud*/
+ (void)hideHUD;

+ (void)hideHUDForView:(UIView *)view;

@end
