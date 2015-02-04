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
 *  Router's tcp socket addr, used to test reachability.
 */
@property (nonatomic) struct sockaddr_in hostAddr;

/**
 *  Port we connect to communicate with router.
 */
@property (nonatomic) unsigned short tcpPort;

/**
 *  Clist list of the router, call getClientListWithError: to refresh.
 */
@property (nonatomic, retain) NSArray *clientList;


/**
 *  Get the shared instance of SHRouter.
 *
 *  @return The shared instance.
 */
+(instancetype)currentRouter;

- (BOOL)updateRouterInfo;

@end
