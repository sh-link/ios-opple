//
//  ViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/1/20.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "ViewController.h"
#import "SHShadowLayer.h"
#import "SHSquareButton.h"
#import "SHMenuCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect frame = CGRectMake(100, 100, 90, 150);
    SHMenuCell *cell = [[SHMenuCell alloc] initWithFrame:frame];
    
    cell.title = @"查询设备列表";
    cell.image = [UIImage imageNamed:@"iconTest3"];
    
    [self.view addSubview:cell];
    
    
}

@end
