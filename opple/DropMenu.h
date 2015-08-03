//
//  DropMenu.h
//  opple
//
//  Created by zhen yang on 15/7/23.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropMenu;

@protocol DropMenuDelegate <NSObject>

@optional
-(void)clickItem:(int)index withData:(NSString*)data;
@end


@interface DropMenu : UIView
@property (nonatomic, weak) id<DropMenuDelegate> delegate;

+(instancetype)menu;

/**
 *显示
 */
-(void)showFrom:(UIView*)from;
-(void)dismiss;

@property (nonatomic, strong) UIViewController *contentController;

@end

