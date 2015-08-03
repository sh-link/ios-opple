//
//  Header.h
//  opple
//
//  Created by zhen yang on 15/7/16.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
#define paddingLeft 20
@interface Header : UIControl
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) float height;
-(void)normal;
-(void)rotate;
@end
