//
//  PopMenuViewController.h
//  opple
//
//  Created by zhen yang on 15/7/23.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PopMenuViewControllerDelegate <NSObject>
-(void)clickItem:(int)index withData:(NSArray*)data;
@end

@interface PopMenuViewController : UIViewController
@property (nonatomic, strong) id<PopMenuViewControllerDelegate> delegate;
@end
