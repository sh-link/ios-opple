//
//  CellItem.m
//  opple
//
//  Created by zhen yang on 15/7/16.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "CellItem.h"

@implementation CellItem
+(CellItem*)cellItemWithTitle:(NSString *)title value:(NSString *)value
{
    CellItem *item = [CellItem new];
    item.title = title;
    item.value = value;
    return item;
}
@end
