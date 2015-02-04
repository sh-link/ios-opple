//
//  SHLinkDeviceSearchTests.m
//  SHLink
//
//  Created by 钱凯 on 15/1/23.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "SHDeviceConnector.h"

@interface SHLinkDeviceSearchTests : XCTestCase

@end

@implementation SHLinkDeviceSearchTests
{
    NSString *ip;
    NSString *username;
    NSString *psw;
    unsigned short udpPort;
    unsigned short tcpPort;
}

- (void)setUp {
    [super setUp];
    ip = @"192.168.0.1";
    username = @"admin";
    psw = @"admin";
    udpPort = 10245;
    tcpPort = 10246;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSearchDevice {
    SHDevice *device = [SHDeviceConnector syncSearchDeviceWithPort:10245 TimeoutInSec:2];
    
    XCTAssertNotNil(device,@"Could not find SHRouter device!");
    
    NSLog(@"IP: %@",device.ip);
    NSLog(@"MAC:%@",device.mac);
    
    BOOL ret = [SHDeviceConnector syncChallengeDeviceWithIp:@"192.168.0.1" Port:10246 Username:@"admin" Password:@"admin" TimeoutInSec:2];
    XCTAssert(ret, @"challeng failed!");
}

- (void)testGetClientList {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@1,@"REQ_TYPE", nil];
    NSLog(@"%@",dic);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSError *e;
    
    NSData *respose = [SHDeviceConnector syncSendCommandWithIp:@"192.168.0.1" Port:10246 Username:@"admin" Password:@"admin" Command:jsonData TimeoutInSec:3 Error:&e];
    if (e) {
        NSLog(@"%@",[e localizedDescription]);
    }
    
    NSDictionary *rDic = [NSJSONSerialization JSONObjectWithData:respose options:0 error:&e];
    if (e) {
        NSLog(@"%@",[e localizedDescription]);
    }
    NSLog(@"%@",rDic);
}



@end
