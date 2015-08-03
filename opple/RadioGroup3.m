//
//  RadioGroup3.m
//  opple
//
//  Created by zhen yang on 15/7/20.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "RadioGroup3.h"
#import "RadioButton.h"
#import "MessageUtil.h"
#import "UIView+Extension.h"
@implementation RadioGroup3
{
    RadioButton *router;
    RadioButton *ap;
    RadioButton *repeater;
}


-(id)init
{
    self = [super init];
    if(self)
    {
        [self setUp];
    }
    return  self;
}

-(void)setUp
{
    router = [RadioButton new];
    ap = [RadioButton new];
    repeater = [RadioButton new];
    
    [router setTitle:@"router" forState:UIControlStateNormal];
    [ap setTitle:@"ap" forState:UIControlStateNormal];
    [repeater setTitle:@"repeater" forState:UIControlStateNormal];
    
    [self addSubview:router];
    [self addSubview:ap];
    [self addSubview:repeater];
    
    UIColor *color = getColor(0x57, 0x57, 0x57, 255);
    [router setTitleColor:color forState:UIControlStateNormal];
    [ap setTitleColor:color forState:UIControlStateNormal];
    [repeater setTitleColor:color forState:UIControlStateNormal];
    
    router.titleLabel.font = [UIFont systemFontOfSize:13];
    ap.titleLabel.font = [UIFont systemFontOfSize:13];
    repeater.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [router setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [router setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    
    [ap setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [ap setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    
    [repeater setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [repeater setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    
    self.width = 220;
    self.height = 30;
    
    router.groupButtons = @[router, ap, repeater];
    ap.groupButtons = @[router, ap, repeater];
    repeater.groupButtons = @[router, ap, repeater];
    
    [router addTarget:self action:@selector(routerClick) forControlEvents:UIControlEventTouchUpInside];
    [ap addTarget:self action:@selector(apClick) forControlEvents:UIControlEventTouchUpInside];
    [repeater addTarget:self action:@selector(repeaterClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)layoutSubviews{
    router.frame = CGRectMake(0, 0, self.width / 3.0f - 10, self.height);
    ap.frame = CGRectMake(CGRectGetMaxX(router.frame), 0, self.width / 3.0f - 10, self.height);
    repeater.frame = CGRectMake(CGRectGetMaxX(ap.frame), 0, self.width / 3.0f + 10, self.height);
}

-(void)routerClick
{
    [self.delegate itemSelected:0];
}

-(void)apClick
{
    [self.delegate itemSelected:1];
}

-(void)repeaterClick
{
    [self.delegate itemSelected:2];
}
-(void)clickItem:(int)index
{
    if(index == 0)
    {
        [router sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else if(index == 1)
    {
        [ap sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [repeater sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}
@end
