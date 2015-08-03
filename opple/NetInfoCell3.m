//
//  NetInfoCell3.m
//  opple
//
//  Created by zhen yang on 15/7/16.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "NetInfoCell3.h"
#import "Header.h"
#import "TextUtil.h"
#import "ScreenUtil.h"
#import "UIView+Extension.h"
#define cellSize 14
#define paddingTop 10
@implementation NetInfoCell3
{
    UIView *lineView;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    _hintLabel = [[UILabel alloc]init];
    _valueLabel = [[UILabel alloc]init];
    _hintLabel.font = [UIFont systemFontOfSize:cellSize];
    _valueLabel.font = [UIFont systemFontOfSize:cellSize];
    _valueLabel.textColor = getColor(0x93, 0x93, 0x93, 255);
    _hintLabel.textColor = getColor(0x44, 0x60, 0xb2, 255);
    _hintLabel.text = @"title";
    _valueLabel.text = @"value";
    lineView = [UIView new];
    lineView.backgroundColor = getColor(0xcb, 0xcb, 0xcb, 0xff);
    [self addSubview:_hintLabel];
    [self addSubview:_valueLabel];
    [self addSubview:lineView];
    _hintLabel.x = paddingLeft;
    _hintLabel.y = paddingTop;
    _hintLabel.height  = [TextUtil getSize:_hintLabel].height;
    _hintLabel.width = ([ScreenUtil getWidth] - 2 * paddingLeft)/5*2;
    
    _valueLabel.x = CGRectGetMaxX(_hintLabel.frame);
    _valueLabel.y = _hintLabel.y;
    _valueLabel.height = _hintLabel.height;
    _valueLabel.width = _hintLabel.width /2 * 3;
    
    lineView.x = 0;
    lineView.y = paddingTop + _hintLabel.height + paddingTop;
    lineView.width = [ScreenUtil getWidth];
    lineView.height = 0.5;
    
    self.backgroundColor = [UIColor whiteColor];
//    _hintLabel.backgroundColor = [UIColor redColor];
//    _valueLabel.backgroundColor = [UIColor purpleColor];
    
    _height = CGRectGetMaxY(lineView.frame);
}



+(id)cellFromTableView:(UITableView *)tableView
{
    static NSString *cellId = @"id";
    NetInfoCell3 *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[NetInfoCell3 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = 0;
    }
    
    return cell;
}

@end
