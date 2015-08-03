//
//  ModifyRouterView2.m
//  opple
//
//  Created by zhen yang on 15/7/18.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "ModifyRouterView2.h"
#import "UIView+Extension.h"
#import "TextUtil.h"
#import "ScreenUtil.h"

#define padding 15
@implementation ModifyRouterView2
{
    UIView *topLine;
    UILabel *label_encryptState;
    UILabel *label_password;
    
    UIButton *delete;
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
    topLine = [UIView new];
    label_encryptState = [UILabel new];
    label_encryptState.text = @"加密状态:";
    label_password = [UILabel new];
    label_password.text = @"加密密码:";
    delete = [UIButton new];
    [delete addTarget:self action:@selector(deleteMySelf) forControlEvents:UIControlEventTouchUpInside];
    
    [delete setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
    
    _label_ssid = [UILabel new];
    _label_ssid.text = @"无线ssid1: ";
    _field_ssid = [MyTextField new];
    _field_password = [MyTextField new];
    _rg_encrypt_state = [RadioGroup new];
    
    [self addSubview:topLine];
    [self addSubview:label_encryptState];
    [self addSubview:label_password];
    [self addSubview:delete];
    [self addSubview:_label_ssid];
    [self addSubview:_field_password];
    [self addSubview:_field_ssid];
    [self addSubview:_rg_encrypt_state];
    
    _label_ssid.textColor = label_encryptState.textColor = label_password.textColor = getColor(0x57, 0x57, 0x57, 255);
    
    topLine.backgroundColor = getColor(0x80, 0x80, 0x80, 0x55);
    
    
    //确定frame
    topLine.x = 0;
    topLine.y = 0;
    topLine.height = 0.5;
    
    delete.width = 30;
    delete.height = 30;
    //delete.backgroundColor = [UIColor redColor];
    
    delete.y = CGRectGetMaxY(topLine.frame);
    label_password.x = label_encryptState.x = _label_ssid.x = padding;
    label_password.width = label_encryptState.width =  _label_ssid.width = [TextUtil getSize:_label_ssid].width;
      label_password.height = label_encryptState.height = _label_ssid.height = _label_ssid.height = [TextUtil getSize:_label_ssid].height;
    _field_password.height = _field_ssid.height = label_encryptState.height + 10;
    _field_ssid.x = _field_password.x = _rg_encrypt_state.x = CGRectGetMaxX(_label_ssid.frame);
    _field_ssid.y = CGRectGetMaxY(delete.frame);
    _rg_encrypt_state.y = CGRectGetMaxY(_field_ssid.frame) + padding;
    _field_password.y = CGRectGetMaxY(_rg_encrypt_state.frame) + padding;
    
    _label_ssid.y = CGRectGetMidY(_field_ssid.frame) - _label_ssid.height / 2;
    label_encryptState.y = CGRectGetMidY(_rg_encrypt_state.frame) - label_encryptState.height / 2;
    label_password.y = CGRectGetMidY(_field_password.frame) - label_password.height / 2;
    
    self.height = CGRectGetMaxY(_field_password.frame) + padding;
}

-(void)layoutSubviews
{
    //y值未确定
    delete.x = self.width - delete.width - 2;
    topLine.width = self.width;
    _field_password.width =  _field_ssid.width = self.width - delete.width - CGRectGetMaxX(_label_ssid.frame);
    
}

-(void)setSsid:(NSString *)ssid
{
    self.label_ssid.text = [NSString stringWithFormat:@"%@: ",ssid];
}


-(void)deleteMySelf
{
    //删除自己，即隐藏自己
    //清除自己的数据
    self.field_ssid.text = @"";
    self.field_password.text = @"";
    [self.rg_encrypt_state selectOn];
    [self.delegete deleteMyself:self];
}

@end
