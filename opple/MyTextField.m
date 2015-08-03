//
//  MyTextField.m
//  opple
//
//  Created by zhen yang on 15/7/17.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

-(id)init
{
    self = [super init];
    if(self)
    {
        self.layer.borderColor = getColor(0x57, 0x57, 0x57, 100).CGColor;
        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 0.8;
    }
    return self;
}

@end
