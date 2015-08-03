//
//  WifiListCell.h
//  opple
//
//  Created by zhen yang on 15/7/22.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WifiListCellFrame.h"
@interface WifiListCell : UITableViewCell
+(WifiListCell*)cellForWifiListCell:(UITableView*)tableView;
@property (nonatomic, strong) WifiListCellFrame *cellFrame;
@end
