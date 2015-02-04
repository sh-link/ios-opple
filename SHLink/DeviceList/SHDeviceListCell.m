//
//  SHDeviceListCell.m
//  SHLink
//
//  Created by 钱凯 on 15/2/2.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHDeviceListCell.h"

@interface SHDeviceListCell ()

@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;
@property (weak, nonatomic) IBOutlet UILabel *pktRecLabel;
@property (weak, nonatomic) IBOutlet UILabel *pktSendLabel;

@end

@implementation SHDeviceListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)setPktReceived:(int)pktReceived {
    _pktReceived = pktReceived;
    _pktRecLabel.text = [NSString stringWithFormat:@"接收到数据包: %d个",pktReceived];
}

- (void)setPktSent:(int)pktSent {
    _pktSent = pktSent;
    _pktSendLabel.text = [NSString stringWithFormat:@"发送的数据包: %d个",pktSent];
}

- (void)setMacAddress:(NSString *)macAddress {
    _macAddress = macAddress;
    _macLabel.text = [NSString stringWithFormat:@"mac: %@",macAddress];
}

@end
