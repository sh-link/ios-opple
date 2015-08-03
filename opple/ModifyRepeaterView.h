//
//  ModifyRepeaterView.h
//  opple
//
//  Created by zhen yang on 15/7/17.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHTextField.h"
#import "SHRectangleButton.h"


@interface ModifyRepeaterView : UIView

@property (nonatomic, strong) SHTextField *ssidField;
@property (nonatomic, strong) SHTextField *macField;
@property (nonatomic, strong) SHTextField *passwordField;
@property (nonatomic, strong) SHRectangleButton *connectwifi;
@end
