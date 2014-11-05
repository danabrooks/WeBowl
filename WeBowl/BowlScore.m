//
//  BowlScore.m
//  WeBowl
//
//  Created by Dinesh Gowda on 11/5/14.
//  Copyright (c) 2014 Dana Brooks. All rights reserved.

#import <UIKit/UIKit.h>
#import "BowlScore.h"

@interface BowlScore ()

@end

@implementation BowlScore {
    int currentScore;
}

- (id)init
{
    self = [super init];
    currentScore = 0;
    return self;

}

-(int) getCurrentScore
{
    return currentScore;
}

-(void)bowl:(int)num {
    currentScore += num;
}

@end

