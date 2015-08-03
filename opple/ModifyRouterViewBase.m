//
//  ModifyRouterView.m
//  opple
//
//  Created by zhen yang on 15/7/17.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "ModifyRouterViewBase.h"
#import "ScreenUtil.h"
#import "TextUtil.h"
#import "UIView+Extension.h"
#import "PopMenuViewController.h"
#import "DropMenu.h"
#import "MessageUtil.h"
#import "DropMenu.h"
#define padding 15
@interface ModifyRouterViewBase()<UITextFieldDelegate, DropMenuDelegate>
@end
@implementation ModifyRouterViewBase
{
    UILabel *label_base_ssid;
    UILabel *label_channel;
    UILabel *label_encyrpt_state;
    UILabel *label_password;
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
    label_base_ssid = [UILabel new];
    label_channel = [UILabel new];
    label_encyrpt_state = [UILabel new];
    label_password = [UILabel new];
    
    label_base_ssid.text = @"基本ssid:   ";
    label_channel.text = @"通信信道:";
    label_encyrpt_state.text = @"加密状态:";
    label_password.text = @"加密密钥: ";
    
    [self addSubview:label_base_ssid];
    [self addSubview:label_channel];
    [self addSubview:label_encyrpt_state];
    [self addSubview:label_password];
    
    _field_base_ssid = [MyTextField new];
    _field_channel = [MyTextField new];
    _field_channel.text = @"自动";
    _rg_encrypt_state = [RadioGroup new];
    _field_password = [MyTextField new];
    _button = [UIButton new];
    
    [self addSubview:_field_password];
    [self addSubview:_button];
    [_button addSubview:_field_channel];
    [self addSubview:_rg_encrypt_state];
    [self addSubview:_field_base_ssid];
    
   [_button addTarget:self action:@selector(popMenu:) forControlEvents:UIControlEventTouchUpInside];
    _field_channel.userInteractionEnabled = false;
    
    label_password.textColor = label_encyrpt_state.textColor = label_channel.textColor = label_base_ssid.textColor = getColor(0x57, 0x57, 0x57, 255);
    
    
    //确定高度
    label_base_ssid.height = label_channel.height = label_encyrpt_state.height = label_password.height = [TextUtil getSize:label_base_ssid].height;
    
    _field_base_ssid.height = _field_password.height = _field_channel.height = _button.height = label_base_ssid.height + 10;
    
    //确定y值
    _field_base_ssid.y = padding;
    _button.y = _field_channel.y = CGRectGetMaxY(_field_base_ssid.frame) + padding;
    _rg_encrypt_state.y = CGRectGetMaxY(_field_channel.frame) + padding;
    _field_password.y = CGRectGetMaxY(_rg_encrypt_state.frame) + padding;
   

    
    label_base_ssid.y = CGRectGetMidY(_field_base_ssid.frame) - label_base_ssid.height /2;
    label_channel.y = CGRectGetMidY(_field_channel.frame)  - label_channel.height /2;
    label_encyrpt_state.y = CGRectGetMidY(_rg_encrypt_state.frame) - label_encyrpt_state.height/2;
    label_password.y = CGRectGetMidY(_field_password.frame) - label_password.height/2;
    
    //确定自身高度
    self.height = CGRectGetMaxY(_field_password.frame) + padding;
    
    //确定x值
    label_base_ssid.x = label_channel.x = label_encyrpt_state.x = label_password.x = padding;
    
    //确定宽度
    label_base_ssid.width = label_channel.width = label_encyrpt_state.width = label_password.width = [TextUtil getSize:label_base_ssid].width;
    
    _field_base_ssid.x = _button.x = _field_channel.x = _rg_encrypt_state.x = _field_password.x = CGRectGetMaxX(label_base_ssid.frame);
   
    _field_channel.x = _field_channel.y = 0;
}


-(void)popMenu:(MyTextField*)field
{
    PopMenuViewController *controller = [[PopMenuViewController alloc]init];
    DropMenu *menu = [[DropMenu alloc]init];
    menu.delegate = self;
    menu.contentController = controller;
    [menu showFrom:field];
}

-(void)layoutSubviews
{
    _field_password.width =  _field_base_ssid.width =  self.width - 2 * padding -label_base_ssid.width;
    _button.width =  _field_channel.width = _field_password.width / 2;
}

-(void)clickItem:(int)index withData:(NSString *)data
{
    _field_channel.text = data;
}




@end
