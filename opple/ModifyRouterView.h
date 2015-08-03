//
//  ModifyRouterView.h
//  opple
//
//  Created by zhen yang on 15/7/20.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModifyRouterViewBase.h"
#import "SHRectangleButton.h"
#import "ModifyRouterView2.h"
@interface ModifyRouterView : UIView
@property (nonatomic, strong) ModifyRouterViewBase *base;
@property (nonatomic, strong) ModifyRouterView2 *one;
@property (nonatomic, strong) ModifyRouterView2 *two;
@property (nonatomic, strong) ModifyRouterView2 *three;
@property (nonatomic, strong) id<ModifyRouterView2Delegate> delegate;
-(void)showSSID1;
-(void)showSSID2;
-(void)showSSID3;

-(void)hideSSID1;
-(void)hideSSID2;
-(void)hideSSID3;

@end
