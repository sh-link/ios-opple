//
//  SHCarveLayer.m
//  SHLink
//
//  Created by 钱凯 on 15/2/1.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHCarveLayer.h"

@implementation SHCarveLayer

- (void)drawInContext:(CGContextRef)ctx {
    CGContextSetRGBStrokeColor(ctx, 36.0/255.0f,89.0/255.0f,116.0/255.0f,0.8f);
    
    CGContextSetLineWidth(ctx, 1);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, CGRectGetMidX(self.bounds), 0);
    CGContextAddLineToPoint(ctx, CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    
    CGContextStrokePath(ctx);
}
@end
