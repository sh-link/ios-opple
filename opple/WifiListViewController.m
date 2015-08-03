//
//  WifiListViewController.m
//  opple
//
//  Created by zhen yang on 15/7/21.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "WifiListViewController.h"
#import "ThreadUtil.h"
#import "SHRouter.h"
#import "FaildView.h"
#import "UIView+Extension.h"
#import "ThreadUtil.h"
#import "SHRouter.h"
#import "WifiListCell.h"
#import "WifiListInfo.h"
#import "WifiListCellFrame.h"
#import "MJRefresh.h"
#import "StringUtil.h"

@interface WifiListViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation WifiListViewController
{
    UITableView *_tableView;
    FaildView *_failedView;
    
    NSMutableArray *frames;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"无线列表";
    

    frames = [NSMutableArray new];
    
    _tableView = [UITableView new];
    _failedView = [FaildView new];
    _failedView.hidden = true;
    [_failedView setMessage:@"出错了，查询wifi列表失败"];
    [self.view addSubview:_tableView];
    [self.view addSubview:_failedView];
    _tableView.frame = _failedView.frame = self.view.frame;
    _tableView.height = _failedView.height = self.view.height - 64;
    
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = 0;
    
    
    WifiListViewController *tmp = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [tmp getWifiList];
    }];
    
    [_failedView addLegendHeaderWithRefreshingBlock:^{
        [tmp getWifiList];
    }];
    
    [_tableView.header beginRefreshing];
}

-(void)getWifiList
{
    [ThreadUtil execute:^{
        NSError *error;
        NSDictionary * dic = [[SHRouter currentRouter] getWifiList:&error];
        [ThreadUtil executeInMainThread:^{
            if(dic)
            {
                NSArray *array = dic[@"AP_INFO"];
                for(NSDictionary *infoDic in array)
                {
                    //获取mac地址
                    NSString *mac = infoDic[@"BSSID"];
                    if([StringUtil isEmpty:mac])
                    {
                        continue;
                    }
                    WifiListInfo *info = [WifiListInfo new];
                    info.ssid = [NSString stringWithFormat:@"ssid名称: %@", infoDic[@"SSID"]];
                    info.mac = [NSString stringWithFormat:@"mac地址: %@", infoDic[@"BSSID"]];
                    info.encryptWay = [NSString stringWithFormat:@"加密方式: %@", infoDic[@"KEY_TYPE"]];
                    
                    info.channel = [NSString stringWithFormat:@"通信信道: %@", infoDic[@"CHANNEL"]];

                    WifiListCellFrame *frame = [WifiListCellFrame new];
                    frame.info = info;
                    [frames addObject:frame];
                }
                
                [self showNormal];
            }
            else
            {
                [self showFaield];
            }
        }];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return frames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WifiListCell *cell = [WifiListCell cellForWifiListCell:tableView];
    cell.cellFrame = frames[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WifiListCellFrame *frame = frames[indexPath.row];
    return frame.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //获取选中的项目
    WifiListCellFrame *frame = frames[indexPath.row];
    NSString *ssid = [frame.info.ssid substringFromIndex:8];
    NSString *mac = [frame.info.mac substringFromIndex:7];
    [self.delegate passSSID:ssid withMac:mac];
    [self.navigationController popViewControllerAnimated:true];
    
}

-(void)showNormal
{
    _tableView.hidden = false;
    _failedView.hidden = true;
    [_tableView reloadData];
    [_tableView.header endRefreshing];
    [_failedView.header endRefreshing];
}

-(void)showFaield
{
    _tableView.hidden = true;
    _failedView.hidden = false;
    [_tableView.header endRefreshing];
    [_failedView.header endRefreshing];
}

@end
