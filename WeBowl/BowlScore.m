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
    NSMutableArray * frameStat;
}

- (id)init
{
    self = [super init];
    currentScore = 0;
    frameIdx = 0;
    rollIdx = 0;
    for (int idx = 0; idx < 20; idx++)
        rollsInternal[idx] = 0;
    
    frameStat = [[NSMutableArray alloc] init] ;

    return self;
}

-(int) getCurrentScore
{
    return currentScore;
}

-(NSDictionary *) getFrameScore:(int) frame
{
    if (frame <=0) return nil;
    return frameStat[frame - 1];
}

-(int)lastCompleteFrame
{
    return frameIdx;
}

-(void)bowl:(int)num
{
    NSDictionary *frameData;
    rollsInternal[rollIdx] = num;
    rollIdx++;
    
    frameStat = [[NSMutableArray alloc] init];
    
    BOOL firstRoll = YES;
    
    currentScore = 0;
    frameIdx = 0;
    
    for (int idx = 0; idx < rollIdx; idx ++)
    {
        if (rollsInternal[idx] == 10)
        {
            currentScore += 10 + rollsInternal[idx+1] + rollsInternal[idx+2];
            frameData = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:10],@"First Ball",
                         [NSNumber numberWithInt:0],@"Second Ball",
                         [NSNumber numberWithInt:currentScore],@"Current Score",
                         nil];
            [frameStat addObject:frameData];
            frameIdx++;
            if (frameIdx >= 10) idx = 99;
        }
        else if ((rollsInternal[idx] + rollsInternal[idx+1]) == 10)
        {
            currentScore += 10 + rollsInternal[idx+2];
            idx++;
            frameData = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:rollsInternal[idx]],@"First Ball",
                         [NSNumber numberWithInt:rollsInternal[idx+1]],@"Second Ball",
                         [NSNumber numberWithInt:currentScore],@"Current Score",
                         nil];
            [frameStat addObject:frameData];
            frameIdx++;
            if (frameIdx >= 10) idx = 99;
        }
        else
        {
            currentScore += rollsInternal[idx];
            if (firstRoll)
            {
                firstRoll = NO;
                frameData = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:rollsInternal[idx]],@"First Ball",
                             [NSNumber numberWithInt:currentScore],@"Current Score",
                             nil];
                [frameStat addObject:frameData];
            }
            else
            {
                frameData = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:rollsInternal[idx-1]],@"First Ball",
                             [NSNumber numberWithInt:rollsInternal[idx]],@"Second Ball",
                             [NSNumber numberWithInt:currentScore],@"Current Score",
                             nil];
                [frameStat removeObjectAtIndex:frameIdx];
                [frameStat addObject:frameData];

                firstRoll = YES;
                frameIdx++;
                if (frameIdx >= 10) idx = 99;
            }
        }
    }
}

@end

