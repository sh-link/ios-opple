//
//  NetInfoViewController2.m
//  opple
//
//  Created by zhen yang on 15/7/16.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "NetInfoViewController2.h"
#import "FaildView.h"
#import "CellItem.h"
#import "CellItemGroup.h"
#import "ThreadUtil.h"
#import "SHRouter.h"
#import "Header.h"
#import "StringUtil.h"
#import "NetInfoCell3.h"
#import "MessageUtil.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"
@interface NetInfoViewController2 ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation NetInfoViewController2
{
    UITableView *_table;
    FaildView *_failedView;
    NSArray *_datas;
    
    BOOL close[3];
    
    Header *demo;
    NetInfoCell3 *cellDemo;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    close[0] = true;
    close[1] = true;
    close[2] = true;
    _table = [[UITableView alloc]init];
    _failedView = [[FaildView alloc]init];
    [_failedView setMessage:@"获取网络信息失败"];
    _table.backgroundColor = getColor(0xf5, 0xf5, 0xf5, 255);
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_table];
    [self.view addSubview:_failedView];
    
    _failedView.hidden = true;
    
    _table.dataSource = self;
    _table.delegate = self;
    
    demo = [[Header alloc]init];
    cellDemo = [[NetInfoCell3 alloc]init];
    
    NetInfoViewController2 *tmp = self;
    [_table addLegendHeaderWithRefreshingBlock:^{
        [tmp getNetInfo];
    }];
    [_failedView addLegendHeaderWithRefreshingBlock:^{
        [tmp getNetInfo];
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    _table.x = _table.y = 0;
    _table.width = self.view.width;
    _table.height = self.view.height    ;
    [_table.header beginRefreshing];
}


-(void)getNetInfo
{
    [ThreadUtil execute:^{
        NSError *error;
        NSDictionary *dic = [[SHRouter currentRouter]getNetworkSettingInfoWithError:&error];
        if(dic)
        {
            //成功
            //构造数据
            NSString *mode = @"";
            SHRouter *router = [SHRouter currentRouter];
            if(router.wlan_mode == WORK_MODE_AP)
            {
                mode = @"ap模式";
            }
            else if(router.wlan_mode == WORK_MODE_REPEATER)
            {
                mode = @"repeater模式";
            }
            else
            {
                mode = @"router模式";
            }
            CellItem *wlan_mode = [CellItem cellItemWithTitle:@"工作模式" value:mode];
            CellItem *wlan_mac = [CellItem cellItemWithTitle:@"mac地址" value:router.wlan_mac];
            CellItem *ssid = [CellItem cellItemWithTitle:@"网络名称" value:router.ssid];
            [StringUtil trim:router.wifiKey];
            if(router.wifiKey.length <= 0)
            {
                router.wifiKey = @"无密码";
            }
            CellItem *passwd = [CellItem cellItemWithTitle:@"连接密码" value:router.wifiKey];
            
            NSString *channelStr = @"";
            if(router.channel == 0)
            {
                channelStr = @"自动";
            }
            else
            {
                channelStr = [NSString stringWithFormat:@"%d", router.channel];
            }
            CellItem *channel = [CellItem cellItemWithTitle:@"通信信道" value:channelStr];
            
            CellItemGroup *wlan_group = [CellItemGroup cellGroupWithTitle:@"无线信息" items:@[wlan_mode, wlan_mac, ssid, passwd, channel]];
            
            CellItem *wan_mac = [CellItem cellItemWithTitle:@"mac地址" value:router.wan_mac];
            CellItem *wan_ip = [CellItem cellItemWithTitle:@"ip地址" value:router.wanIp];
            CellItem *wan_mask = [CellItem cellItemWithTitle:@"mask掩码" value:router.wanMask];
            CellItem *wan_gateWay = [CellItem cellItemWithTitle:@"网关地址" value:router.wanGateway];
            CellItem *wan_dns1 = [CellItem cellItemWithTitle:@"dns1" value:router.dns1];
            CellItem *wan_dns2 = [CellItem cellItemWithTitle:@"dns2" value:router.dns2];
            CellItem *wan_send = [CellItem cellItemWithTitle:@"发出的字节数" value:[NSString stringWithFormat:@"%lld", router.txPktNum]];
            CellItem *wan_recv = [CellItem cellItemWithTitle:@"接收的字节数" value:[NSString stringWithFormat:@"%lld", router.txPktNum]];
            
            CellItemGroup *wan_group = [CellItemGroup cellGroupWithTitle:@"wan口信息" items:@[wan_mac, wan_ip, wan_mask, wan_gateWay, wan_dns1, wan_dns2, wan_send, wan_recv]];
            
            CellItem *lan_mac = [CellItem cellItemWithTitle:@"mac地址" value:router.lan_mac];
            CellItem *lan_ip = [CellItem cellItemWithTitle:@"ip地址" value:router.lan_ip];
            CellItem *lan_mask = [CellItem cellItemWithTitle:@"mask掩码" value:router.lan_mask];
            CellItemGroup *lan_group = [CellItemGroup cellGroupWithTitle:@"lan口信息" items:@[lan_mac, lan_ip, lan_mask]];
            
            _datas = @[wlan_group, wan_group, lan_group];
        
            [ThreadUtil executeInMainThread:^{
                [self showNormal];
            }];
        }
        else
        {
            //失败
            [ThreadUtil executeInMainThread:^{
                [self showFailed];
            }];
        }
    }];
}


-(void)showNormal
{
    _table.hidden = false;
    _failedView.hidden = true;
    [_table reloadData];
    [_table.header endRefreshing];
    [_failedView.header endRefreshing];
}

-(void)showFailed
{
    _table.hidden = true;
    _failedView.hidden = false;
    [_table.header endRefreshing];
    [_failedView.header endRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DLog(@"numberOfRowsInSection = %d", section);
    if(close[section])
    {
        return 0;
    }
    else
    {
        CellItemGroup *group = _datas[section];
        DLog(@"group.count = %d", group.cells.count);
        return group.cells.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    DLog(@"计算分组数%d", _datas.count);
    return _datas.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"in section %d, in row %d", indexPath.section, indexPath.row);
    CellItemGroup *group = _datas[indexPath.section];
    CellItem *item = group.cells[indexPath.row];
    
    NetInfoCell3 *cell = [NetInfoCell3 cellFromTableView:tableView];
    DLog(@"cell = %@", cell);
    cell.valueLabel.text = item.value;
    cell.hintLabel.text = item.title;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return cellDemo.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    DLog(@"get header height = %f", demo.height);
    return demo.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DLog(@"create header");
    CellItemGroup *group = _datas[section];
    Header *header = [Header new];
    header.tag = section;
    [header addTarget:self action:@selector(clickHeader:) forControlEvents:UIControlEventTouchUpInside];
    header.title = group.title;
    if(close[section])
    {
        //需要关闭
        [header normal];
        
    }
    else
    {
        //需要展开
        [header rotate];
    }

    return header;
}

-(void)clickHeader:(Header*)header
{
    
    int index = header.tag;
       close[index] = !close[index];
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:index];
    [_table reloadSections:indexSet withRowAnimation:0];
}
@end
