//
//  SHLinkPacketTests.m
//  SHLink
//
//  Created by 钱凯 on 15/1/21.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Packet.h"

@interface SHLinkPacketTests : XCTestCase

@end

@implementation SHLinkPacketTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLength {
    
    _SHHeader header;
    _SHDetect detect;
    _SHDetectReply detectReply;
    _SHChallenge challenge;
    _SHChallengeReply challengeRelay;
    _SHControl control;
    _SHControlRely controlReply;
    
    XCTAssertEqual(sizeof(header), 8, @"SHHeader should be 8 bytes length.");
    XCTAssertEqual(sizeof(detect), 8, @"SHDetect packet should be 8 bytes length.");
    XCTAssertEqual(sizeof(detectReply), 56, @"SHDetect reply packet should be 56 bytes length.");
    XCTAssertEqual(sizeof(challenge), 40, @"SHChallenge packet should be 48 bytes length.");
    XCTAssertEqual(sizeof(challengeRelay), 20, @"SHChallenge reply packet should be 20 bytes length.");
    XCTAssertEqual(sizeof(control), 40, @"SHControl packet should be 48 bytes length.");
    XCTAssertEqual(sizeof(controlReply), 20, @"SHControl reply packet should be 20 bytes length.");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
