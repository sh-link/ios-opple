//
//  DeviceListViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/2/2.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "DeviceListViewController.h"
#import "SHDeviceListCell.h"
#import "SHRouter.h"

#define reuseCellId @"deviceListCell"

@interface DeviceListViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DeviceListViewController
{
    NSArray *_clientList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    self.title = @"设备列表";
    self.tableView.dataSource = self;
    
    [[SHRouter currentRouter] updateRouterInfo];
    
    _clientList = [SHRouter currentRouter].clientList;
    NSLog(@"%@",_clientList);
}

#pragma mark - Table DataSource
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _clientList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHDeviceListCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId];
    
    cell.macAddress = _clientList[indexPath.row][@"MAC"];
    cell.pktReceived = [_clientList[indexPath.row][@"RX_PKTs"] intValue];
    cell.pktSent = [_clientList[indexPath.row][@"TX_PKTs"] intValue];
    
    NSAssert(cell, nil);
    return cell;
}

@end
