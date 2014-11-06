//
//  GameScene.h
//  WeBowl
//

//  Copyright (c) 2014 Dana Brooks. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

-(int) randomPinsDown;
-(NSArray*)getPinsKnockedDown:(int) pins;

@end
