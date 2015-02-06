//
//  SHButton.m
//  SHLink
//
//  Created by 钱凯 on 15/1/26.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHRectangleButton.h"
#import "SHSearchRoationLayer.h"

#define Radius 10.0
#define searchingPadding 3.0

@implementation SHRectangleButton
{
    SHSearchRoationLayer *_searchLayer;
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
    
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    [self setTitleColor:[UIColor colorWithRed:66.0/255 green:167.0/255 blue:156.0/255 alpha:1.0f] forState:UIControlStateNormal];
    
    self.showsTouchWhenHighlighted = YES;
    self.inSearching = NO;
    
    _searchLayer = [SHSearchRoationLayer layer];
    _searchLayer.frame = CGRectMake(0, 0, 30, 30);
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [_searchLayer addAnimation:rotationAnimation forKey:@"KCBasicAnimation_Rotation"];
    
    [_searchLayer setNeedsDisplay];
    [self.layer addSublayer:_searchLayer];
    
}

- (void)drawRect:(CGRect)rect {
    
    self.layer.cornerRadius = Radius;
    self.layer.masksToBounds = YES;
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGFloat gradColors[8] = {1.0f,1.0f,1.0f,1.0f,
                        0.85f,0.85f,0.85f,1.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    
    CGContextDrawLinearGradient(contex, gradient, CGPointMake(CGRectGetMidX(rect), 0), CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)), kCGGradientDrawsAfterEndLocation);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    CGContextSetStrokeColorWithColor(contex, [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor);
    CGContextSetLineWidth(contex, 2);
    
    CGContextBeginPath(contex);
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 0.5, 0.5) cornerRadius:Radius].CGPath;
    
    CGContextAddPath(contex, path);
    
    CGContextClosePath(contex);
    
    CGContextStrokePath(contex);
    
    CGRect titleRect = [self titleRectForContentRect:rect];
    CGFloat searchingWidth = CGRectGetHeight(rect) - searchingPadding * 2.0;
    
    NSLog(@"%@",NSStringFromCGRect([self titleRectForContentRect:rect]));
    if (_inSearching) {
        _searchLayer.frame = CGRectMake(CGRectGetMinX(titleRect) - searchingPadding - searchingWidth, searchingPadding, searchingWidth, searchingWidth);
    } else {
        _searchLayer.frame = CGRectZero;
    }
    
    NSLog(@"%@",NSStringFromCGRect(_searchLayer.frame));
    [_searchLayer setNeedsDisplay];
}

- (void)setInSearching:(BOOL)inSearching {
    _inSearching = inSearching;

    [self setNeedsDisplay];
    [_searchLayer setNeedsDisplay];
}


@end
