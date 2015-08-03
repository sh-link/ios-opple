//
//  ModifyWorkModeViewHeader.h
//  opple
//
//  Created by zhen yang on 15/7/20.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioGroup3.h"
@interface ModifyWorkModeViewHeader : UIView
@property (nonatomic, strong) id<RadioGroup3Delegate> delegate;
-(void)clickItem:(int)index;
@end
