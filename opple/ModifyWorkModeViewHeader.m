//
//  ModifyWorkModeViewHeader.m
//  opple
//
//  Created by zhen yang on 15/7/20.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "ModifyWorkModeViewHeader.h"
#import "RadioGroup3.h"
#import "TextUtil.h"
#import "UIView+Extension.h"
#define  padding 15

@interface ModifyWorkModeViewHeader() <RadioGroup3Delegate>

@end
@implementation ModifyWorkModeViewHeader
{
    UILabel *hint;
    RadioGroup3 *group;
    UIView *line;
}
-(id)init
{
    self = [super init];
    if(self)
    {
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    hint = [UILabel new];
    group = [RadioGroup3 new];
    group.delegate = self;
    line = [UIView new];
    [self addSubview:line];
    [self addSubview:hint];
    [self addSubview:group];
    
    line.backgroundColor = getColor(0x80, 0x80, 0x80, 0x55);
    hint.text = @"选择模式:";
    hint.x = padding;
    hint.textColor = getColor(0x57, 0x57, 0x57, 255);
    
    hint.width = [TextUtil getSize:hint].width;
    hint.height = [TextUtil getSize:hint].height;
    
    group.x = CGRectGetMaxX(hint.frame);
    group.y = padding;
    
    hint.y = CGRectGetMidY(group.frame) - hint.height / 2;
    
    line.x = 0;
    line.y = CGRectGetMaxY(group.frame) + padding;
    line.height = 0.5;
    self.height = CGRectGetMaxY(line.frame);
}

-(void)layoutSubviews
{
    line.width = self.width;
}

-(void)itemSelected:(int)index
{
    [self.delegate itemSelected:index];
}

-(void)clickItem:(int)index
{
    [group clickItem:index];
}
@end
