//
//  DhcpSettingViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/2/1.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "DhcpSettingViewController.h"
#import "SHRouter.h"
#import "MBProgressHUD.h"

@interface DhcpSettingViewController ()
{
    MBProgressHUD *hud;
}

@end

@implementation DhcpSettingViewController

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

- (IBAction)ok:(id)sender {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    __block BOOL ret;
    
    [hud showAnimated:YES whileExecutingBlock:^{
        ret = [[SHRouter currentRouter] setWanDHCPWithError:nil];
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
