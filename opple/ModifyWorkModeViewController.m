//
//  ModifyWorkModeViewController.m
//  opple
//
//  Created by zhen yang on 15/7/17.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "ModifyWorkModeViewController.h"
#import "ModifyRepeaterView.h"
#import "UIView+Extension.h"
#import "RadioButton.h"
#import "RadioGroup.h"
#import "ScreenUtil.h"
#import "ModifyRouterView.h"
#import "ModifyWorkModeViewHeader.h"
#import "RadioGroup3.h"
#import "SHRouter.h"
#import "ThreadUtil.h"
#import "MBProgressHUD+MJ.h"
#import "DialogUtil.h"
#import "StringUtil.h"
#import "MessageUtil.h"
#import "WifiListViewController.h"
#define padding 10
#define buttonHeight 30
@interface ModifyWorkModeViewController () <RadioGroup3Delegate, ModifyRouterView2Delegate, WifiListDelegate>
@end

@implementation ModifyWorkModeViewController
{
    ModifyWorkModeViewHeader *header;
    
    ModifyRouterView *router;
    ModifyRouterView *ap;
    ModifyRepeaterView *repeater;
    UIScrollView *container;
    UIView *content;
    SHRectangleButton *modify;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]init];
    self.navigationItem.backBarButtonItem.title = @"返回";

    self.title = @"修改工作模式";
    container = [UIScrollView new];
    container.frame = self.view.frame;
    container.height = self.view.height - 64;
    [self.view addSubview:container];
    container.backgroundColor = getColor(233, 233, 233, 233);
    
    content = [UIView new];
    content.x = padding;
    content.y = padding;
    content.width = self.view.width - 2 * padding;
    content.layer.cornerRadius = 5;
    content.layer.borderWidth = 1;
    content.layer.borderColor = getColor(0x80, 0x80, 0x80, 0x55).CGColor;
    content.backgroundColor = [UIColor whiteColor];
    
    [container addSubview:content];
    
    router = [ModifyRouterView new];
    ap = [ModifyRouterView new];
    repeater = [ModifyRepeaterView new];
    [repeater.connectwifi addTarget:self action:@selector(selectWifi) forControlEvents:UIControlEventTouchUpInside];
    
    router.hidden = true;
    ap.hidden = true;
    repeater.hidden = true;
    
    
    [content addSubview:router];
    [content addSubview:ap];
    [content addSubview:repeater];
    
    header = [ModifyWorkModeViewHeader new];
    [content addSubview:header];
    header.delegate = self;
    
    modify = [SHRectangleButton new];
    [modify setTitle:@"修改" forState:UIControlStateNormal];
    [container addSubview:modify];
    
    modify.x = 2 * padding;
    modify.width = self.view.width - 4 * padding;
    modify.height = 44;
    
    
    
    
    router.delegate = self;
    ap.delegate = self;
    //加号
    
    [modify addTarget:self action:@selector(modify) forControlEvents:UIControlEventTouchUpInside];
    

    NSDictionary *data = [SHRouter currentRouter].workModeInfo;
    int mode = [data[@"WLAN_MODE"] intValue];
    if(mode == 1)
    {
        //获取相关信息并填充
        //填充base
        //获取通信停产
        int channel = [data[@"WLAN_AP"][@"WLAN_CHANNEL"] intValue];
        NSArray *ssids = data[@"WLAN_AP"][@"SSID_LIST"];
        NSDictionary *baseDic = ssids[0];
        NSString *baseSsid = baseDic[@"SSID"];
        NSString *basePassword = baseDic[@"KEY"];
        int baseState = [baseDic[@"WLAN_SECURITY"] intValue];
        ap.base.field_base_ssid.text = baseSsid;
        ap.base.field_password.text = basePassword;
        if(channel == 0)
        {
            ap.base.field_channel.text = @"自动";
        }
        else
        {
            ap.base.field_channel.text = [NSString stringWithFormat:@"%d", channel];
        }
        
        if(baseState == 0)
        {
            ap.base.rg_encrypt_state.offButton.selected = true;
        }
        else
        {
            ap.base.rg_encrypt_state.onButton.selected = true;
        }
        if(ssids.count > 1)
        {
            [ap showSSID1];
            //填充ssid1
            NSDictionary *ssid1Dic = ssids[1];
            NSString *ssid1 = ssid1Dic[@"SSID"];
            NSString *password1 = ssid1Dic[@"KEY"];
            int state1 = [ssid1Dic[@"WLAN_SECURITY"] intValue];
            ap.one.field_ssid.text = ssid1;
            ap.one.field_password.text = password1;
            if(state1 == 0)
            {
                ap.one.rg_encrypt_state.offButton.selected = true;
            }
            else
            {
                ap.one.rg_encrypt_state.onButton.selected = true;
            }
        }
        if(ssids.count > 2)
        {
            [ap showSSID2];
            //填充ssid2
            NSDictionary *ssid2Dic = ssids[2];
            NSString *ssid2 = ssid2Dic[@"SSID"];
            NSString *password2 = ssid2Dic[@"KEY"];
            int state2 = [ssid2Dic[@"WLAN_SECURITY"] intValue];
            ap.two.field_ssid.text = ssid2;
            ap.two.field_password.text = password2;
            if(state2 == 0)
            {
                ap.two.rg_encrypt_state.offButton.selected = true;
            }
            else
            {
                ap.two.rg_encrypt_state.onButton.selected = true;
            }

            
        }
        
        if(ssids.count > 3)
        {
            [ap showSSID3];
            //填充ssid3
            NSDictionary *ssid3Dic = ssids[3];
            NSString *ssid3 = ssid3Dic[@"SSID"];
            NSString *password3 = ssid3Dic[@"KEY"];
            int state3 = [ssid3Dic[@"WLAN_SECURITY"] intValue];
            ap.three.field_ssid.text = ssid3;
            ap.three.field_password.text = password3;
            if(state3 == 0)
            {
                ap.three.rg_encrypt_state.offButton.selected = true;
            }
            else
            {
                ap.three.rg_encrypt_state.onButton.selected = true;
            }
        }

    }
    else if(mode == 2)
    {
       //获取repeater相关信息
        NSString *ssid = data[@"WLAN_REPEATER"][@"SSID"];
        NSString *bssid = data[@"WLAN_REPEATER"][@"BSSID"];
        NSString *key = data[@"WLAN_REPEATER"][@"KEY"];
        repeater.ssidField.text = ssid;
        repeater.macField.text = bssid;
        repeater.passwordField.text = key;
    }
    else
    {
        //获取相关信息并填充
        //填充base
        //获取通信停产
        int channel = [data[@"WLAN_ROUTER"][@"WLAN_CHANNEL"] intValue];
        NSArray *ssids = data[@"WLAN_ROUTER"][@"SSID_LIST"];
        NSDictionary *baseDic = ssids[0];
        NSString *baseSsid = baseDic[@"SSID"];
        NSString *basePassword = baseDic[@"KEY"];
        int baseState = [baseDic[@"WLAN_SECURITY"] intValue];
        router.base.field_base_ssid.text = baseSsid;
        router.base.field_password.text = basePassword;
        if(channel == 0)
        {
            router.base.field_channel.text = @"自动";
        }
        else
        {
            router.base.field_channel.text = [NSString stringWithFormat:@"%d", channel];
        }
        
        if(baseState == 0)
        {
            router.base.rg_encrypt_state.offButton.selected = true;
        }
        else
        {
            router.base.rg_encrypt_state.onButton.selected = true;
        }
        if(ssids.count > 1)
        {
            [router showSSID1];
            //填充ssid1
            NSDictionary *ssid1Dic = ssids[1];
            NSString *ssid1 = ssid1Dic[@"SSID"];
            NSString *password1 = ssid1Dic[@"KEY"];
            int state1 = [ssid1Dic[@"WLAN_SECURITY"] intValue];
            router.one.field_ssid.text = ssid1;
            router.one.field_password.text = password1;
            if(state1 == 0)
            {
                router.one.rg_encrypt_state.offButton.selected = true;
            }
            else
            {
                router.one.rg_encrypt_state.onButton.selected = true;
            }
        }
        if(ssids.count > 2)
        {
            [router showSSID2];
            //填充ssid2
            NSDictionary *ssid2Dic = ssids[2];
            NSString *ssid2 = ssid2Dic[@"SSID"];
            NSString *password2 = ssid2Dic[@"KEY"];
            int state2 = [ssid2Dic[@"WLAN_SECURITY"] intValue];
            router.two.field_ssid.text = ssid2;
            router.two.field_password.text = password2;
            if(state2 == 0)
            {
                router.two.rg_encrypt_state.offButton.selected = true;
            }
            else
            {
                router.two.rg_encrypt_state.onButton.selected = true;
            }
        }
        
        if(ssids.count > 3)
        {
            [router showSSID3];
            //填充ssid3
            NSDictionary *ssid3Dic = ssids[3];
            NSString *ssid3 = ssid3Dic[@"SSID"];
            NSString *password3 = ssid3Dic[@"KEY"];
            int state3 = [ssid3Dic[@"WLAN_SECURITY"] intValue];
            router.three.field_ssid.text = ssid3;
            router.three.field_password.text = password3;
            if(state3 == 0)
            {
                router.three.rg_encrypt_state.offButton.selected = true;
            }
            else
            {
                router.three.rg_encrypt_state.onButton.selected = true;
            }
        }
    }
    
    [header clickItem:mode];
}

-(void)selectWifi
{
    [self performSegueWithIdentifier:@"modifyworkmode2wifilist" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WifiListViewController *vc = (WifiListViewController*)segue.destinationViewController;
    vc.delegate = self;
}

-(void)modify
{
  
    NSDictionary *dataDic ;
       if(!router.isHidden)
    {
        //设置router
        NSMutableArray *ssids = [NSMutableArray new];
        NSString *baseSsid = router.base.field_base_ssid.text;
        if([StringUtil isEmpty:baseSsid])
        {
            [MessageUtil showShortToast:@"基本ssid不能为空"];
            return;
        }
        NSString *basePassword = router.base.field_password.text;
        
        int baseState = 0;
        if(router.base.rg_encrypt_state.onButton.isSelected)
        {
           baseState = 1;
            if([StringUtil isEmpty:basePassword])
            {
                [MessageUtil showShortToast:@"基本ssid连接密码不能为空"];
                return;
            }
        }
        else
        {
            baseState = 0;
        }
        
        [ssids addObject:@{@"SSID":baseSsid, @"WLAN_SECURITY":@(baseState), @"KEY":basePassword}];
        
        if(!router.one.isHidden)
        {
            NSString *ssid1 = router.one.field_ssid.text;
            if([StringUtil isEmpty:ssid1])
            {
                [MessageUtil showShortToast:@"无线ssid1名称不能为空"];
                return;
            }
            NSString *password1 = router.one.field_password.text;
            
            int state1 = 0;
            if(router.one.rg_encrypt_state.onButton.isSelected)
            {
                state1 = 1;
                if([StringUtil isEmpty:password1])
                {
                    [MessageUtil showShortToast:@"无线ssid1连接密码不能为空"];
                    return;
                }
            }
            else
            {
                state1 = 0;
            }
            [ssids addObject:@{@"SSID":ssid1, @"WLAN_SECURITY":@(state1), @"KEY": password1}];
        }
        
        if(!router.two.isHidden)
        {
            NSString *ssid2 = router.two.field_ssid.text;
            if([StringUtil isEmpty:ssid2])
            {
                [MessageUtil showShortToast:@"无线ssid2名称不能为空"];
                return;
            }
            NSString *password2 = router.two.field_password.text;
            
            int state2 = 0;
            if(router.two.rg_encrypt_state.onButton.isSelected)
            {
                state2 = 1;
                if([StringUtil isEmpty:password2])
                {
                    [MessageUtil showShortToast:@"无线ssid2连接密码不能为空"];
                    return;
                }
            }
            else
            {
                state2= 0;
            }
            [ssids addObject:@{@"SSID":ssid2, @"WLAN_SECURITY":@(state2), @"KEY": password2}];
        }
        
        if(!router.three.isHidden)
        {
            NSString *ssid3 = router.three.field_ssid.text;
            if([StringUtil isEmpty:ssid3])
            {
                [MessageUtil showShortToast:@"无线ssid3名称不能为空"];
                return;
            }
            NSString *password3 = router.three.field_password.text;
            
            int state3 = 0;
            if(router.three.rg_encrypt_state.onButton.isSelected)
            {
                state3 = 1;
                
                if([StringUtil isEmpty:password3])
                {
                    [MessageUtil showShortToast:@"无线ssid3连接密码不能为空"];
                    return;
                }
            }
            else
            {
                state3= 0;
            }
            [ssids addObject:@{@"SSID":ssid3, @"WLAN_SECURITY":@(state3), @"KEY": password3}];
        }
        //获取通信信道
        if([StringUtil isEmpty:router.base.field_channel.text])
        {
            [MessageUtil showShortToast:@"通信信道不能为空"];
            return;
        }
       
        int channel = 0;
        if([router.base.field_channel.text isEqualToString:@"自动"])
        {
            channel = 0;
        }
        else
        {
            channel  = [router.base.field_channel.text intValue];
        }
        if(channel < 0 || channel > 11)
        {
            [MessageUtil showShortToast:@"通信信道不合法，必须为0到11的数字"];
        }
       dataDic = @{@"REQ_TYPE":@522, @"WLAN_MODE":@0, @"WLAN_ROUTER":@{@"WLAN_ENABLE":@1, @"WLAN_CHANNEL":@(channel), @"SSID_LIST":ssids}, @"WLAN_AP":@{}, @"WLAN_REPEATER":@{}};
        
    }
    else if(!ap.isHidden)
    {
        //设置ap
        NSMutableArray *ssids = [NSMutableArray new];
        NSString *baseSsid = ap.base.field_base_ssid.text;
        if([StringUtil isEmpty:baseSsid])
        {
            [MessageUtil showShortToast:@"基本ssid名称不能为空"];
            return;
        }
        NSString *basePassword = ap.base.field_password.text;
        
        int baseState = 0;
        if(ap.base.rg_encrypt_state.onButton.isSelected)
        {
            baseState = 1;
            if([StringUtil isEmpty:basePassword])
            {
                [MessageUtil showShortToast:@"基本ssid连接密码不能为空"];
                return;
            }
        }
        else
        {
            baseState = 0;
        }
        
        [ssids addObject:@{@"SSID":baseSsid, @"WLAN_SECURITY":@(baseState), @"KEY":basePassword}];
        
        if(!ap.one.isHidden)
        {
            NSString *ssid1 = ap.one.field_ssid.text;
            if([StringUtil isEmpty:ssid1])
            {
                [MessageUtil showShortToast:@"无线ssid1名称不能为空"];
                return;
            }
            NSString *password1 = ap.one.field_password.text;
           
            int state1 = 0;
            if(ap.one.rg_encrypt_state.onButton.isSelected)
            {
                state1 = 1;
                if([StringUtil isEmpty:password1])
                {
                    [MessageUtil showShortToast:@"无线ssid1连接密码不能为空"];
                    return;
                }
            }
            else
            {
                state1 = 0;
            }
            [ssids addObject:@{@"SSID":ssid1, @"WLAN_SECURITY":@(state1), @"KEY": password1}];
        }
        
        if(!ap.two.isHidden)
        {
            NSString *ssid2 = ap.two.field_ssid.text;
            if([StringUtil isEmpty:ssid2])
            {
                [MessageUtil showShortToast:@"无线ssid2名称不能为空"];
                return;
            }
            NSString *password2 = ap.two.field_password.text;
            
            int state2 = 0;
            if(ap.two.rg_encrypt_state.onButton.isSelected)
            {
                state2 = 1;
                if([StringUtil isEmpty:password2])
                {
                    [MessageUtil showShortToast:@"无线ssid2连接密码不能为空"];
                    return;
                }
            }
            else
            {
                state2= 0;
            }
            [ssids addObject:@{@"SSID":ssid2, @"WLAN_SECURITY":@(state2), @"KEY": password2}];
        }
        
        if(!ap.three.isHidden)
        {
            NSString *ssid3 = ap.three.field_ssid.text;
            if([StringUtil isEmpty:ssid3])
            {
                [MessageUtil showShortToast:@"无线ssid3名称不能为空"];
                return;
            }
            NSString *password3 = ap.three.field_password.text;
            
            int state3 = 0;
            if(ap.three.rg_encrypt_state.onButton.isSelected)
            {
                state3 = 1;
                if([StringUtil isEmpty:password3])
                {
                    [MessageUtil showShortToast:@"无线ssid3连接密码不能为空"];
                    return;
                }
            }
            else
            {
                state3= 0;
            }
            [ssids addObject:@{@"SSID":ssid3, @"WLAN_SECURITY":@(state3), @"KEY": password3}];
        }
        //获取通信信道
        if([StringUtil isEmpty:ap.base.field_channel.text])
        {
            [MessageUtil showShortToast:@"通信信道不能为空"];
            return;
        }
        
        
        int channel  = 0;
        if([ap.base.field_channel.text isEqualToString:@"自动"])
        {
            channel = 0;
        }
        else
        {
            channel = [ap.base.field_channel.text intValue];
        }
        if(channel < 0 || channel > 11)
        {
            [MessageUtil showShortToast:@"通信信道不合法，必须为0到11的数字"];
            return;
        }
        dataDic = @{@"REQ_TYPE":@522, @"WLAN_MODE":@1, @"WLAN_AP":@{@"WLAN_ENABLE":@1, @"WLAN_CHANNEL":@(channel), @"SSID_LIST":ssids}, @"WLAN_ROUTER":@{}, @"WLAN_REPEATER":@{}};
    }
    else if(!repeater.isHidden)
    {
        //设置repeater
       
        //获取ssid,bassid, password
        NSString *ssid = repeater.ssidField.text;
        if([StringUtil isEmpty:ssid])
        {
            [MessageUtil showShortToast:@"请输入要连接的无线ssid名称"];
            return;
        }
        NSString *bssid = repeater.macField.text;
        if([StringUtil isEmpty:bssid])
        {
            [MessageUtil showShortToast:@"请输入mac地址"];
            return;
        }
        NSString *key = repeater.passwordField.text;
        [StringUtil trim:key];
        dataDic = @{@"REQ_TYPE":@522, @"WLAN_MODE":@2, @"WLAN_ROUTER":@{}, @"WLAN_AP":@{}, @"WLAN_REPEATER":@{
                            @"SSID":ssid, @"BSSID":bssid, @"KEY":key}};
    }
    
    //发送指令
    [MBProgressHUD showMessage:@"正在设置"];
    [ThreadUtil execute:^{
        NSError *error;
        BOOL result = [[SHRouter currentRouter] modifyWorkMode:dataDic error:&error];
        
        [ThreadUtil executeInMainThread:^{
            [MBProgressHUD hideHUD];
            if(result)
            {
                //修改成功
                [DialogUtil createAndShowDialogWithTitle:@"设置成功" message:@"设置成功,请等待路由器重启生效，稍后请自行连接wifi" handler:^(UIAlertAction *action) {
                    [self.navigationController popToRootViewControllerAnimated:true];
                }];
                
            }
            else
            {
                //修改失败
                [DialogUtil createAndShowDialogWithTitle:@"设置失败" message:@"出错了，设置失败"];
            }

        }];
    }];
}

-(void)showRouter
{
    
    header.frame = CGRectMake(0, 0, content.width, header.height);
    repeater.frame = CGRectMake(0, CGRectGetMaxY(header.frame), content.width, repeater.height);
    router.frame = CGRectMake(0, CGRectGetMaxY(header.frame), content.width, router.height);
    ap.frame = CGRectMake(0, CGRectGetMaxY(header.frame), content.width, ap.height);

    router.hidden = false;
    ap.hidden = true;
    repeater.hidden = true;
    content.height = CGRectGetMaxY(router.frame);
    modify.y = CGRectGetMaxY(content.frame) + padding;
    container.contentSize = CGSizeMake(0, CGRectGetMaxY(modify.frame) + padding);
    [self updateRightBarButton];
}

-(void)showAp
{
    header.frame = CGRectMake(0, 0, content.width, header.height);
    repeater.frame = CGRectMake(0, CGRectGetMaxY(header.frame), content.width, repeater.height);
    router.frame = CGRectMake(0, CGRectGetMaxY(header.frame), content.width, router.height);
    ap.frame = CGRectMake(0, CGRectGetMaxY(header.frame), content.width, ap.height);

    router.hidden = repeater.hidden = true;
    ap.hidden = false;
    content.height = CGRectGetMaxY(ap.frame);
    modify.y = CGRectGetMaxY(content.frame) + padding;
    container.contentSize = CGSizeMake(0, CGRectGetMaxY(modify.frame) + padding);
    [self updateRightBarButton];
}

-(void)showRepeater
{
    header.frame = CGRectMake(0, 0, content.width, header.height);
    repeater.frame = CGRectMake(0, CGRectGetMaxY(header.frame), content.width, repeater.height);
    router.frame = CGRectMake(0, CGRectGetMaxY(header.frame), content.width, router.height);
    ap.frame = CGRectMake(0, CGRectGetMaxY(header.frame), content.width, ap.height);

    repeater.hidden = false;
    router.hidden = ap.hidden = true;
    content.height = CGRectGetMaxY(repeater.frame);
    modify.y = CGRectGetMaxY(content.frame) + padding;
    container.contentSize = CGSizeMake(0, CGRectGetMaxY(modify.frame) + padding);
    [self updateRightBarButton];
}


-(void)itemSelected:(int)index
{
    if(index == 0)
    {
        [self showRouter];
    }
    else if(index == 1)
    {
        [self showAp];
    }
    else
    {
        [self showRepeater];
    }
}


-(void)updateRightBarButton
{
    if((!router.isHidden && (router.one.isHidden || router.two.isHidden || router.three.isHidden)) ||(!ap.isHidden && (ap.one.isHidden || ap.two.isHidden || ap.three.isHidden)))
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}


-(void)add
{
    if(!router.isHidden)
    {
        if(router.one.isHidden)
        {
            [router showSSID1];
        }
        else if(router.two.isHidden)
        {
            [router showSSID2];
        }
        else if(router.three.isHidden)
        {
            [router showSSID3];
        }
        [self showRouter];
    }
    
    if(!ap.isHidden)
    {
        if(ap.one.isHidden)
        {
            [ap showSSID1];
        }
        else if(ap.two.isHidden)
        {
            [ap showSSID2];
        }
        else if(ap.three.isHidden)
        {
            [ap showSSID3];
        }
        [self showAp];
    }
}

-(void)deleteMyself:(ModifyRouterView2 *)view
{
    if(view == router.one)
    {
        [router hideSSID1];
    }
    else if(view == router.two)
    {
        [router hideSSID2];
    }
    else if(view == router.three)
    {
        [router hideSSID3];
    }
    else if(view == ap.one)
    {
        [ap hideSSID1];
    }
    else if(view == ap.two)
    {
        [ap hideSSID2];
    }
    else
    {
        [ap hideSSID3];
    }
    
    if(!router.isHidden)
    {
        [self showRouter];
    }
    else if(!ap.isHidden)
    {
        [self showAp];
    }
}

-(void)passSSID:(NSString *)ssid withMac:(NSString *)mac
{
    repeater.ssidField.text = ssid;
    repeater.macField.text = mac;
}



@end
