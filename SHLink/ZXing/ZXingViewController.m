//
//  ZXingViewController.m
//  SHLink
//
//  Created by 钱凯 on 15/2/10.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "ZXingViewController.h"

#import <ZXingObjC.h>
#import "PureLayout.h"

#define padding 30

@interface ZXingViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ZXingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_imageView setImage:[self makeZxingWithString:@"go fuck yourself"]];
    [_imageView setContentMode:UIViewContentModeScaleToFill];
    [_imageView setBackgroundColor:[UIColor clearColor]];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateViewConstraints {
    static BOOL setted = NO;
    if (!setted) {
        
        CGFloat imageWidth = MIN(CGRectGetWidth(self.view.bounds) - 2 * padding, CGRectGetHeight(self.view.bounds) - 2 * padding);
        
        [_imageView autoSetDimension:ALDimensionWidth toSize:imageWidth];
        [_imageView autoSetDimension:ALDimensionHeight toSize:imageWidth];
        
        [_imageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    }
    
    [_contentHeightConstraint autoRemove];
    CGFloat contentHeight = MAX(CGRectGetHeight(self.view.bounds), CGRectGetMaxY(_label.frame) + 30);
    _contentHeightConstraint = [_contentView autoSetDimension:ALDimensionHeight toSize:contentHeight];
    
    [super updateViewConstraints];
}

- (UIImage *)makeZxingWithString:(NSString *)stringToEncode {
    
    NSError* error = nil;
    
    int qrWidth = MIN(CGRectGetWidth(self.view.bounds) - 2 * padding, CGRectGetHeight(self.view.bounds) - 2 * padding);
    
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    
    ZXEncodeHints *hints = [ZXEncodeHints hints];
    
    hints.errorCorrectionLevel = [ZXQRCodeErrorCorrectionLevel errorCorrectionLevelH];
    hints.encoding =  NSUTF8StringEncoding;
    
    ZXBitMatrix *result = [writer encode:stringToEncode
                                  format:kBarcodeFormatQRCode width:qrWidth height:qrWidth hints:hints error:&error];

    CGImageRef cgImage = [[ZXImage imageWithMatrix:result] cgimage];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    return image;
    
}

- (IBAction)make:(id)sender {// 生成txt.text的二维码
    
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
