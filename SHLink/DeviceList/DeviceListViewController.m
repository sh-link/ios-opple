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
#import "SHSearchRoationLayer.h"
#import "PureLayout.h"

#define reuseCellId @"deviceListCell"
#define searchLayerWidth 100.0
@interface DeviceListViewController ()<UITableViewDataSource>
{
    UIView *_searchView;
    NSLock *_refreshLock;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;

@property (nonatomic) BOOL isEmpty;
@property (nonatomic) BOOL inSearching;

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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self refresh:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    
    self.title = @"设备列表";
    self.tableView.dataSource = self;
}

#pragma mark - Actions
#pragma mark -

- (IBAction)refresh:(id)sender {
    
    if (_inSearching) {
        return;
    }
    
    self.inSearching = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1.5);
        NSError *error = nil;
        
        [[SHRouter currentRouter] getClientListWithError:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.inSearching = NO;
            
            _clientList = error ? nil : [SHRouter currentRouter].clientList;
            [_tableView reloadData];
            self.isEmpty = _clientList.count == 0 ? YES : NO;
        });
    });
    
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

#pragma mark - Properties
#pragma mark -

- (void)setIsEmpty:(BOOL)isEmpty {
    _isEmpty = isEmpty;
    
    if (isEmpty) {
        _emptyView.hidden = NO;
        _tableView.hidden = YES;
    } else {
        _emptyView.hidden = YES;
        _tableView.hidden = NO;
    }
}

- (void)setInSearching:(BOOL)inSearching {
    _inSearching = inSearching;
    if (inSearching) {
        
        _tableView.hidden = YES;
        _emptyView.hidden = YES;
        
        _searchView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_searchView];
        
        [_searchView autoSetDimension:ALDimensionHeight toSize:searchLayerWidth];
        [_searchView autoSetDimension:ALDimensionWidth toSize:searchLayerWidth];
        [_searchView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_searchView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        SHSearchRoationLayer *searchLayer = [SHSearchRoationLayer layer];
        searchLayer.frame = CGRectMake(0, 0, searchLayerWidth, searchLayerWidth);
        [_searchView.layer addSublayer:searchLayer];
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
        
        rotationAnimation.duration = 1.0;
        rotationAnimation.repeatCount = HUGE_VALF;
        
        [searchLayer addAnimation:rotationAnimation forKey:nil];
        [searchLayer setNeedsDisplay];
    } else {
        
        _tableView.hidden = NO;
        [_searchView removeFromSuperview];
        _searchView = nil;
    }
}

@end
