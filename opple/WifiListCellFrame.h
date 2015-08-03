//
//  WifiListCellFrame.h
//  opple
//
//  Created by zhen yang on 15/7/22.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WifiListInfo.h"
#define textsize 15
@interface WifiListCellFrame : NSObject
@property (nonatomic, assign) CGRect imgFrame;
@property (nonatomic, assign) CGRect ssidFrame;
@property (nonatomic, assign) CGRect macFrame;
@property (nonatomic, assign) CGRect encrypteWayFrame;
@property (nonatomic, assign) CGRect channelFrame;
@property (nonatomic, assign) CGRect containerFrame;
@property (nonatomic, assign) float height;

@property (nonatomic, strong) WifiListInfo *info;

@end
