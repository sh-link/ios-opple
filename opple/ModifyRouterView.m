//
//  ModifyRouterView.m
//  opple
//
//  Created by zhen yang on 15/7/20.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "ModifyRouterView.h"
#import "UIView+Extension.h"
#import "MessageUtil.h"
@interface ModifyRouterView() <ModifyRouterView2Delegate>

@end
@implementation ModifyRouterView
{
    int ssid1Height;
    int ssid2Height;
    int ssid3Height;
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
    self.base = [ModifyRouterViewBase new];
    self.one = [ModifyRouterView2 new];
    self.two = [ModifyRouterView2 new];
    self.three = [ModifyRouterView2 new];
    
    self.one.delegete = self;
    self.two.delegete = self;
    self.three.delegete = self;
    
    
    [self.one setSsid:@"无线ssid1"];
    [self.two setSsid:@"无线ssid2"];
    [self.three setSsid:@"无线ssid3"];
    
    [self addSubview:self.base];
    [self addSubview:self.one];
    [self addSubview:self.two];
    [self addSubview:self.three];
    
    ssid1Height = self.one.height;
    ssid2Height = self.two.height;
    ssid3Height = self.three.height;
    
    self.one.height = self.two.height = self.three.height = 0;
    self.one.hidden = self.two.hidden = self.three.hidden = true;
    
    self.base.x = self.one.x = self.two.x = self.three.x = 0;
    self.base.y = 0;
    self.one.y = CGRectGetMaxY(self.base.frame);
    self.two.y = CGRectGetMaxY(self.one.frame);
    self.three.y = CGRectGetMaxY(self.two.frame);
    
    self.height = CGRectGetMaxY(self.three.frame);

  
}

-(void)layoutSubviews
{
    self.base.width = self.one.width = self.two.width = self.three.width = self.width;
    
}

-(void)showSSID1
{
    self.one.height = ssid1Height;
    self.one.hidden = false;
    self.one.y = CGRectGetMaxY(self.base.frame);
    self.two.y = CGRectGetMaxY(self.one.frame);
    self.three.y = CGRectGetMaxY(self.two.frame);
    
    self.height = CGRectGetMaxY(self.three.frame);

    [self updateSSIDName];
}

-(void)showSSID2
{
    self.two.height = ssid2Height;
    self.two.hidden = false;
    self.one.y = CGRectGetMaxY(self.base.frame);
    self.two.y = CGRectGetMaxY(self.one.frame);
    self.three.y = CGRectGetMaxY(self.two.frame);
    
    self.height = CGRectGetMaxY(self.three.frame);
    
    [self updateSSIDName];
}

-(void)showSSID3
{
    self.three.height = ssid3Height;
    self.three.hidden = false;
    self.one.y = CGRectGetMaxY(self.base.frame);
    self.two.y = CGRectGetMaxY(self.one.frame);
    self.three.y = CGRectGetMaxY(self.two.frame);
    
    self.height = CGRectGetMaxY(self.three.frame);
    [self updateSSIDName];
}

-(void)hideSSID1
{
    self.one.height = 0;
    self.one.hidden = true;
    self.one.y = CGRectGetMaxY(self.base.frame);
    self.two.y = CGRectGetMaxY(self.one.frame);
    self.three.y = CGRectGetMaxY(self.two.frame);
    
    self.height = CGRectGetMaxY(self.three.frame);
}

-(void)hideSSID2
{
    self.two.height = 0;
    self.two.hidden = true;
    self.one.y = CGRectGetMaxY(self.base.frame);
    self.two.y = CGRectGetMaxY(self.one.frame);
    self.three.y = CGRectGetMaxY(self.two.frame);
    
    self.height = CGRectGetMaxY(self.three.frame);
}

-(void)hideSSID3
{
    self.three.height = 0;
    self.three.hidden = true;
    self.one.y = CGRectGetMaxY(self.base.frame);
    self.two.y = CGRectGetMaxY(self.one.frame);
    self.three.y = CGRectGetMaxY(self.two.frame);
    
    self.height = CGRectGetMaxY(self.three.frame);

}

-(void)deleteMyself:(ModifyRouterView2 *)view
{
    [self.delegate deleteMyself:view];
    [self updateSSIDName];
}

-(void)updateSSIDName
{
    //调整显示
    if(!self.one.isHidden)
    {
        self.one.label_ssid.text = @"无线ssid1";
    }
    
    if(!self.two.isHidden)
    {
        if(!self.one.isHidden)
        {
            self.two.label_ssid.text = @"无线ssid2";
        }
        else
        {
            self.two.label_ssid.text = @"无线ssid1";
        }
    }
    if(!self.three.isHidden)
    {
        if(self.one.isHidden && self.two.isHidden)
        {
            self.three.label_ssid.text = @"无线ssid1";
        }
        else if(!self.one.isHidden && !self.two.isHidden)
        {
            self.three.label_ssid.text = @"无线ssid3";
        }
        else
        {
            self.three.label_ssid.text = @"无线ssid2";
        }
    }
}
@end
