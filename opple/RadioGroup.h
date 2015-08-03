//
//  RadioGroup.h
//  opple
//
//  Created by zhen yang on 15/7/17.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
@interface RadioGroup : UIView


@property (nonatomic, strong) RadioButton *onButton;
@property (nonatomic, strong) RadioButton *offButton;

-(void)selectOn;
@end
