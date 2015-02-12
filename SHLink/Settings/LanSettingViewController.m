//
//  LanSettingViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/1/26.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "LanSettingViewController.h"
#import "SHTextField.h"
#import "SHRectangleButton.h"
#import "MBProgressHUD.h"
#import "SHRouter.h"

@interface LanSettingViewController ()
{
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet SHTextField *ipTF;
@property (weak, nonatomic) IBOutlet SHTextField *maskTF;
@property (weak, nonatomic) IBOutlet SHRectangleButton *confirmButton;

@end

@implementation LanSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    hud.labelText = @"正在设置…";
    hud.dimBackground = YES;
    hud.minShowTime = 2.0;
}

- (void)viewDidAppear:(BOOL)animated {
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [hud removeFromSuperview];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)checkValid {
    
    if (_ipTF.text.length == 0) {
        [_ipTF shakeWithText:@"ip地址不能为空"];
        return NO;
    }
    
    if (_maskTF.text.length == 0) {
        [_maskTF shakeWithText:@"网关地址不能为空"];
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
    [sender resignFirstResponder];
}

- (IBAction)ok:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if (![self checkValid]) {
        return;
    }
    
    __block BOOL ret;
    
    [hud showAnimated:YES whileExecutingBlock:^{
        ret = [[SHRouter currentRouter] setLanIP:_ipTF.text Mask:_maskTF.text Error:nil];
    } completionBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SHAlert_Head
                                                        message:ret ? SHAlert_SetLanSuccess : SHAlert_SetLanFailed
                                                       delegate:nil
                                              cancelButtonTitle:SHAlert_OK
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

@end
