//
//  ModifyRouterView.h
//  opple
//
//  Created by zhen yang on 15/7/17.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextField.h"
#import "RadioGroup.h"
@interface ModifyRouterViewBase : UIView
@property (nonatomic, strong) MyTextField *field_base_ssid;
@property (nonatomic, strong) RadioGroup  *rg_encrypt_state;
@property (nonatomic, strong) MyTextField *field_channel;
@property (nonatomic, strong) MyTextField *field_password;
@property (nonatomic, strong) UIButton *button;
@end
