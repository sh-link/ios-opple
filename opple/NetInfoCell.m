//
//  NetInfoCell.m
//  SHLink
//
//  Created by zhen yang on 15/7/7.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "NetInfoCell.h"
#import "UIView+Extension.h"
#import "TextUtil.h"
#import "ScreenUtil.h"
@implementation NetInfoCell
{
    UILabel *titleLabel;
    UILabel *contentLabel;
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
    titleLabel = [[UILabel alloc]init];
    contentLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:cellSize];
    contentLabel.font = [UIFont systemFontOfSize:cellSize];
    //939393
    titleLabel.textColor = DEFAULT_COLOR;
    //D6D6D6
    contentLabel.textColor = [UIColor grayColor];
    
    int screenWidth = [ScreenUtil getWidth];
    
    int padding = screenWidth / 12;
    
    titleLabel.width = contentLabel.width = (screenWidth - 2 * padding) / 2;
    titleLabel.height = contentLabel.height = [TextUtil getSize:@"test" withLabel:titleLabel].height;
    titleLabel.x = padding;
    titleLabel.y = 0;
    contentLabel.x = CGRectGetMaxX(titleLabel.frame);
    contentLabel.y = 0;
    self.height = titleLabel.height;
    self.width = screenWidth;
    self.x = 0;
    
    [self addSubview:titleLabel];
    [self addSubview:contentLabel];
}
-(int)getPadding
{
    return titleLabel.x;
}

-(void)setTitle:(NSString *)title
{
    titleLabel.text = title;
}

-(void)setContent:(NSString *)content
{
    contentLabel.text = content;
}

-(void)setTitleColor:(UIColor *)color
{
    titleLabel.textColor = color;
}
@end
