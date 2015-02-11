//
//  WifiSettingViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/1/26.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "WifiSettingViewController.h"
#import "SHTextField.h"
#import "CMPopTipView.h"
#import "MBProgressHUD.h"
#import "SHRouter.h"

#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define successTag 10086
@interface WifiSettingViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet SHTextField *ssidTF;
@property (weak, nonatomic) IBOutlet SHTextField *pswTF;
@property (weak, nonatomic) IBOutlet SHTextField *retypePswTF;

@end

@implementation WifiSettingViewController
{
    MBProgressHUD *hud;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tabBarController.navigationItem.title = @"设置";
    
    _ssidTF.shLeftImage  = [UIImage imageNamed:@"iconTest3"];
    
    _pswTF.shLeftImage = [UIImage imageNamed:@"iconTest3"];
    
    _retypePswTF.shLeftImage = [UIImage imageNamed:@"iconTest3"];
    
    _ssidTF.text = [SHRouter currentRouter].ssid;
    
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

#pragma mark - Tools
#pragma mark -

- (BOOL)checkValid {
    
    if (_ssidTF.text.length == 0) {
        [_ssidTF shakeWithText:@"WiFi名称不能为空"];
        return NO;
    }
    
    if (_pswTF.text.length == 0) {
        [_pswTF shakeWithText:@"无线密码不能为空"];
        return NO;
    }
    
    if (![_pswTF.text isEqualToString:_retypePswTF.text]) {
        [_pswTF shakeWithText:nil];
        [_retypePswTF shakeWithText:@"两次输入的密码不一致"];
        return NO;
    }
    
    return YES;
}

#pragma mark - Actions
#pragma mark - 

- (IBAction)ssidDidEndOnExit:(id)sender {
    [_pswTF becomeFirstResponder];
}

- (IBAction)pswDidEndOnExit:(id)sender {
    [_retypePswTF becomeFirstResponder];
}

- (IBAction)retypePswDidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)viewTouchDown:(id)sender {
     [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)ok:(id)sender {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if (![self checkValid]) {
        return;
    }
    
    __block BOOL ret;
    
    [hud showAnimated:YES whileExecutingBlock:^{
        ret = [[SHRouter currentRouter] setWifiWithSsid:_ssidTF.text WifiKey:_pswTF.text Channel:0 Error:nil];
    } completionBlock:^{
        if (ret) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SHAlert_Head
                                                            message:[NSString stringWithFormat:@"设置成功，请将手机连接到网络\"%@\"以重新登陆。",_ssidTF.text]
                                                           delegate:self
                                                  cancelButtonTitle:SHAlert_OK
                                                  otherButtonTitles:nil];
            alert.tag = successTag;
            [alert show];
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SHAlert_Head
                                                            message:SHAlert_SetWiFiFailed
                                                           delegate:nil
                                                  cancelButtonTitle:SHAlert_OK
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
    
}

#pragma mark - UIAlertViewDelegate
#pragma mark -


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == successTag) {
        
        if (![SHRouter currentRouter].directLogin) {
            [[SHRouter currentRouter] setLoginNeedDismiss:YES];
        }

        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    }
}

@end
