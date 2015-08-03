//
//  SHSetupTabBarController.m
//  SHLink
//
//  Created by zhen yang on 15/3/19.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHSetupTabBarController.h"
#import "SHSetupTabBar.h"
#import "UIView+Extension.h"
#import "SHRouter.h"
#import "MessageUtil.h"
#import "MBProgressHUD+MJ.h"
#import "ThreadUtil.h"
#import "DialogUtil.h"
@interface SHSetupTabBarController () <SHSetupTabBarDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) SHSetupTabBar* shTabBar;
@end

@implementation SHSetupTabBarController
{
    UIBarButtonItem *rightButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]init];
    
    self.navigationItem.backBarButtonItem.title = @"返回";
    rightButton = [[UIBarButtonItem alloc]initWithTitle:@"关闭wifi" style:0 target:self action:@selector(closewifi)];
    self.navigationItem.rightBarButtonItem = rightButton;
    DLog(@"setup load");
    //将系统默认的tabBar移除,用自定义的tabBar替换
    [self.tabBar removeFromSuperview];
    if([SHRouter currentRouter].current_work_mode == WORK_MODE_ROUTER)
    {
        _shTabBar = [[SHSetupTabBar alloc]initShowWan:true];
    }
    else
    {
        _shTabBar = [[SHSetupTabBar alloc]initShowWan:false];
    }
    
    _shTabBar.delegate = self;
    _shTabBar.frame = CGRectMake(self.tabBar.x, self.tabBar.y - bar_length, self.tabBar.width, self.tabBar.height);
    [self.view addSubview:_shTabBar];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //
        NSError *error;
        [[SHRouter currentRouter]getWanInfo:&error];
    });
    
    if(self.gotoWan)
    {
        [_shTabBar wanTap];
    }
}

-(void)onclickForTabBar:(int)index
{
    self.selectedIndex = index;
    if(index == 0)
    {
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}


-(void)closewifi
{
    [DialogUtil createAndShowDialogWithTitle:@"关闭wifi" message:@"您确定要关闭wifi吗，关闭后您将暂时断开wifi连接" cancelTitle:@"取消" okTitle:@"确定" delegate:self];
   }

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [MBProgressHUD showMessage:@"正在向路由器发送关闭wifi请求"];
        [ThreadUtil execute:^{
            NSError *error;
            BOOL result = [[SHRouter currentRouter] closeWifi:&error];
            sleep(1);
            [ThreadUtil executeInMainThread:^{
                [MBProgressHUD hideHUD];
                if(result)
                {
                    [DialogUtil createAndShowDialogWithTitle:@"成功关闭wifi" message:@"您已经成功关闭wifi" handler:^(UIAlertAction *action) {
                        [self.navigationController popToRootViewControllerAnimated:true];
                    }];
                }
                else
                {
                    //失败
                    [DialogUtil createAndShowDialogWithTitle:@"关闭wifi失败" message:@"出错了，请求路由器关闭wifi失败"];
                }
            }];
        }];

    }
}


@end
