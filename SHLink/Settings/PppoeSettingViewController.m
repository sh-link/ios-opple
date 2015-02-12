//
//  PppoeSettingViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/2/1.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "PppoeSettingViewController.h"
#import "SHTextField.h"
#import "SHRectangleButton.h"
#import "MBProgressHUD.h"
#import "SHRouter.h"

@interface PppoeSettingViewController ()
{
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet SHTextField *accountTF;
@property (weak, nonatomic) IBOutlet SHTextField *pswTF;
@property (weak, nonatomic) IBOutlet SHRectangleButton *confirmBT;

@end

@implementation PppoeSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _accountTF.shLeftImage = [UIImage imageNamed:@"iconTest3"];
    _pswTF.shLeftImage = [UIImage imageNamed:@"iconTest3"];
    
    hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    hud.labelText = @"正在设置…";
    hud.dimBackground = YES;
    hud.minShowTime = 2.0;
    // Do any additional setup after loading the view.
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
    
    if (_accountTF.text.length == 0) {
        [_accountTF shakeWithText:@"账号不能为空"];
        return NO;
    }
    
    if (_pswTF.text.length == 0) {
        [_pswTF shakeWithText:@"密码不能为空"];
        return NO;
    }
    
    return YES;
}

- (IBAction)viewTouchDown:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)accoutDidEndOnExit:(id)sender {
    [_pswTF becomeFirstResponder];
}

- (IBAction)pswDidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)ok:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if (![self checkValid]) {
        return;
    }
    
    __block BOOL ret;
    
    [hud showAnimated:YES whileExecutingBlock:^{
        ret = [[SHRouter currentRouter] setWanPPPoEWithUsername:_accountTF.text Password:_pswTF.text Error:nil];
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
