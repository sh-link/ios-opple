//
//  SHTextField.m
//  SHLink
//
//  Created by 钱凯 on 15/1/29.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHTextField.h"

#define padding 5.5

@implementation SHTextField

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.textColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
    self.font = [UIFont fontWithName:@"Helvetica" size:15.0];
}

-(CGRect)textRectForBounds:(CGRect)bounds {
    CGFloat leftViewWidth = CGRectGetHeight(bounds) - padding * 2.0;

    CGRect textRect = CGRectMake(padding * 3 + leftViewWidth, 0, CGRectGetWidth(bounds) - padding * 3 - leftViewWidth, CGRectGetHeight(bounds));
    
    if (!_shLeftImage) {
        return CGRectMake(padding, 0, CGRectGetWidth(bounds) - padding, CGRectGetHeight(bounds));
    }
    
    return textRect;
}

-(CGRect)editingRectForBounds:(CGRect)bounds {
    CGFloat leftViewWidth = CGRectGetHeight(bounds) - padding * 2.0;
    
    CGRect textRect = CGRectMake(padding * 3 + leftViewWidth, 0, CGRectGetWidth(bounds) - padding * 3 - leftViewWidth, CGRectGetHeight(bounds));
    
    if (!_shLeftImage) {
        return CGRectMake(padding, 0, CGRectGetWidth(bounds) - padding, CGRectGetHeight(bounds));
    }
    
    return textRect;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    
    CGFloat leftViewWidth = CGRectGetHeight(bounds) - padding * 2.0;
    CGRect leftRect = CGRectMake(padding, padding, leftViewWidth, leftViewWidth);
    
    if (!_shLeftImage) {
        return CGRectZero;
    }
    
    return leftRect;
}

-(void)setShLeftImage:(UIImage *)shLeftImage {
    _shLeftImage = shLeftImage;
    
    if (shLeftImage) {
        self.leftView = [[UIImageView alloc] initWithImage:shLeftImage];
        self.leftViewMode = UITextFieldViewModeAlways;
    }else {
        self.leftView = nil;
        self.leftViewMode = UITextFieldViewModeNever;
    }
    
    [self setNeedsDisplay];
}

@end
