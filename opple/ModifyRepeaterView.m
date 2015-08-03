//
//  ModifyRepeaterView.m
//  opple
//
//  Created by zhen yang on 15/7/17.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "ModifyRepeaterView.h"
#import "SHRectangleButton.h"
#import "TextUtil.h"

#import "UIView+Extension.h"
#define padding 15

@implementation ModifyRepeaterView
{
    UILabel *ssidLabel;
    UILabel *macLabel;
    UILabel *passwordLabel;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        [self setUp];
    }
    return self;
}



-(void)setUp
{
    self.backgroundColor = [UIColor whiteColor];
    ssidLabel = [UILabel new];
    macLabel = [UILabel new];
    passwordLabel = [UILabel new];
    [self addSubview:ssidLabel];
    [self addSubview:macLabel];
    [self addSubview:passwordLabel];
    ssidLabel.text = @"无线名称:";
    macLabel.text = @"mac地址:";
    passwordLabel.text = @"加密密钥:";
    
    _ssidField = [SHTextField new];
    _macField = [SHTextField new];
    _passwordField = [SHTextField new];
    
    
    self.connectwifi = [[SHRectangleButton alloc]init];
   
    [self.connectwifi setTitle:@"选择" forState:UIControlStateNormal];
    self.connectwifi.layer.cornerRadius = 2;
    
    [self addSubview:_ssidField];
    [self addSubview:_macField];
    [self addSubview:_passwordField];
    [self addSubview:self.connectwifi];
    
    _ssidField.layer.borderColor = _macField.layer.borderColor = _passwordField.layer.borderColor = getColor(0x57, 0x57, 0x57, 100).CGColor;
    _ssidField.layer.cornerRadius = _macField.layer.cornerRadius = _passwordField.layer.cornerRadius = 2;
    _ssidField.layer.borderWidth = _macField.layer.borderWidth = _passwordField.layer.borderWidth = 0.8;
    
    ssidLabel.textColor = macLabel.textColor = passwordLabel.textColor = getColor(0x57, 0x57, 0x57, 255);
    
    ssidLabel.x = macLabel.x = passwordLabel.x = padding;
    
    float labelWidth =[TextUtil getSize:ssidLabel].width + 2;
    float labelHeight = [TextUtil getSize:ssidLabel].height;
    ssidLabel.width = macLabel.width = passwordLabel.width = labelWidth;
    ssidLabel.height = macLabel.height = passwordLabel.height = labelHeight;
    
    self.connectwifi.width = [TextUtil getSize:@"选择" withLabel:ssidLabel].width + 4;
    self.connectwifi.height = [TextUtil getSize:@"选择" withLabel:ssidLabel].height + 10;
    
    
    self.connectwifi.y = padding;
    
    _macField.x = _passwordField.x = _ssidField.x = CGRectGetMaxX(ssidLabel.frame);
    _macField.height = _passwordField.height = _ssidField.height = self.connectwifi.height;
    _ssidField.y = padding;
    _macField.y = CGRectGetMaxY(_ssidField.frame) + padding;
    _passwordField.y = CGRectGetMaxY(_macField.frame) + padding;
    
    ssidLabel.y  = CGRectGetMidY(_ssidField.frame) - labelHeight /2;
    macLabel.y = CGRectGetMidY(_macField.frame) - labelHeight /2;
    passwordLabel.y = CGRectGetMidY(_passwordField.frame) - labelHeight /2;
    
    self.height = CGRectGetMaxY(_passwordField.frame) + padding;

}

-(void)layoutSubviews
{
     
    self.connectwifi.x = self.width - self.connectwifi.width - 5;
   
    _macField.width = _passwordField.width = _ssidField.width = self.width - CGRectGetMaxX(ssidLabel.frame) - 3 - self.connectwifi.width - 5;
    
}


@end
