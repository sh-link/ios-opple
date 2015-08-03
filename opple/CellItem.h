//
//  CellItem.h
//  opple
//
//  Created by zhen yang on 15/7/16.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellItem : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *value;

+(CellItem*)cellItemWithTitle:(NSString*)title value:(NSString*)value;
@end
