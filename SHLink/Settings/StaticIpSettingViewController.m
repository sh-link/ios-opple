//
//  StaticIpSettingViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/2/1.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "StaticIpSettingViewController.h"
#import "SHTextField.h"
#import "SHRectangleButton.h"
#import "PureLayout.h"
#import "SHRouter.h"
#import "MBProgressHUD.h"

@interface StaticIpSettingViewController ()
{
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet SHTextField *ipTF;
@property (weak, nonatomic) IBOutlet SHTextField *maskTF;
@property (weak, nonatomic) IBOutlet SHTextField *gateTF;
@property (weak, nonatomic) IBOutlet SHTextField *dns1TF;
@property (weak, nonatomic) IBOutlet SHTextField *dns2TF;
@property (weak, nonatomic) IBOutlet SHRectangleButton *confirmBT;

@end

@implementation StaticIpSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    hud.labelText = @"正在设置…";
    hud.dimBackground = YES;
    hud.minShowTime = 2.0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [hud removeFromSuperview];
    [super viewDidDisappear:animated];
}

- (void)updateViewConstraints {
    
    [_contentHeightConstraint autoRemove];
    
    _contentHeightConstraint = [_contentView autoSetDimension:ALDimensionHeight toSize:CGRectGetMaxY(_confirmBT.frame) > CGRectGetHeight(self.view.bounds) ? CGRectGetMaxY(_confirmBT.frame) : CGRectGetHeight(self.view.bounds)];
    
    [super updateViewConstraints];
}

- (BOOL)checkValid {
    
    if (_ipTF.text.length == 0) {
        [_ipTF shakeWithText:@"ip地址不能为空"];
        return NO;
    }
    
    if (_maskTF.text.length == 0) {
        [_maskTF shakeWithText:@"子网掩码不能为空"];
        return NO;
    }
    
    if (_gateTF.text.length == 0) {
        [_gateTF shakeWithText:@"网关地址不能为空"];
        return NO;
    }
    
    if (_dns1TF.text.length == 0) {
        [_dns1TF shakeWithText:@"DNS 地址不能为空"];
        return NO;
    }
    
    return YES;
}

- (IBAction)viewTouchDown:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)ipDidEndOnExit:(id)sender {
    [_maskTF becomeFirstResponder];
}

- (IBAction)maskDidEndOnExit:(id)sender {
    [_gateTF becomeFirstResponder];
}

- (IBAction)gatewayDidEndOnExit:(id)sender {
    [_dns1TF becomeFirstResponder];
}

- (IBAction)dns1DidEndOnExit:(id)sender {
    [_dns2TF becomeFirstResponder];
}

- (IBAction)dns2DidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)ok:(id)sender {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if (![self checkValid]) {
        return;
    }
    
    __block BOOL ret;
    
    [hud showAnimated:YES whileExecutingBlock:^{
        ret = [[SHRouter currentRouter] setWanStaticIPWithIP:_ipTF.text Mask:_maskTF.text Gateway:_gateTF.text Dns1:_dns1TF.text Dns2:_dns2TF.text Error:nil];
    } completionBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SHAlert_Head
                                                        message:ret ? SHAlert_SetWanSuccess : SHAlert_SetWanFailed
                                                       delegate:nil
                                              cancelButtonTitle:SHAlert_OK
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
}

@end
