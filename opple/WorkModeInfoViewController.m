//
//  WorkModeInfoViewController.m
//  opple
//
//  Created by zhen yang on 15/7/16.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "WorkModeInfoViewController.h"
#import "RouterModeView.h"
#import "ScreenUtil.h"
#import "UIView+Extension.h"
#import "ThreadUtil.h"
#import "SHRouter.h"
#import "RepeaterView.h"
#import "MessageUtil.h"
#import "SHRectangleButton.h"
#import "FaildView.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#define padding 10
@interface WorkModeInfoViewController ()

@end

@implementation WorkModeInfoViewController
{
    RouterModeView *routerView;
    RouterModeView *apView;
    RepeaterView *repeaterView;
    SHRectangleButton *modify;
    
    FaildView *failedView;
    UIScrollView *scrollView;
    
    int mode;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作模式";
    self.navigationItem.backBarButtonItem.title = @"返回";
    failedView = [[FaildView alloc]init];
    [failedView setMessage:@"查询无线工作信息失败"];
    scrollView = [[UIScrollView alloc]init];
    failedView.frame = self.view.frame;
    scrollView.frame =self.view.frame;
    [self.view addSubview:failedView];
    [self.view addSubview:scrollView];
    failedView.hidden = true;
    
    routerView = [RouterModeView RouterModeViewWithMaxHeight:self.view.height - 108 - 2 *padding - 44 - 2 * padding];
    [scrollView addSubview:routerView];
    
    apView = [RouterModeView RouterModeViewWithMaxHeight:self.view.height - 108 - 2 * padding- 44 - 2 * padding];
    
    [scrollView addSubview:apView];
    
    repeaterView = [RepeaterView new];
    [scrollView addSubview:repeaterView];
    
    modify = [[SHRectangleButton alloc]init];
    [scrollView addSubview:modify];
    
    
    repeaterView.x = repeaterView.y = apView.x = apView.y = routerView.x = routerView.y = padding;
    repeaterView.width = routerView.width = apView.width = [ScreenUtil getWidth] - 2 * padding;
    
    modify.x = padding;
    modify.width = [ScreenUtil getWidth] - 2 * padding;
    modify.height = 44;
    
    routerView.hidden = true;
    apView.hidden = true;
    repeaterView.hidden = true;
    modify.hidden = true;
   
    
    [modify setTitle:@"更改工作模式" forState:UIControlStateNormal];

    WorkModeInfoViewController *tmp = self;
    
    [scrollView addLegendHeaderWithRefreshingBlock:^{
        [tmp getModeInfo];
    }];
    
    [failedView addLegendHeaderWithRefreshingBlock:^{
        [tmp getModeInfo];
    }];
    
    [scrollView.header beginRefreshing];
    
    [modify addTarget:self action:@selector(modify) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)getModeInfo
{
    [ThreadUtil execute:^{
        NSError *error;
        NSMutableDictionary *dic = [[SHRouter currentRouter] getWorkModeInfo:&error];
        if(dic)
        {
            //成功
            [ThreadUtil executeInMainThread:^{
                //获取当前工作模式
                mode = [dic[@"WLAN_MODE"] intValue];
                if(mode == 0)
                {
                    [routerView setData:dic];
                    [self showRouter];
                }
                else if(mode == 1)
                {
                    [apView setData:dic];
                    [self showAp];
                }
                else
                {
                    [repeaterView setData:dic];
                    [self showRepeater];
                }
                modify.hidden = false;
                if(mode == 0)
                {
                    modify.y = CGRectGetMaxY(routerView.frame) + padding;
                }
                else if(mode == 1)
                {
                    modify.y = CGRectGetMaxY(apView.frame) + padding;
                }
                else
                {
                    modify.y = CGRectGetMaxY(repeaterView.frame) + padding;
                }

            }];
            
        }
        else
        {
            //失败
            [ThreadUtil executeInMainThread:^{
                [self showFailedView];
            }];
            
           
        }
    }];
}

-(void)showRouter
{
    apView.hidden = true;
    routerView.hidden = false;
    repeaterView.hidden = true;
    scrollView.hidden = false;
    failedView.hidden = true;
    [scrollView.header endRefreshing];
    [failedView.header endRefreshing];
}

-(void)showAp
{
    apView.hidden = false;
    DLog(@"apView.frame ========================= %@", NSStringFromCGRect(apView.frame));
    routerView.hidden = true;
    repeaterView.hidden = true;
    scrollView.hidden = false;
    failedView.hidden = true;
    [scrollView.header endRefreshing];
    [failedView.header endRefreshing];
}

-(void)showRepeater
{
    apView.hidden = true;
    routerView.hidden = true;
    repeaterView.hidden = false;
    scrollView.hidden = false;
    failedView.hidden = true;
    [scrollView.header endRefreshing];
    [failedView.header endRefreshing];
}


-(void)showFailedView
{
    failedView.hidden = false;
    scrollView.hidden  = true;
    [scrollView.header endRefreshing];
    [failedView.header endRefreshing];
}

-(void)modify
{
    [self performSegueWithIdentifier:@"goToModifyWorkMode" sender:self];
}



@end
