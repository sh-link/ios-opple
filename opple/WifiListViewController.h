//
//  WifiListViewController.h
//  opple
//
//  Created by zhen yang on 15/7/21.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WifiListDelegate <NSObject>
@required
-(void)passSSID:(NSString*)ssid withMac:(NSString*)mac;
@end

@interface WifiListViewController : UIViewController
@property (nonatomic, strong) id<WifiListDelegate> delegate;
@end
