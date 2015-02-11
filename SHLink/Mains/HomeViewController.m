//
//  HomeViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/2/2.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "HomeViewController.h"
#import "SHMenuCell.h"
#import "SHRouter.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation HomeViewController
{
    SHMenuCell *_deviceListCell;
    SHMenuCell *_settingCell;
    SHMenuCell *_modifyAccountCell;
    SHMenuCell *_shareWifiCell;
    SHMenuCell *_netInfoCell;
    SHMenuCell *_scheduleCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SHRouter currentRouter] updateRouterInfo];
    });
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    _deviceListCell = [[SHMenuCell alloc] init];
    _deviceListCell.image = [UIImage imageNamed:@"iconTest3"];
    _deviceListCell.title = @"查询设备列表";
    _deviceListCell.caller = self;
    _deviceListCell.selector = @selector(deviceListCellTapped);
    [self.contentView addSubview:_deviceListCell];
    
    _settingCell = [[SHMenuCell alloc] init];
    _settingCell.image = [UIImage imageNamed:@"iconTest3"];
    _settingCell.title = @"参数设置";
    _settingCell.caller = self;
    _settingCell.selector = @selector(settingCellTapped);
    [self.contentView addSubview:_settingCell];
    
    _modifyAccountCell = [[SHMenuCell alloc] init];
    _modifyAccountCell.image = [UIImage imageNamed:@"iconTest3"];
    _modifyAccountCell.title = @"修改账户密码";
    _modifyAccountCell.caller = self;
    _modifyAccountCell.selector = @selector(changeAccountCellTapped);
    [self.contentView addSubview:_modifyAccountCell];
    
    _shareWifiCell = [[SHMenuCell alloc] init];
    _shareWifiCell.image = [UIImage imageNamed:@"iconTest3"];
    _shareWifiCell.title = @"分享wifi";
    _shareWifiCell.caller = self;
    _shareWifiCell.selector = @selector(shareWifiCellTapped);
    [self.contentView addSubview:_shareWifiCell];
    
    _netInfoCell = [[SHMenuCell alloc] init];
    _netInfoCell.image = [UIImage imageNamed:@"iconTest3"];
    _netInfoCell.title = @"获取网络信息";
    _netInfoCell.caller = self;
    _netInfoCell.selector = @selector(networkInfoCellTapped);
    [self.contentView addSubview:_netInfoCell];
    
    _scheduleCell = [[SHMenuCell alloc] init];
    _scheduleCell.image = [UIImage imageNamed:@"iconTest3"];
    _scheduleCell.title = @"wifi定时开关";
    [self.contentView addSubview:_scheduleCell];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)updateViewConstraints {
    CGFloat cellWidth;
    CGFloat cellHeight;
    CGFloat paddingToMid;
    CGFloat paddingToCell;
    CGFloat paddingToTop;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        cellWidth = CGRectGetWidth(self.view.bounds) / 4.0;
        cellHeight = cellWidth + 35.0;
        paddingToMid = cellWidth / 2.5;
        paddingToCell = cellWidth / 4.0;
        paddingToTop = cellWidth / 2.0;
        
        CGFloat firstRowX = CGRectGetMidX(self.view.bounds) - paddingToMid - cellWidth;
        CGFloat secondRowX = CGRectGetMidX(self.view.bounds) + paddingToMid;
        
        _deviceListCell.frame = CGRectMake(firstRowX, paddingToTop, cellWidth, cellHeight);
        _settingCell.frame = CGRectMake(secondRowX, paddingToTop, cellWidth, cellHeight);
        
        _modifyAccountCell.frame = CGRectMake(firstRowX, CGRectGetMaxY(_deviceListCell.frame) + paddingToCell, cellWidth, cellHeight);
        _shareWifiCell.frame = CGRectMake(secondRowX, CGRectGetMaxY(_deviceListCell.frame) + paddingToCell, cellWidth, cellHeight);
        
        _netInfoCell.frame = CGRectMake(firstRowX, CGRectGetMaxY(_modifyAccountCell.frame) + paddingToCell, cellWidth, cellHeight);
        _scheduleCell.frame = CGRectMake(secondRowX, CGRectGetMaxY(_modifyAccountCell.frame) + paddingToCell, cellWidth, cellHeight);
        
    } else {
        
        cellWidth = CGRectGetHeight(self.view.bounds) / 4.0;
        cellHeight = cellWidth + 35;
        paddingToMid = cellWidth / 4;
        
        CGFloat firstLineY = CGRectGetMidY(self.view.bounds) - paddingToMid - cellHeight;
        CGFloat secondLineY = CGRectGetMidY(self.view.bounds);
        
        CGFloat firstRowX = CGRectGetWidth(self.view.bounds) / 6.0 - cellWidth / 2.0;
        CGFloat secondRowX = CGRectGetMidX(self.view.bounds) - cellWidth / 2.0;
        CGFloat thirdRowX = CGRectGetWidth(self.view.bounds) / 6.0 * 5.0 - cellWidth / 2.0;
        
        _deviceListCell.frame = CGRectMake(firstRowX, firstLineY, cellWidth, cellHeight);
        _settingCell.frame = CGRectMake(secondRowX, firstLineY, cellWidth, cellHeight);
        _modifyAccountCell.frame = CGRectMake(thirdRowX, firstLineY, cellWidth, cellHeight);
        
        _shareWifiCell.frame = CGRectMake(firstRowX, secondLineY, cellWidth, cellHeight);
        _netInfoCell.frame = CGRectMake(secondRowX, secondLineY, cellWidth, cellHeight);
        _scheduleCell.frame = CGRectMake(thirdRowX, secondLineY, cellWidth, cellHeight);
    }
    
    [super updateViewConstraints];
}

- (void)settingCellTapped {
    UIStoryboard *strBoard = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    if (strBoard) {
        [self.navigationController pushViewController:[strBoard instantiateViewControllerWithIdentifier:@"settingInit"] animated:YES];
    }
}

- (void)deviceListCellTapped {
    [self performSegueWithIdentifier:@"deviceListSegue" sender:self];
}

- (void)changeAccountCellTapped {
    [self performSegueWithIdentifier:@"accountSegue" sender:self];
}

- (void)networkInfoCellTapped {
    [self performSegueWithIdentifier:@"homeToNetworkInfoSegue" sender:self];
}

- (void)shareWifiCellTapped {
    [self performSegueWithIdentifier:@"homeToZxingSegue" sender:self];
}

@end
