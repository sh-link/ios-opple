//
//  SearchViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/2/5.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SearchViewController.h"
#import "SHRectangleButton.h"
#import "PureLayout.h"
#import "Reachability.h"
#import "SHDeviceConnector.h"
#import "SHRouter.h"
#import "AccountControlTool.h"

#import <SystemConfiguration/CaptiveNetwork.h>

typedef NS_ENUM(int, SHSearchState) {
    SHSearchStateNotConnectWifi = 0,
    SHSearchStateSearching,
    SHSearchStateNotFound,
    SHSearchStateSuccess,
    SHSearchStateLogin,
};

#define searchLoopCount 8

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet SHRectangleButton *confirmButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;

@property (nonatomic) SHSearchState currentState;

@end

@implementation SearchViewController

#pragma mark - Life Cycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SHRouter currentRouter].directLogin = NO;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NetworkStatus status = [Reachability reachabilityForLocalWiFi].currentReachabilityStatus;
    if (status != ReachableViaWiFi) {
        self.currentState = SHSearchStateNotConnectWifi;
    }
    else {
        [self searchRouter];
    }
}

#pragma mark - Search Device
#pragma mark -

- (void)searchRouter {
    
    self.currentState = SHSearchStateSearching;
    
    __weak SearchViewController *weakSelf =  self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SHDevice *device = nil;
        
        for (int i = 0; i < searchLoopCount; i++) {
            device = [SHDeviceConnector syncSearchDeviceWithPort:0 TimeoutInSec:1.0];
            if (device) break;
        }
        
        if (device) {
            [SHRouter currentRouter].ip = device.ip;
            [SHRouter currentRouter].mac = device.mac;
        }
        
        __strong SearchViewController *strongWeak = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            device ? [strongWeak setCurrentState:SHSearchStateSuccess] : [weakSelf setCurrentState:SHSearchStateNotFound];
        });
    });
}

#pragma mark - Properties
#pragma mark -

- (void)setCurrentState:(SHSearchState)currentState {
    
    _currentState = currentState;
    
    if (currentState == SHSearchStateNotConnectWifi) {
        
        _infoLabel.text = @"尚未连接WiFi";
        _infoLabel.textColor = [UIColor redColor];
        
        [_confirmButton setTitle:@"连接网络" forState:UIControlStateNormal];
        [_confirmButton removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton addTarget:self action:@selector(connectWifiSetting) forControlEvents:UIControlEventTouchUpInside];
        
        _confirmButton.inSearching = NO;
        
    } else if (currentState == SHSearchStateNotFound) {
        
        _infoLabel.text = @"未发现SHLink路由器";
        _infoLabel.textColor = [UIColor redColor];
        
        [_confirmButton setTitle:@"重新搜索" forState:UIControlStateNormal];
        [_confirmButton removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton addTarget:self action:@selector(connectWifiSetting) forControlEvents:UIControlEventTouchUpInside];
        
        _confirmButton.inSearching = NO;
        
    } else if (currentState == SHSearchStateSearching) {
        
        _infoLabel.text = [NSString stringWithFormat:@"您已连接至网络: \"%@\"",[self getCurrentConnectSsid]];
        _infoLabel.textColor = [UIColor colorWithRed:85.0/255.0f green:85.0/255.0f blue:85.0/255.0f alpha:1.0f];
        
        [_confirmButton setTitle:@"正在搜索中..." forState:UIControlStateNormal];
        [_confirmButton removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton removeTarget:self action:@selector(connectWifiSetting) forControlEvents:UIControlEventTouchUpInside];
        
        _confirmButton.inSearching = YES;
        
    } else if (currentState == SHSearchStateSuccess) {
        
        _infoLabel.text = [NSString stringWithFormat:@"您已连接至网络: \"%@\"",[self getCurrentConnectSsid]];
        _infoLabel.textColor = [UIColor colorWithRed:85.0/255.0f green:85.0/255.0f blue:85.0/255.0f alpha:1.0f];
        
        [_confirmButton setTitle:@"管理路由器" forState:UIControlStateNormal];
        [_confirmButton removeTarget:self action:@selector(connectWifiSetting) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        
        _confirmButton.inSearching = NO;
    } else if (currentState == SHSearchStateLogin) {
        
        _infoLabel.text = [NSString stringWithFormat:@"您已连接至网络: \"%@\"",[self getCurrentConnectSsid]];
        _infoLabel.textColor = [UIColor colorWithRed:85.0/255.0f green:85.0/255.0f blue:85.0/255.0f alpha:1.0f];
        
        [_confirmButton setTitle:@"登陆中" forState:UIControlStateNormal];
        [_confirmButton removeTarget:self action:@selector(connectWifiSetting) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        
        _confirmButton.inSearching = YES;
    }
}

#pragma mark - Actions
#pragma mark -

- (void)connectWifiSetting {
    [self searchRouter];
}

- (void)login {
    
    NSString *usernameStor = [AccountControlTool getStoragedUserNameWithMac:[SHRouter currentRouter].mac];
    NSString *passwordStor = [AccountControlTool getStoragedPasswordWithMac:[SHRouter currentRouter].mac];
    
    if (usernameStor && passwordStor) {
        self.currentState = SHSearchStateLogin;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSError *error;
            BOOL ret = [SHDeviceConnector syncChallengeDeviceWithIp:[SHRouter currentRouter].ip Port:[SHRouter currentRouter].tcpPort Username:usernameStor Password:passwordStor TimeoutInSec:2 Error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{

                if (ret) [SHRouter currentRouter].directLogin = YES;
                    
                ret ? [self performSegueWithIdentifier:@"searchToHomeSegue" sender:self] : [self performSegueWithIdentifier:@"searchToLoginSegue" sender:self];
            });
        });
    } else [self performSegueWithIdentifier:@"searchToLoginSegue" sender:self];
}


#pragma mark - Tools
#pragma mark -

/**
 *  Get current connected wifi name.
 *
 *  @return Ssid iphone connected, nil if not found.
 */
- (NSString *)getCurrentConnectSsid {
    
    NSString *currentSsid;
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (__bridge NSDictionary *)(myDict);
            NSLog(@"dict:%@",dict);
            currentSsid = [dict valueForKey:@"SSID"];
        }
    }
    return currentSsid;
}


#pragma mark - Layout
#pragma mark -

- (void)updateViewConstraints {
    CGFloat imageWidth;
    
    [_imageWidthConstraint autoRemove];
    [_imageHeightConstraint autoRemove];
    [_contentHeightConstraint autoRemove];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageWidth = CGRectGetWidth(self.view.bounds) / 2.3;
    } else {
        imageWidth = CGRectGetHeight(self.view.bounds) / 2.3;
    }
    
    _imageWidthConstraint = [_imageView autoSetDimension:ALDimensionWidth toSize:imageWidth];
    _imageHeightConstraint = [_imageView autoSetDimension:ALDimensionHeight toSize:imageWidth];
    
    _contentHeightConstraint = [_confirmButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_contentView withOffset:-50];
    
    [super updateViewConstraints];
}

@end
