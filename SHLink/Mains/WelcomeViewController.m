//
//  WelcomeViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/2/4.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController
{
    UIImageView *_logoImageView;
    UIImageView *_detailImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat logoWidth = CGRectGetWidth(self.view.bounds)/2;
    CGFloat logoHeight = logoWidth / 3;
    
    CGFloat detailWidth = CGRectGetWidth(self.view.bounds)/3;
    CGFloat detailHeight = detailWidth / 3;
    
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, logoWidth, logoHeight)];
    _logoImageView.center = self.view.center;
    _logoImageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_logoImageView];
    
    _detailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, detailWidth, detailHeight)];
    _detailImageView.center = self.view.center;
    _detailImageView.backgroundColor = [UIColor blueColor];
    _detailImageView.alpha = 0.0f;
    [self.view addSubview:_detailImageView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.8 animations:^{
        CGRect logoFrame = _logoImageView.frame;
        logoFrame.origin.y -= logoFrame.size.height;
        _logoImageView.frame = logoFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.6 animations:^{
                _detailImageView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [self performSelector:@selector(mode) withObject:self afterDelay:0.5];
            }];
        }
    }];
}

//- (void)updateViewConstraints {
//    _logoImageView.center = self.view.center;
//    _detailImageView.center = self.view.center;
//    [super updateViewConstraints];
//}

- (void)mode {
    [self performSegueWithIdentifier:@"mainSegue" sender:self];
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
