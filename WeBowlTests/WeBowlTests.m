//
//  WeBowlTests.m
//  WeBowlTests
//
//  Created by Dana Brooks on 11/4/14.
//  Copyright (c) 2014 Dana Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BowlScore.h"

@interface WeBowlTests : XCTestCase

@end

@implementation WeBowlTests

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

- (void)testScoreGameWithNoBonuses {
    // This is an example of a functional test case.
    BowlScore* bs = [[BowlScore alloc] init];
    [bs bowl:1];
    [bs bowl:1];
    [bs bowl:1];
    [bs bowl:1];
    [bs bowl:1];
    [bs bowl:1];
    [bs bowl:1];
    [bs bowl:1];
    int score = [bs getCurrentScore];

    XCTAssert((score == 8), @"Pass");




    XCTAssert(YES, @"Pass");
}

- (void)testGetCurrentFrame {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testGetCurrentBall {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
