//
//  StaticIpSettingViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/2/1.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "StaticIpSettingViewController.h"
#import "SHTextField.h"
#import "SHRectangleButton.h"
#import "PureLayout.h"

@interface StaticIpSettingViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet SHTextField *ipTF;
@property (weak, nonatomic) IBOutlet SHTextField *maskTF;
@property (weak, nonatomic) IBOutlet SHTextField *gateTF;
@property (weak, nonatomic) IBOutlet SHTextField *dns1TF;
@property (weak, nonatomic) IBOutlet SHTextField *dns2TF;
@property (weak, nonatomic) IBOutlet SHRectangleButton *confirmBT;

@end

@implementation StaticIpSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    
    [_contentHeightConstraint autoRemove];
    
    _contentHeightConstraint = [_contentView autoSetDimension:ALDimensionHeight toSize:CGRectGetMaxY(_confirmBT.frame) > CGRectGetHeight(self.view.bounds) ? CGRectGetMaxY(_confirmBT.frame) : CGRectGetHeight(self.view.bounds)];
    
    [super updateViewConstraints];
}

@end
