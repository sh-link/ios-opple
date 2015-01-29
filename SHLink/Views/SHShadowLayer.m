//
//  SHShadowLayer.m
//  SHLink
//
//  Created by 钱凯 on 15/1/29.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHShadowLayer.h"
#import "SHSquareButton.h"

@implementation SHShadowLayer

-(void)drawInContext:(CGContextRef)ctx {
    
    self.shadowRadius = 4;
    self.shadowOffset = CGSizeMake(2, 2);
    self.shadowOpacity = 0.6;
    
    CGContextBeginPath(ctx);
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 1.5, 1.5) cornerRadius:Radius].CGPath;
    
    CGContextAddPath(ctx, path);
    
    CGContextClosePath(ctx);
    
    CGContextFillPath(ctx);
}

@end
