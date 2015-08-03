//
//  WifiListCell.m
//  opple
//
//  Created by zhen yang on 15/7/22.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "WifiListCell.h"
#import "WifiListCellFrame.h"
#import "MJRefresh.h"
@implementation WifiListCell
{
    UIImageView *imgView;
    UILabel *ssid;
    UILabel *mac;
    UILabel *encrypteWay;
    UILabel *channel;
    UIView *container;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setUp];
    }
    return self;
}


-(void)setUp
{
    imgView = [UIImageView new];
    imgView.image = [UIImage imageNamed:@"wifi4"];
    ssid = [UILabel new];
    mac = [UILabel new];
    encrypteWay = [UILabel new];
    channel = [UILabel new];
    container = [UIView new];
    
    [container addSubview:imgView];
    [container addSubview:ssid];
    [container addSubview:mac];
    [container addSubview:encrypteWay];
    [container addSubview:channel];
    
    [self.contentView addSubview:container];
    
    container.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = getColor(225, 225, 225, 255);
    
    ssid.textColor = mac.textColor = encrypteWay.textColor = channel.textColor = getColor(0x57, 0x57, 0x57, 255);
}

+(WifiListCell*)cellForWifiListCell:(UITableView *)tableView
{
    static NSString *cellId = @"cellID";
    WifiListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[WifiListCell alloc]initWithStyle:0 reuseIdentifier:cellId];
    }
    return cell;
}

-(void)setCellFrame:(WifiListCellFrame *)frame
{
    _cellFrame = frame;
    ssid.text = frame.info.ssid;
    mac.text = frame.info.mac;
    encrypteWay.text = frame.info.encryptWay;
    channel.text = frame.info.channel;
    
    imgView.frame = frame.imgFrame;
    ssid.frame = frame.ssidFrame;
    mac.frame = frame.macFrame;
    encrypteWay.frame = frame.encrypteWayFrame;
    channel.frame = frame.channelFrame;
    container.frame = frame.containerFrame;
    
    ssid.font = mac.font = encrypteWay.font = channel.font = [UIFont systemFontOfSize:textsize];
}

@end
