//
//  SHLinkTests.m
//  SHLinkTests
//
//  Created by 钱凯 on 15/1/20.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Reachability.h"
#include <arpa/inet.h>

@interface SHLinkTests : XCTestCase

@end

@implementation SHLinkTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testInternetConnectable {
    
}

- (void)testReachabilityPerformance {
    // This is an example of a performance test case.
    [self measureBlock:^{
        XCTAssert([Reachability reachabilityWithHostName:@"www.baidu.com"].currentReachabilityStatus == ReachableViaWiFi, @"Not reachable!");
        [Reachability reachabilityForInternetConnection];
//        NSString *ip = @"34.8.2.133";
//        unsigned short tcpPort = 23;
//        
//        struct sockaddr_in deviceAddr;
//        bzero(&deviceAddr, sizeof(deviceAddr));
//        deviceAddr.sin_family = AF_INET;
//        deviceAddr.sin_port = htons(tcpPort);
//        deviceAddr.sin_len = sizeof(deviceAddr);
//        inet_pton(AF_INET, [ip UTF8String], &deviceAddr.sin_addr.s_addr);
//        
//        NSLog(@" hey: %d",[Reachability reachabilityWithAddress:&deviceAddr].currentReachabilityStatus == ReachableViaWiFi);

    }];
}

@end
