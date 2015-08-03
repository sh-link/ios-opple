//
//  WifiListCellFrame.m
//  opple
//
//  Created by zhen yang on 15/7/22.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "WifiListCellFrame.h"
#import "TextUtil.h"

#define padding 10
#define imgWidth 47
#define imgHeight 32

#import "ScreenUtil.h"
@implementation WifiListCellFrame

-(NSString*)description
{
    
    return [NSString stringWithFormat:@"imgFrame = %@ ======== ssidFrame = %@  ======== macFrame = %@ ===== encryptwayFrame = %@ ======= channelFrame = %@ ==== containerFrame = %@  ===== view.height = %f", NSStringFromCGRect(self.imgFrame), NSStringFromCGRect(self.ssidFrame), NSStringFromCGRect(self.macFrame), NSStringFromCGRect(self.encrypteWayFrame), NSStringFromCGRect(self.channelFrame), NSStringFromCGRect(self.containerFrame), self.height];
}

-(void)setInfo:(WifiListInfo *)info
{
    _info = info;
    CGSize ssidSize = [TextUtil getSize:info.ssid withTextSize:textsize];
    CGSize macSize = [TextUtil getSize:info.mac withTextSize:textsize];
    CGSize encrypteWaySize = [TextUtil getSize:info.encryptWay withTextSize:textsize];
    CGSize channelSize = [TextUtil getSize:info.channel withTextSize:textsize];
    self.imgFrame = CGRectMake(padding, 0, imgWidth, imgHeight);
    
    self.ssidFrame = CGRectMake(CGRectGetMaxX(self.imgFrame) + padding, padding, ssidSize.width, ssidSize.height);
    self.macFrame = CGRectMake(self.ssidFrame.origin.x, CGRectGetMaxY(self.ssidFrame) + padding, macSize.width, macSize.height);
    self.encrypteWayFrame = CGRectMake(self.ssidFrame.origin.x, CGRectGetMaxY(self.macFrame) + padding, encrypteWaySize.width, encrypteWaySize.height);
    self.channelFrame = CGRectMake(self.ssidFrame.origin.x, CGRectGetMaxY(self.encrypteWayFrame) + padding, channelSize.width, channelSize.height);
    
    self.containerFrame = CGRectMake(0, 0, [ScreenUtil getWidth], CGRectGetMaxY(self.channelFrame) + padding);
    self.imgFrame = CGRectMake(padding, CGRectGetMidY(self.containerFrame) - imgHeight/ 2, imgWidth, imgHeight);
    self.height = CGRectGetMaxY(self.containerFrame) + 1;
}
@end
