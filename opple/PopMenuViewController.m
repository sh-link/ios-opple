//
//  PopMenuViewController.m
//  opple
//
//  Created by zhen yang on 15/7/23.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "PopMenuViewController.h"
#import "UIView+Extension.h"
#import "MessageUtil.h"
@interface PopMenuViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation PopMenuViewController
{
    UITableView *_tableView;
    NSArray *datas;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [UITableView new];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = 0;
    datas = @[@"自动", @"1", @"2", @"3", @"4", @"5",@"6",@"7",@"8",@"9"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  datas.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:cellID];
    }
    cell.textLabel.text = datas[indexPath.row];
    return cell;
}



-(void)viewDidAppear:(BOOL)animated
{
    _tableView.frame = self.view.frame;
    _tableView.x = 0;
    _tableView.y = 0;
    
    self.view.layer.borderColor = getColor(220, 220, 220, 220).CGColor;
    self.view.layer.borderWidth = 1;
    self.view.layer.cornerRadius = 1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate clickItem:indexPath.row withData:datas];
}

@end
