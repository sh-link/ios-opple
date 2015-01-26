//
//  SHRouter.h
//  SHLink
//
//  Created by 钱凯 on 15/1/22.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "SHDevice.h"

@interface SHRouter : SHDevice


/**
 *  Get the shared instance of SHRouter.
 *
 *  @return The shared instance.
 */
+(instancetype)currentRouter;

@end
