//
//  NetInfoCell3.h
//  opple
//
//  Created by zhen yang on 15/7/16.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetInfoCell3 : UITableViewCell
@property (nonatomic, copy) UILabel *hintLabel;
@property (nonatomic, copy) UILabel *valueLabel;
@property (nonatomic, assign) CGFloat height;

+(id)cellFromTableView:(UITableView*)tableView;
@end
