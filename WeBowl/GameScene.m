//
//  GameScene.m
//  WeBowl
//
//  Created by Dana Brooks on 11/4/14.
//  Copyright (c) 2014 Dana Brooks. All rights reserved.
//

// This is a test -- modified by M. Kelly

#import "GameScene.h"

static const uint32_t ballCategory = 0x1 << 0;
static const uint32_t pinCategory = 0x1 << 1;

@implementation GameScene {
    SKSpriteNode* ballSprite;
    SKSpriteNode* pinSprite;
    NSArray* pins;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    self.physicsWorld.contactDelegate = self;
    // self.physicsWorld.gravity = CGPointVector(0, -1.0);
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"lane.jpeg"];
    bgImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    bgImage.yScale = 3.0;
    bgImage.xScale = 3.0;
    [self addChild:bgImage];
    
    // Don't show label for now
    // [self addChild:myLabel];
    
    ballSprite = [SKSpriteNode spriteNodeWithImageNamed:@"bowlingball2"];
    ballSprite.xScale = 0.5;
    ballSprite.yScale = 0.5;
    
    // Add the ball
    ballSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 220);
    NSLog(@"x = %f", [[UIScreen mainScreen] bounds].size.width / 2);
    NSLog(@"bounds = %@", NSStringFromCGRect([[UIScreen mainScreen] bounds]));

#if 0
    // Physics
    ballSprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(ballSprite.size.width/2)-7];
    ballSprite.physicsBody.usesPreciseCollisionDetection = YES;
    ballSprite.physicsBody.categoryBitMask = ballCategory;
    
    ballSprite.physicsBody.collisionBitMask = ballCategory | pinCategory;
    ballSprite.physicsBody.contactTestBitMask = ballCategory | pinCategory;
#endif
    
    [self addChild:ballSprite];

    pins = [self createPins];
    for (SKSpriteNode* s in pins) {
        [self addChild:s];
    }
    //    pinSprite = [SKSpriteNode spriteNodeWithImageNamed:@"pin.jpeg"];
//    pinSprite.xScale = 0.2;
//    pinSprite.yScale = 0.2;
//    pinSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 200);
//    [self addChild:pinSprite];
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
#if 0
            sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(sprite.size.width/2)-7];
            sprite.physicsBody.usesPreciseCollisionDetection = YES;
            sprite.physicsBody.categoryBitMask = pinCategory;
#endif
            [pinArray addObject:sprite];
        }
    }
    
    return pinArray;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.xScale = 0.5;
//        sprite.yScale = 0.5;
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
//    }
//}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    for (UITouch *touch in touches) {
//        
//        for (UITouch *touch in touches) {
//            
//            CGPoint location = [touch locationInNode:self];
//            
//            CGPoint diff = CGPointMake(location.x - self.hero.position.x, location.y - self.hero.position.y);
//            
//            CGFloat angleRadians = atan2f(diff.y, diff.x);
//            
//            [self.hero runAction:[SKAction sequence:@[
//                                                      [SKAction rotateToAngle:angleRadians duration:1.0],
//                                                      [SKAction moveByX:diff.x y:diff.y duration:3.0]
//                                                      ]]];
//        }
//    }
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    // [self runAction:[SKAction playSoundFileNamed:@"strike.wav" waitForCompletion:NO]];
    [self runAction:[SKAction playSoundFileNamed:@"strike.wav" waitForCompletion:YES] completion:^(void) {
        NSLog(@"After the ball struck the pins");
        [ballSprite removeFromParent];
        [pins[9] removeFromParent];
        [pins[3] removeFromParent];
        [pins[6] removeFromParent];
        [pins[2] removeFromParent];
        
    }];
    // CGPoint location = [touch locationInNode:self];
    CGPoint diff = CGPointMake(ballSprite.position.x - 20, ballSprite.position.y + 250);
    CGFloat angleRadians = atan2f(diff.y, diff.x);
    [ballSprite runAction:[SKAction group:@[
                                            [SKAction rotateToAngle:angleRadians duration:3.0],
                                            //                                                      [SKAction moveByX:diff.x y:diff.y duration:4.0],
                                            [SKAction moveTo:diff duration:3.0],
                                            [SKAction scaleBy:0.2 duration:3.0]
                                            ]]];
    
    
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void) didBeginContact:(SKPhysicsContact *)contact {
    NSLog(@"Contact");
}


@end
