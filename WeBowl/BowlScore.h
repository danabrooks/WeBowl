//
//  BowlScore.h
//  WeBowl
//
//  Created by Dinesh Gowda on 11/5/14.
//  Copyright (c) 2014 Dana Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BowlScore : NSObject
-(int) getCurrentScore;
-(id) getFrameScore:(int) frame;
-(void) bowl: (int) num;
-(int)lastCompleteFrame;

@property (nonatomic, assign) NSMutableArray * rolls;

@end


