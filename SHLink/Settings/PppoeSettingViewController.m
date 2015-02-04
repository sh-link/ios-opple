//
//  PppoeSettingViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/2/1.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "PppoeSettingViewController.h"
#import "SHTextField.h"
#import "SHRectangleButton.h"

@interface PppoeSettingViewController ()

@property (weak, nonatomic) IBOutlet SHTextField *accountTF;
@property (weak, nonatomic) IBOutlet SHTextField *pswTF;
@property (weak, nonatomic) IBOutlet SHRectangleButton *confirmBT;

@end

@implementation PppoeSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _accountTF.shLeftImage = [UIImage imageNamed:@"iconTest3"];
    _pswTF.shLeftImage = [UIImage imageNamed:@"iconTest3"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
