//
//  SHMenuCell.m
//  SHLink
//
//  Created by 钱凯 on 15/1/28.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHMenuCell.h"
#import "SHSquareButton.h"
#import "SHShadowLayer.h"

#define buttonPadding 5.0
#define labelHeight 20.0

@implementation SHMenuCell
{
    SHSquareButton *_button;
    SHShadowLayer *_shadowLayer;
    UILabel *_label;
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
    
    _button = [[SHSquareButton alloc] initWithFrame:CGRectZero];
    _button.showsTouchWhenHighlighted = YES;
    
    
    _shadowLayer = [SHShadowLayer layer];
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    _label.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0f];
    [_label setTextAlignment:NSTextAlignmentCenter];
    
    [self.layer addSublayer:_shadowLayer];
    [self addSubview:_button];
    [self addSubview:_label];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonWidth = CGRectGetWidth(self.frame) - 2 * buttonPadding;
    CGRect buttonFrame = CGRectMake(buttonPadding, buttonPadding, buttonWidth, buttonWidth);
    
    _shadowLayer.frame = buttonFrame;
    _button.frame = buttonFrame;
    
    CGFloat labelExtra = 20;
    CGRect labelFrame = CGRectMake(- labelExtra, 3 * buttonPadding + buttonWidth, CGRectGetWidth(self.frame) + 2 * labelExtra, labelHeight);
    _label.frame = labelFrame;
    
    [_shadowLayer setNeedsDisplay];
}

- (void)setTitle:(NSString *)title {
    _label.text = title;
}

- (void)setImage:(UIImage *)image {
    [_button setImage:image forState:UIControlStateNormal];
}

- (void)setSelector:(SEL)selector {
    _selector = selector;
    [_button addTarget:_caller action:_selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapped {
    
}

@end
