//
//  GameScene.m
//  WeBowl
//
//  Created by Dana Brooks on 11/4/14.
//  Copyright (c) 2014 Dana Brooks. All rights reserved.
//

// This is a test -- modified by M. Kelly

#import "GameScene.h"
#import "BowlScore.h"
#include <stdlib.h>

@implementation GameScene {
    SKSpriteNode* ballSprite;
    SKSpriteNode* pinSprite;
    NSArray* pins;
    BowlScore* bowlScore;
    SKLabelNode* scoreboardLabel;
}

static const uint32_t ballCategory = 0x1 << 0;
static const uint32_t pinCategory = 0x1 << 1;

-(void)didMoveToView:(SKView *)view {
    
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, 0); // CGPointVectori(0, -1.0);
    
    bowlScore = [[BowlScore alloc] init];
    
    // Add the scoreboard
    scoreboardLabel = [self myScoreBoard];
    [self addChild:scoreboardLabel];
    
    // Setup the background image of the bowling lane
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"lane.jpeg"];
    bgImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    bgImage.yScale = 3.0;
    bgImage.xScale = 3.0;
    [self addChild:bgImage];
    
    // Add the ball and pins
    [self initBall];
    pins = [self createPins];
    for (SKSpriteNode* s in pins) {
        [self addChild:s];
    }

    // Add the reset button
    [self addChild: [self resetButtonNode]];
}

- (SKLabelNode *)myScoreBoard
{
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];

    myLabel.fontSize = 20;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   self.frame.size.height - 120);

    NSMutableString* tmpLabel = [[NSMutableString alloc] init];
    int numFrames = [bowlScore lastCompleteFrame];
    for (int i = 0; i < 10; i++) {
        if (i < numFrames) {
            NSDictionary* fr = [bowlScore getFrameScore:i + 1];
            [tmpLabel appendFormat:@"[%@ %@] %@ ",
                        fr[@"First Ball"], fr[@"Second Ball"], fr[@"Current Score"]];
        }
        else {
            [tmpLabel appendFormat:@"[0 0] 0 "];
        }
    }
    myLabel.text = tmpLabel;
    return myLabel;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // If reset button touched, reset
    if ([node.name isEqualToString:@"resetButtonNode"]) {
        NSLog(@"Reset");
        [self initBall];
        [self initPins];
        return;
    }
    
    // Play the sound
    [self runAction:[SKAction playSoundFileNamed:@"strike.wav" waitForCompletion:NO]];

    // Calculate where the ball should end up
    CGPoint diff = CGPointMake(ballSprite.position.x - 20, ballSprite.position.y + 250);
    CGFloat angleRadians = atan2f(diff.y, diff.x);
    [ballSprite runAction:[SKAction group:@[
                                            [SKAction rotateToAngle:angleRadians duration:3.0],
                                            [SKAction moveTo:diff duration:3.0],
                                            [SKAction scaleBy:0.2 duration:3.0]
                                            ]] completion:^(void) {
#if 0
        [ballSprite removeFromParent];
        [pins[9] removeFromParent];
        [pins[3] removeFromParent];
        [pins[6] removeFromParent];
        [pins[2] removeFromParent];
        NSArray *pinsArray = [self getPinsKnockedDown:[self randomPinsDown]];
        NSLog(@"Pins knocked down = %@", pinsArray);
        [bowlScore bowl:(int)pinsArray.count];
        NSLog(@"current score = %d", [bowlScore getCurrentScore]);
        NSLog(@"last complete frame = %d", [bowlScore lastCompleteFrame]);
        NSLog(@"frame score = %@", [bowlScore getFrameScore:1]);
        [scoreboardLabel removeFromParent];
        scoreboardLabel = [self myScoreBoard];
        [self addChild:scoreboardLabel];
#endif
    }];

}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void) didBeginContact:(SKPhysicsContact *)contact {
    NSLog(@"Contact");
    [ballSprite removeFromParent];
    [pins[9] removeFromParent];
    [pins[3] removeFromParent];
    [pins[6] removeFromParent];
    [pins[2] removeFromParent];
    NSArray *pinsArray = [self getPinsKnockedDown:[self randomPinsDown]];
    NSLog(@"Pins knocked down = %@", pinsArray);
    [bowlScore bowl:(int)pinsArray.count];
    NSLog(@"current score = %d", [bowlScore getCurrentScore]);
    NSLog(@"last complete frame = %d", [bowlScore lastCompleteFrame]);
    NSLog(@"frame score = %@", [bowlScore getFrameScore:1]);
    [scoreboardLabel removeFromParent];
    scoreboardLabel = [self myScoreBoard];
    [self addChild:scoreboardLabel];
}

#pragma mark - Knocked Down Pins Utilities

-(int) randomPinsDown
{
    int r = 0;

    while (r == 0) {
        if (arc4random_uniform != NULL)
            r = arc4random_uniform (10);
    }

    return r;
}

-(NSArray*)getPinsKnockedDown:(int) pinsDown
{

    NSMutableArray* p = [[NSMutableArray alloc] init];

    NSLog(@"numberKnockedDown = %d", pinsDown);

    int counter = 0;
    while (counter < pinsDown) {
        int pinKnockedDown = arc4random_uniform (10) + 1;
        [p addObject:[NSNumber numberWithInt:pinKnockedDown]];
        counter++;
    }
    
    return p;
}

#pragma mark - UI Utilities

- (SKSpriteNode *)resetButtonNode {
    SKSpriteNode *resetNode = [SKSpriteNode spriteNodeWithImageNamed:@"reset-button.jpeg"];
    resetNode.position = CGPointMake(self.frame.size.width - resetNode.size.width, 200);
    resetNode.xScale = .25;
    resetNode.yScale = .25;
    resetNode.name = @"resetButtonNode";//how the node is identified later
    resetNode.zPosition = 1.0;
    return resetNode;
}

-(void)initBall {
    ballSprite = [SKSpriteNode spriteNodeWithImageNamed:@"bowlingball"];
    ballSprite.xScale = 0.5;
    ballSprite.yScale = 0.5;
    
    // Add the ball
    ballSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 220);
    ballSprite.name = @"ball";
    NSLog(@"x = %f", [[UIScreen mainScreen] bounds].size.width / 2);
    NSLog(@"bounds = %@", NSStringFromCGRect([[UIScreen mainScreen] bounds]));
    
    // Physics
    ballSprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(ballSprite.size.width/2)];
    ballSprite.physicsBody.usesPreciseCollisionDetection = YES;
    ballSprite.physicsBody.categoryBitMask = ballCategory;
    ballSprite.physicsBody.dynamic = YES;
    ballSprite.physicsBody.collisionBitMask = pinCategory | ballCategory;
    ballSprite.physicsBody.contactTestBitMask = pinCategory | ballCategory;
    
    [self addChild:ballSprite];
}

-(void)initPins {
    for (SKSpriteNode* s in pins) {
        [s removeFromParent];
    }
    [self createPins];
    for (SKSpriteNode* s in pins) {
        [self addChild:s];
    }
    
}

-(NSArray*)createPins {
    NSMutableArray* pinArray = [[NSMutableArray alloc] init];
    int pinsPerRow[] = {1, 2, 3, 4};
    
    CGPoint firstPin = CGPointMake(CGRectGetMidX(self.frame) - 40, CGRectGetMidY(self.frame) + 50);
    for (int i = 3; i >= 0; i--) {
        CGPoint firstPinOnRow;
        firstPinOnRow.x = firstPin.x - (((pinsPerRow[i] - 1) * 20) / 2);
        firstPinOnRow.y = firstPin.y + (i * 5);
        for (int j = 0; j < pinsPerRow[i]; j++) {
            SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithImageNamed:@"pin.jpeg"];
            sprite.xScale = 0.2;
            sprite.yScale = 0.2;
            CGPoint pos;
            pos.x = firstPinOnRow.x += 20;
            pos.y = firstPinOnRow.y;
            sprite.position = pos;
            if (pinsPerRow[i] == 1) {
                // sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(sprite.size.width/2)];
                sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
                sprite.physicsBody.usesPreciseCollisionDetection = YES;
                sprite.physicsBody.dynamic = YES;
                sprite.physicsBody.categoryBitMask = pinCategory;
            }
            [pinArray addObject:sprite];
        }
    }
    
    return pinArray;
}

@end
