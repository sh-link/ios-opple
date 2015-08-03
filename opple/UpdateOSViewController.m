//
//  UpdateOSViewController.m
//  SHLink
//
//  Created by zhen yang on 15/4/20.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "UpdateOSViewController.h"
#import "TextUtil.h"
#import "OSVersionInfoView.h"
#import "SearchView.h"
#import "FaildView.h"
#import "SHRouter.h"
#import "SHRectangleButton.h"
#import "MessageUtil.h"
#import "DialogUtil.h"
#import "ErrorUtil.h"
#import "UserDefaultUtil.h"
#import "ErrorUtil.h"
#import "UIView+Extension.h"
#import "ScreenUtil.h"
#import "StringUtil.h"
#import "MJRefresh.h"
#import "ThreadUtil.h"
#define padding 15
#define sleepTimeNormal 5
#define maxCount 30

@interface UpdateOSViewController ()

@end

@implementation UpdateOSViewController
{
 
    OSVersionInfoView *_infoView;
    
    UIScrollView *_container;
    SearchView *_searchView;
    FaildView *_failedView;
    
    BOOL isUpdateOS;

    SHRectangleButton *_update;
    
    NSString *currentVersion;
    NSString *otaVersion;
    
    int updateCount;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"固件更新";
    updateCount = 0;
    _searchView = [SearchView initWithMsg:@"正在查询固件信息"];
    [self.view addSubview:_searchView];
    
    _failedView = [[FaildView alloc]init];
    [self.view addSubview:_failedView];
    
    _container = [[UIScrollView alloc]init];
    _container.backgroundColor = getColor(230, 230, 230, 255);
    [self.view addSubview:_container];
    
    _infoView = [[OSVersionInfoView alloc]init];
    [_infoView setTitle:@"更新固件"];
    
    
    [_container addSubview:_infoView];
    
    _update = [[SHRectangleButton alloc]init];
    [_update setTitle:@"更新" forState:UIControlStateNormal];
    [_update setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_container addSubview:_update];
   
    [_update addTarget:self action:@selector(updateOS:) forControlEvents:UIControlEventTouchUpInside];
    
    isUpdateOS = false;
    
    UpdateOSViewController *tmp = self;
    [_container addLegendHeaderWithRefreshingBlock:^{
        [tmp getOSInfo];
    }];
    
    [_failedView addLegendHeaderWithRefreshingBlock:^{
        [tmp getOSInfo];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self showSearchView];
    _container.frame = self.view.bounds;
    _infoView.center  = _container.center;
    _infoView.bounds = CGRectMake(0, 0, self.view.frame.size.width - 2*padding, _infoView.getHeight);
    
    _infoView.y = _infoView.y - [ScreenUtil getWidth] / 5;
     _update.frame = CGRectMake(padding, CGRectGetMaxY(_infoView.frame) + 2*padding, self.view.frame.size.width - 2 *padding, 50);
}

-(void)viewDidAppear:(BOOL)animated
{
    [self getOSInfo];
}

-(void)getOSInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error;
        NSDictionary *dic = [[SHRouter currentRouter] getOSVersionInfo:2 error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(dic)
            {
                //成功
                currentVersion = dic[@"CURRENT_VER"];
                otaVersion = dic[@"OTA_VER"];
                [StringUtil trim:currentVersion];
                [StringUtil trim:otaVersion];
                
                if([dic[@"IS_NEED_UPDATE"] intValue] == 0)
                {
                    isUpdateOS = false;
                }
                else
                {
                    isUpdateOS = true;
                }
                
                if(currentVersion == nil || [currentVersion isEqualToString:@""] || [currentVersion isEqualToString:@"0.0.0"])
                {
                    currentVersion = @"未知";
                    isUpdateOS = false;
                }
                
                if(otaVersion == nil || [otaVersion isEqualToString:@""] || [otaVersion isEqualToString:@"0.0.0"])
                {
                    otaVersion = @"未知";
                    isUpdateOS = false;
                }
                
                //修改信息
                [_infoView setCurrentVersion:currentVersion];
                [_infoView setOtaVersion:otaVersion];
                if(isUpdateOS)
                {
                    [_infoView setTitle:@"发现新固件"];
                    _update.hidden = false;
                }
                else
                {
                    [_infoView setTitle:@"无需更新"];
                    _update.hidden = true;
                }
                
                [self showNormal];
            }
            else
            {
                [self showFailedView:@"出错了，获取固件信息失败"];
                
            }
        });
        
    });

}

-(void)showNormal
{
    _container.hidden = false;
    _searchView.hidden = true;
    _failedView.hidden = true;
    [_container.header endRefreshing];
    [_failedView.header endRefreshing];
}

-(void)showSearchView
{
    _container.hidden = true;
    _searchView.hidden = false;
    _failedView.hidden = true;
    [_container.header endRefreshing];
    [_failedView.header endRefreshing];
}

-(void)showFailedView:(NSString*)msg
{
    _container.hidden = true;
    _searchView.hidden = true;
    _failedView.hidden = false;
    [_failedView setMessage:msg];
    [_container.header endRefreshing];
    [_failedView.header endRefreshing];
}

-(void)updateOS:(id)target
{
    [self showSearchView];
    [_searchView setMsg:@"正在请求设备更新固件"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for(int i = 0 ; i < maxCount;i++)
        {
            updateCount ++;
            NSError *error;
            NSDictionary *dic = [[SHRouter currentRouter]updateFireWare:2 error:&error];
            if(dic)
            {
              
                    //成功
                    int status = [dic[@"UPGRADE_STATUS"] intValue];
                    if(status == 0)
                    {
                        [ThreadUtil executeInMainThread:^{
                            [_searchView setMsg:@"设备已经接收到固件更新请求，正在下载固件"];
                        }];
                    }
                    else if(status == 1)
                    {
                       
                        [ThreadUtil executeInMainThread:^{
                            [_searchView setMsg:@"固件下载成功，正在更新固件"];
                        }];
                    }
                    else if(status == 2)
                    {
                        //固件更新成功
                        [ThreadUtil executeInMainThread:^{
                            [self.navigationController popViewControllerAnimated:true];
                            [DialogUtil createAndShowDialogWithTitle:@"固件更新成功" message:@"固件更新成功，路由器正在重启，请稍后自行连接wifi" handler:^(UIAlertAction *action) {
                                UINavigationController *nav = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                                [nav popToRootViewControllerAnimated:true];
                            }];
                        }];
                        //中断查询
                        break;
                    }
                    else if(status == 3)
                    {
                        
                        
                        [ThreadUtil executeInMainThread:^{
                            [DialogUtil createAndShowDialogWithTitle:@"固件下载失败" message:@"出错了，固件下载失败"];
                        }];
                        //中断查询
                        break;
                    }
                    else
                    {
                        [ThreadUtil executeInMainThread:^{
                            [DialogUtil createAndShowDialogWithTitle:@"固件下载失败" message:@"出错了，固件下载失败"];
                        }];
                        //中断请求
                        break;
                    }
                
            }
            else
            {
                //失败重试
            }
            //休眠
            sleep(sleepTimeNormal);
            DLog(@"睡眠%d秒==========================", sleepTimeNormal);
        }
        
        //如果循环完了仍然没有收到status == 2的响应，则认为更新失败了
        [ThreadUtil executeInMainThread:^{
            [self.navigationController popViewControllerAnimated:true];
            [DialogUtil createAndShowDialogWithTitle:@"更新失败" message:@"超时，更新可能已经失败"];
        }];
    });
}




@end
