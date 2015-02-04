//
//  SHDeviceListCell.h
//  SHLink
//
//  Created by 钱凯 on 15/2/2.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHDeviceListCell : UITableViewCell

@property (nonatomic) NSString *macAddress;

@property (nonatomic) int pktReceived;

@property (nonatomic) int pktSent;

@end
