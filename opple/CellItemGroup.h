//
//  CellItemGroup.h
//  opple
//
//  Created by zhen yang on 15/7/16.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellItem.h"
@interface CellItemGroup : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSArray *cells;
+(CellItemGroup*)cellGroupWithTitle:(NSString*)title items:(NSArray*)items;
@end
