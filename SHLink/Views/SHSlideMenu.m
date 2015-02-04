//
//  SHSlideMenu.m
//  SHLink
//
//  Created by 钱凯 on 15/1/30.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHSlideMenu.h"
#import "SHCarveLayer.h"
#import "SHSlideLayer.h"

#define buttonTagBase 1000

#define padding 10.0
#define carveMargin 2.0
#define scaleFactor 1.05

@implementation SHSlideMenu
{
    NSMutableArray *_buttonArray;
    NSMutableArray *_carveLayerArray;
    
    SHSlideLayer *_slideLayer;
    UIView *_slideView;
    long _currentIndex;
}

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
    _buttonArray = [[NSMutableArray alloc] initWithCapacity:3];
    _carveLayerArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    _slideView = [[UIView alloc] initWithFrame:CGRectZero];
    _slideView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_slideView];
    
    _slideLayer = [SHSlideLayer layer];
    
    [_slideView.layer addSublayer:_slideLayer];
    
    self.backgroundColor = [UIColor clearColor];
    
    _currentIndex = 0;
}

- (void)layoutSubviews {
    
    if (!_buttonArray.count) {
        return;
    }
    
    long buttonIndex;
    CGFloat boundWidth = CGRectGetWidth(self.bounds);
    CGFloat buttonHeight = 35.0f;
    CGFloat buttonWidth = (boundWidth - padding * 2) / _buttonArray.count;
    CGFloat currentMidX = 0;
    
    for (UIButton *button in _buttonArray) {
        buttonIndex = button.tag - buttonTagBase;
        button.frame = CGRectMake(padding + buttonIndex * buttonWidth, padding, buttonWidth, buttonHeight);
        
        if (buttonIndex == _currentIndex) {
            [button setTitleColor:[UIColor colorWithRed:96.0/255 green:189.0/255 blue:179.0/255 alpha:1.0f] forState:UIControlStateNormal];
            currentMidX = CGRectGetMidX(button.frame);
        }
    }
    
    for (SHCarveLayer *layer in _carveLayerArray) {
        [layer removeFromSuperlayer];
    }
    
    [_carveLayerArray removeAllObjects];
    
    for (int i = 0; i < (_menuArray.count - 1); i++) {
        SHCarveLayer *layer = [SHCarveLayer layer];
        
        layer.frame = CGRectMake(padding + (i + 1) * buttonWidth - carveMargin / 2.0, padding - carveMargin, carveMargin, carveMargin * 2 + buttonHeight);
        
        [self.layer addSublayer:layer];
        [_carveLayerArray addObject:layer];
        [layer setNeedsDisplay];
    }
    
    _slideView.frame = CGRectMake(padding, padding + buttonHeight, boundWidth - padding * 2, padding);
    _slideLayer.frame = CGRectMake(- CGRectGetWidth(_slideView.frame), 0, CGRectGetWidth(_slideView.frame) * 3, CGRectGetHeight(_slideView.frame));
    _slideView.clipsToBounds = YES;
    
    _slideLayer.transform = CATransform3DMakeTranslation(currentMidX - CGRectGetMidX(self.bounds), 1, 1);
    
    [_slideLayer setNeedsDisplay];
}

- (void)setMenuArray:(NSArray *)menuArray {
    _menuArray = menuArray;
    
    for (UIButton *button in _buttonArray) {
        [button removeFromSuperview];
    }
    
    [_buttonArray removeAllObjects];
    
    for (NSString *title in menuArray) {
        NSAssert([title isKindOfClass:[NSString class]], @"menuArray should be type of string.");
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        
        [button setTitle:title forState:UIControlStateNormal];
        button.tag = buttonTagBase + [menuArray indexOfObject:title];
        [button addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        
        [button setTitleColor:[UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        
        [_buttonArray addObject:button];
        
        [self addSubview:button];
    }
    
}

- (void)tapped:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    CGFloat currentMidX = CGRectGetMidX(button.frame);
    CGFloat boundsMidX = CGRectGetMidX(self.bounds);
    
    for (UIButton *bt in _buttonArray) {
        [bt setTitleColor:[UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    }
    
    [button setTitleColor:[UIColor colorWithRed:96.0/255 green:189.0/255 blue:179.0/255 alpha:1.0f] forState:UIControlStateNormal];
    
    _slideLayer.transform = CATransform3DMakeTranslation(currentMidX - boundsMidX, 1, 1);
    
    _currentIndex = button.tag - buttonTagBase;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didTapButtonWithIndex:)]) {
        [_delegate didTapButtonWithIndex:(int)_currentIndex];
    }
}


@end
