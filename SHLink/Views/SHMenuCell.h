//
//  SHMenuCell.h
//  SHLink
//
//  Created by 钱凯 on 15/1/28.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHMenuCell : UIView

@property (nonatomic) SEL selector;

@property (nonatomic) NSString *title;

@property (nonatomic) UIImage *image;

@property (nonatomic, weak) id caller;

@end
