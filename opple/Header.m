//
//  Header.m
//  opple
//
//  Created by zhen yang on 15/7/16.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "Header.h"
#import "UIView+Extension.h"
#import "ScreenUtil.h"
#import "TextUtil.h"
#define paddingTop 20
@implementation Header
{
    UILabel *label;
    UIImageView *img;
    UIView *lineView;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setUp];
    }
    return self;
}


-(void)setUp
{
    label = [UILabel new];
    label.text = @"test";
    img = [UIImageView new];
    img.image = [UIImage imageNamed:@"arrow"];
    lineView = [UIView new];
    lineView.backgroundColor = getColor(0xcb, 0xcb, 0xcb, 0xcb);
    label.textColor = getColor(0x44, 0x60, 0xb2, 255);
    [self addSubview:lineView];
    [self addSubview:label];
    [self addSubview:img];
    
    self.backgroundColor = getColor(0xf5, 0xf5, 0xf5, 255);
    img.width = img.image.size.width;
    img.height = img.image.size.height;
    img.y = paddingTop;
    img.x = [ScreenUtil getWidth] - 2 * img.width;
    
    
    label.x = paddingLeft;
    label.y = img.centerY - [TextUtil getSize:label].height / 2;
    [label sizeToFit];
    
    
    lineView.frame = CGRectMake(0, paddingTop + img.height + paddingTop, [ScreenUtil getWidth], 0.5);
    
    _height = CGRectGetMaxY(lineView.frame);
    DLog(@"_height = %f===========================", _height);
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    label.text = _title;
    [label sizeToFit];
}

-(void)normal
{
    //pointer.transform = CGAffineTransformMakeRotation(-(144/180.0)*M_PI);
    img.transform = CGAffineTransformIdentity;
}

-(void)rotate
{
    img.transform = CGAffineTransformMakeRotation(0.5 * M_PI);
}

@end
