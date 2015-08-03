//
//  SHSlideLayer.m
//  SHLink
//
//  Created by 钱凯 on 15/2/1.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHSlideLayer.h"

#define arrowHeight 5.0

@implementation SHSlideLayer
//画设置界面那个带尖头的线
- (void)drawInContext:(CGContextRef)ctx {
    CGContextSetRGBStrokeColor(ctx, 36.0/255.0f,89.0/255.0f,116.0/255.0f,0.8f);
    
    CGContextSetLineWidth(ctx, 1);
    
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, - CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 2);
    
    CGContextAddLineToPoint(ctx, CGRectGetMidX(self.bounds) - arrowHeight, CGRectGetHeight(self.bounds) - 2);
    
    CGContextAddLineToPoint(ctx, CGRectGetMidX(self.bounds), CGRectGetHeight(self.bounds) - arrowHeight - 2);

    CGContextAddLineToPoint(ctx, CGRectGetMidX(self.bounds) + arrowHeight, CGRectGetHeight(self.bounds) - 2);
    
    CGContextAddLineToPoint(ctx, CGRectGetWidth(self.bounds) * 2, CGRectGetHeight(self.bounds) - 2);
    
    CGContextStrokePath(ctx);
}

@end
