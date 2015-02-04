//
//  SHButton.m
//  SHLink
//
//  Created by 钱凯 on 15/1/26.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHRectangleButton.h"

#define Radius 10.0

@implementation SHRectangleButton

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
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    [self setTitleColor:[UIColor colorWithRed:66.0/255 green:167.0/255 blue:156.0/255 alpha:1.0f] forState:UIControlStateNormal];
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

}


@end
