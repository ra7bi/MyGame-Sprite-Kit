//
//  GameScene.m
//  SpriteKitDemo2
//
//  Created by fa/Users/Fahad/Downloads/ball.pnghad alrahbi on 28/12/14.
//  Copyright (c) 2014 fahad alrahbi. All rights reserved.
//

#import "GameScene.h"

@interface GameScene()

@property(nonatomic)SKSpriteNode * paddle;

@end
@implementation GameScene



-(void)didMoveToView:(SKView *)view {
    
        // Set size of current Scene
     self.size = self.view.frame.size;
    
    /* Setup your scene here */
    self.backgroundColor=[SKColor whiteColor];
    
    // Pysic body to the scene
    self.physicsBody =[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    

    // change gravity settings of the physics world
    self.physicsWorld.gravity = CGVectorMake(0,0);
    
    
    [self addBall:self.size];
    [self addBricks:self.size];
    [self addPlayer:self.size];
   

}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    
    // this function by default give us Set of touches for loop to get all this
    for (UITouch * touch in touches)
    {
        CGPoint  location = [touch locationInNode:self]; // self related to current Scene
        
        CGPoint newPosition = CGPointMake(location.x, 100);
        

        
        // Stop the paddle  from going to far
        if(newPosition.x < self.paddle.size.width/2){
            newPosition.x = self.paddle.size.width/2;
        }
        
        if (newPosition.x >self.size.width - (self.paddle.size.width/2)) {
            newPosition.x = self.size.width - (self.paddle.size.width/2);
        }
        
        // Update Player Position
        self.paddle.position = newPosition;
    }
    

}

// Player
- (void)addPlayer:(CGSize)size{
    
  // Size ==> getting from didMoveToView
    
    // create Paddle Sprite
    
    self.paddle =[SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    
    // position
    self.paddle.position = CGPointMake(size.width/2, 100);
    
    self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.paddle.frame.size];
    
    // make it static
    self.paddle.physicsBody.dynamic = NO;
    // add to scene
    [self addChild:self.paddle];
}


// Add Bricks

-(void) addBricks:(CGSize)size{
    
    
    for (int i=0; i<4; i++) {
        SKSpriteNode * brick = [SKSpriteNode spriteNodeWithImageNamed:@"brick"];
        
        
        // Add Static physics body
        brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
        
        brick.physicsBody.dynamic =NO;
        int xPos =size.width/5 * (i+1);
        int yPos = size.height -50;
        brick.position = CGPointMake(xPos, yPos);
        
        [self addChild:brick];
        
    }
    
}

// Ball
- (void)addBall:(CGSize)size{
    
    // Size ==> getting from didMoveToView
    // create new sprite node from an image
    SKSpriteNode * ball =[SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    
    
    // create a CGPoint for position ( center of Scene )
    //Get Screen center ( i'm getting center position )  الطول تقسيم ٢ و العرض تقسيم ٢
    CGPoint myPoint =CGPointMake(size.width/2, size.height/2);
    ball.position = myPoint;
    
    
    // Add physics body to the ball
    ball.physicsBody =[SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    
    ball.physicsBody.friction = 0;
    
    /* سرعة الإيقاف او الاسقاط */
    ball.physicsBody.linearDamping = 0;
    
    // The power after touch another object 1= full power ex: p = 20  p/p = 1
    ball.physicsBody.restitution = 1;
    // add the sprite to the scene
    [self addChild:ball];
    
    
    // Create the Vector
                            //       X    Y
    CGVector myVector = CGVectorMake(15, 15);
    
    //Apply the vector to the ball
    
    [ball.physicsBody applyImpulse:myVector];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
