//
//  RouterModeView.h
//  opple
//
//  Created by zhen yang on 15/7/16.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHRectangleButton.h"
@interface RouterModeView : UIScrollView
-(void)setData:(NSDictionary*)dic;
-(void)setMaxHeight:(CGFloat)maxHeight;
+(RouterModeView*)RouterModeViewWithMaxHeight:(CGFloat)maxHeight;
@end
