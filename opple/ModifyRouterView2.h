//
//  ModifyRouterView2.h
//  opple
//
//  Created by zhen yang on 15/7/18.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioGroup.h"
#import "MyTextField.h"
@class ModifyRouterView2;
@protocol ModifyRouterView2Delegate <NSObject>

@required
-(void)deleteMyself:(ModifyRouterView2*)view;
@end
@interface ModifyRouterView2 : UIView
@property (nonatomic, strong) MyTextField *field_ssid;
@property (nonatomic, strong) MyTextField *field_password;
@property (nonatomic, strong) RadioGroup *rg_encrypt_state;
@property (nonatomic, strong) UILabel *label_ssid;
-(void)setSsid:(NSString*)ssid;
@property (nonatomic, strong) id<ModifyRouterView2Delegate> delegete;
@end
