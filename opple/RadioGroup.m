//
//  RadioGroup.m
//  opple
//
//  Created by zhen yang on 15/7/17.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "RadioGroup.h"
#import "RadioButton.h"
#import "UIView+Extension.h"
#define padding 3
@implementation RadioGroup
{
    
}
-(id)init
{
    self = [super init];
    if(self)
    {
        self.onButton = [RadioButton new];
        [self.onButton setTitle:@"开启" forState:UIControlStateNormal];
        self.offButton = [RadioButton new];
        [self.offButton setTitle:@"关闭" forState:UIControlStateNormal];
        [self addSubview:self.onButton];
        [self addSubview:self.offButton];
        
        [self.onButton setTitleColor:getColor(0x57, 0x57, 0x57, 200) forState:UIControlStateNormal];
        [self.offButton setTitleColor:getColor(0x57, 0x57, 0x57, 200) forState:UIControlStateNormal];
       
        [self.onButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        [self.onButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        
        [self.offButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        [self.offButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        
        self.onButton.groupButtons = @[self.onButton, self.offButton];
        self.offButton.groupButtons = @[self.onButton, self.offButton];
        self.width = 150;
        self.height = 30;
        
        self.onButton.selected = true;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    onButton.backgroundColor = [UIColor blueColor];
//    offButton.backgroundColor = [UIColor redColor];
    self.onButton.frame = CGRectMake(0, 0, self.width/2, self.height);
    self.offButton.frame = CGRectMake(CGRectGetMaxX(self.onButton.frame), 0, self.width/2, self.height);
}

-(void)selectOn
{
    self.onButton.selected = true;
}

@end
