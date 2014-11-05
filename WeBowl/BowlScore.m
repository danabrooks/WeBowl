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

@implementation BowlScore
{
    int frameIdx;
    int currentScore;
    int rollIdx;
    int rollsInternal [20];
    int frames [10];
}

- (id)init
{
    self = [super init];
    currentScore = 0;
    frameIdx = 0;
    rollIdx = 0;
    for (int idx = 0; idx < 20; idx++)
        rollsInternal[idx] = 0;
    
    //for (int idx = 0; idx < 10; idx++)
     //   frameTotal[idx] = 0;

    return self;
}

-(int) getCurrentScore
{
    return currentScore;
}

/****
-(int) getFrameScore:(int) frame
{
    return frameTotal[frame];
}
 ***/


-(void)bowl:(int)num
{
    rollsInternal[rollIdx] = num;
    rollIdx++;
    
    BOOL firstRoll = YES;
    
    currentScore = 0;
    frameIdx = 0;
    
    for (int idx = 0; idx < rollIdx; idx ++)
    {
        if (rollsInternal[idx] == 10)
        {
            currentScore += 10 + rollsInternal[idx+1] + rollsInternal[idx+2];
            //frameTotal[frameIdx++] = currentScore;
            frameIdx++;
            if (frameIdx >= 10) idx = 99;
        }
        else if ((rollsInternal[idx] + rollsInternal[idx+1]) == 10)
        {
            currentScore += 10 + rollsInternal[idx+2];
            idx++;
           //frameTotal[frameIdx++] = currentScore;
            frameIdx++;
            if (frameIdx >= 10) idx = 99;
        }
        else
        {
            currentScore += rollsInternal[idx];
            if (firstRoll)
            {
                firstRoll = NO;
           //     frameTotal[frameIdx] = currentScore;
            }
            else
            {
                firstRoll = YES;
          //      frameTotal[frameIdx++] = currentScore;
                frameIdx++;
                if (frameIdx >= 10) idx = 99;
            }
        }
    }
}

@end

