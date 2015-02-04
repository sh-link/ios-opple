//
//  AccountViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/2/3.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "AccountViewController.h"
#import "SHTextField.h"
#import "SHRectangleButton.h"
#import "PureLayout.h"

@interface AccountViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;

@property (weak, nonatomic) IBOutlet SHTextField *currentAccountTF;
@property (weak, nonatomic) IBOutlet SHTextField *currentPswTF;
@property (weak, nonatomic) IBOutlet SHTextField *accountTF;
@property (weak, nonatomic) IBOutlet SHTextField *pswTF;
@property (weak, nonatomic) IBOutlet SHTextField *retypePswTF;

@property (weak, nonatomic) IBOutlet SHRectangleButton *confirmButton;

@end

@implementation AccountViewController

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
    
    _currentAccountTF.shLeftImage = [UIImage imageNamed:@"iconTest3"];
    _currentPswTF.shLeftImage = [UIImage imageNamed:@"iconTest3"];
    _accountTF.shLeftImage = [UIImage imageNamed:@"iconTest3"];
    _pswTF.shLeftImage = [UIImage imageNamed:@"iconTest3"];
    _retypePswTF.shLeftImage = [UIImage imageNamed:@"iconTest3"];
    
}


- (void)updateViewConstraints {
    CGFloat buttonMaxY = CGRectGetMaxY(_confirmButton.frame);
    CGFloat minHeightNeeded = buttonMaxY + 30.0;
    
    if (minHeightNeeded > CGRectGetHeight(_contentView.frame)) {
        [_contentHeightConstraint autoRemove];
        _contentHeightConstraint = [_contentView autoSetDimension:ALDimensionHeight toSize:minHeightNeeded];
    } else {
    }
    
    [super updateViewConstraints];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
