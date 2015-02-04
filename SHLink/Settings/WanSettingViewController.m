//
//  WanSettingViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/1/26.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "WanSettingViewController.h"
#import "SHSlideMenu.h"
#import "PppoeSettingViewController.h"
#import "DhcpSettingViewController.h"
#import "StaticIpSettingViewController.h"

typedef enum : NSInteger {
    SlideFromLeft,
    SlideFromRight
} SlideType;

@interface WanSettingViewController ()<SHSlideMenuDelegate>

@property (weak, nonatomic) IBOutlet SHSlideMenu *slideMenu;
@property (weak, nonatomic) IBOutlet UIView *placeHoderView;

@end

@implementation WanSettingViewController
{
    PppoeSettingViewController *_pppoeVC;
    DhcpSettingViewController *_dhcpVC;
    StaticIpSettingViewController *_staticVC;
    
    UIViewController *_currentViewController;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _slideMenu.menuArray = @[@"PPPOE",@"DHCP",@"静态IP"];
    _slideMenu.delegate = self;
    
    _placeHoderView.backgroundColor = [UIColor clearColor];
    
    _pppoeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pppoeVC"];
    _dhcpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"dhcpVC"];
    _staticVC = [self.storyboard instantiateViewControllerWithIdentifier:@"staticVC"];
    
    [self addChildViewController:_pppoeVC];
    [_pppoeVC didMoveToParentViewController:self];
    _pppoeVC.view.tag = 2000;
    
    [self addChildViewController:_dhcpVC];
    [_dhcpVC didMoveToParentViewController:self];
    _dhcpVC.view.tag = 2001;
    
    [self addChildViewController:_staticVC];
    [_staticVC didMoveToParentViewController:self];
    _staticVC.view.tag = 2002;
    
    _pppoeVC.view.frame = self.placeHoderView.bounds;
    [self.placeHoderView addSubview:_pppoeVC.view];
    
    _currentViewController = _pppoeVC;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)replaceViewController:(UIViewController *)childToRemove withViewController:(UIViewController *)childToAdd {
    
    NSAssert(childToAdd, @"childToAdd can not be nil.");
    
    if (childToAdd == childToRemove) {
        return;
    }
    
    CGRect frame = self.placeHoderView.bounds;
    if (childToRemove.view.tag < childToAdd.view.tag) {
        frame.origin.x -= frame.size.width;
    } else {
        frame.origin.x += frame.size.width;
    }
    childToAdd.view.frame = frame;
    [self.placeHoderView addSubview:childToAdd.view];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.placeHoderView.bounds;
        childToAdd.view.frame = frame;
        if (childToRemove.view.tag < childToAdd.view.tag) {
            frame.origin.x += frame.size.width;
        } else
            frame.origin.x -= frame.size.width;
        childToRemove.view.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            
            _currentViewController = childToAdd;
            
            [childToRemove.view removeFromSuperview];
            
        }
    }];
}

#pragma mark - SHSlideMenuDelegate
#pragma mark -

/**
 *  0 - pppoe
 *  1 - dhcp
 *  2 - static ip
 */
- (void)didTapButtonWithIndex:(int)index {
    UIViewController *childToAdd;
    switch (index) {
        case 0:
            childToAdd = _pppoeVC;
            break;
        case 1:
            childToAdd = _dhcpVC;
            break;
        case 2:
            childToAdd = _staticVC;
            break;
            
        default:
            NSAssert(NO, @"Invalid index.");
    }
    
    [self replaceViewController:_currentViewController withViewController:childToAdd];
}


@end
