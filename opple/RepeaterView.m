//
//  RepeaterView.m
//  opple
//
//  Created by zhen yang on 15/7/17.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "RepeaterView.h"
#import "UIView+Extension.h"
#import "TextUtil.h"
#define repeaterViewPaddingTop 15
#define repeaterViewPaddingLeft 15
#define lineHeight 0.5
@implementation RepeaterView
{
    UILabel *workmodeLabel;
    UILabel *ssidLabel;
    UILabel *macLabel;
    UILabel *passwordLabel;
    
    UIView *line1;
    UIView *line2;
    UIView *line3;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = true;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = getColor(200, 200, 200, 200).CGColor;
    
    workmodeLabel = [UILabel new];
    ssidLabel = [UILabel new];
    macLabel = [UILabel new];
    passwordLabel = [UILabel new];
    line1 = [UIView new];
    line2 = [UIView new];
    line3 = [UIView new];
    
    [self addSubview:workmodeLabel];
    [self addSubview:ssidLabel];
    [self addSubview:macLabel];
    [self addSubview:passwordLabel];
    [self addSubview:line1];
    [self addSubview:line2];
    [self addSubview:line3];
    
    workmodeLabel.text = @"test";
    
    line1.backgroundColor = line2.backgroundColor = line3.backgroundColor = getColor(0x55, 0x80, 0x80, 0x80);
    workmodeLabel.textColor = ssidLabel.textColor = macLabel.textColor = passwordLabel.textColor = getColor(0x57, 0x57, 0x57, 255);;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    float height = [TextUtil getSize:workmodeLabel].height;
    float width = self.width - 2 * repeaterViewPaddingLeft;
    
    workmodeLabel.frame = CGRectMake(repeaterViewPaddingLeft, repeaterViewPaddingTop, width, height);
    line1.frame = CGRectMake(0, CGRectGetMaxY(workmodeLabel.frame) + repeaterViewPaddingTop, self.width, lineHeight);
    ssidLabel.frame = CGRectMake(repeaterViewPaddingLeft, CGRectGetMaxY(line1.frame) + repeaterViewPaddingTop, width, height);
    line2.frame = CGRectMake(0, CGRectGetMaxY(ssidLabel.frame) + repeaterViewPaddingTop, self.width, lineHeight);
    macLabel.frame = CGRectMake(repeaterViewPaddingLeft, CGRectGetMaxY(line2.frame) + repeaterViewPaddingTop, self.width, lineHeight);
    line3.frame = CGRectMake(0, CGRectGetMaxY(macLabel.frame) + repeaterViewPaddingTop, self.width, lineHeight);
    passwordLabel.frame = CGRectMake(repeaterViewPaddingLeft, CGRectGetMaxY(line3.frame), width, height);
    self.height = CGRectGetMaxY(passwordLabel.frame) + repeaterViewPaddingTop;
}

-(void)setData:(NSDictionary *)dic
{
    workmodeLabel.text = @"当前工作模式: repeater模式";
    NSDictionary *repeaterDic = dic[@"WLAN_REPEATER"];
    ssidLabel.text = repeaterDic[@"SSID"];
    macLabel.text = repeaterDic[@"BSSID"];
    passwordLabel.text = repeaterDic[@"KEY"];
}

@end
