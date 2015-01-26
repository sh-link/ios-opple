//
//  SHLinkDeviceSearchTests.m
//  SHLink
//
//  Created by 钱凯 on 15/1/23.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "SHDeviceSearcher.h"

@interface SHLinkDeviceSearchTests : XCTestCase

@end

@implementation SHLinkDeviceSearchTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSearchDevice {
    SHDevice *device = [SHDeviceSearcher syncSearchDeviceWithPort:10245 TimeoutInSec:2];
    
    XCTAssertNotNil(device,@"Could not find SHRouter device!");
    
    NSLog(@"IP: %@",device.ip);
    NSLog(@"MAC:%@",device.mac);
    
    [SHDeviceSearcher syncChallengeDeviceWithIp:@"192.168.0.1" Port:10246 Username:@"admin" Password:@"admin" TimeoutInSec:2];
}



@end
