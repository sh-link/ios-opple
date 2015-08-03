//
//  CellItemGroup.m
//  opple
//
//  Created by zhen yang on 15/7/16.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "CellItemGroup.h"

@implementation CellItemGroup
-(NSArray*)cells
{
    if(_cells == nil)
    {
        _cells = [NSMutableArray new];
    }
    return _cells;
}

+(CellItemGroup*)cellGroupWithTitle:(NSString *)title items:(NSArray *)items
{
    CellItemGroup *group  = [CellItemGroup new];
    group.title = title;
    group.cells = items;
    return group;
}
@end
