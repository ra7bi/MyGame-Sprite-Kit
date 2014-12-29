//
//  GameScene.m
//  SpriteKitDemo2
//
//  Created by fa/Users/Fahad/Downloads/ball.pnghad alrahbi on 28/12/14.
//  Copyright (c) 2014 fahad alrahbi. All rights reserved.
//

#import "GameScene.h"
#import "EndScene.h"
@interface GameScene()

@property(nonatomic)SKSpriteNode * paddle;
@property(nonatomic)SKSpriteNode * ball;
@property(nonatomic)int score;


@end

// be careful when providing direct integer values - this would cause problems.
// static const uint32_t WHOOPSCategory = 15; // 00000000000000000000000000001111

/* alternatively, using bitwise operators
 static const uint32_t ballCategory   = 0x1;      // 00000000000000000000000000000001
 static const uint32_t brickCategory  = 0x1 << 1; // 00000000000000000000000000000010
 static const uint32_t paddleCategory = 0x1 << 2; // 00000000000000000000000000000100
 static const uint32_t edgeCategory   = 0x1 << 3; // 00000000000000000000000000001000
 */

static const uint32_t ballCategory   = 1;
static const uint32_t brickCategory  = 2;
static const uint32_t paddleCategory = 4;
static const uint32_t edgeCategory   = 8;
static const uint32_t bottomEdgeCategory   = 16; // الارضية


@implementation GameScene



-(void)didMoveToView:(SKView *)view {
    self.score =0;
        // Set size of current Scene
     self.size = self.view.frame.size;
    
    /* Setup your scene here */
    self.backgroundColor=[SKColor orangeColor];
    
    // Pysic body to the scene
    self.physicsBody =[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    

    // change gravity settings of the physics world
    self.physicsWorld.gravity = CGVectorMake(0,1);
    
    // delegate of the will be on this class
    self.physicsWorld.contactDelegate =self;
    
    self.physicsBody.categoryBitMask = edgeCategory;
    
    [self addBall:self.size];
    [self addBricks:self.size];
    [self addPlayer:self.size];
    [self addBottomEdge:self.size];
   
    

}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    
    // this function by default give us Set of touches for loop to get all this
    for (UITouch * touch in touches)
    {
        CGPoint  location = [touch locationInNode:self]; // self related to current Scene
        
        CGPoint newPosition = CGPointMake(location.x, 40);

        
       
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
    self.paddle.position = CGPointMake(size.width/2, 40);
    
    self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.paddle.frame.size];

    // make it static
    self.paddle.physicsBody.dynamic = NO;
    // add to scene
    self.paddle.physicsBody.categoryBitMask =paddleCategory;
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
        brick.physicsBody.categoryBitMask=brickCategory;
        [self addChild:brick];
        
    }
    
}

// Ball
- (void)addBall:(CGSize)size{
    
    // Size ==> getting from didMoveToView
    // create new sprite node from an image
    self.ball =[SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    
    
    // create a CGPoint for position ( center of Scene )
    //Get Screen center ( i'm getting center position )  الطول تقسيم ٢ و العرض تقسيم ٢
    CGPoint myPoint =CGPointMake(size.width/2, size.height/2);
    self.ball.position = myPoint;
    
    
    // Add physics body to the ball
    self.ball.physicsBody =[SKPhysicsBody bodyWithCircleOfRadius:self.ball.frame.size.width/2];
    
    // احتكاك
    self.ball.physicsBody.friction = 0;
 
    /* سرعة الإيقاف او الاسقاط */
    self.ball.physicsBody.linearDamping = 0;
    
    
    // The power after touch another object 1= full power ex: speed before touch/speed after = (20/20)=1
    self.ball.physicsBody.restitution = 1.0f;
    
    
    // Add category AND     // i want to say if ball touce brick  |=> OR
    self.ball.physicsBody.categoryBitMask = ballCategory;
    self.ball.physicsBody.contactTestBitMask = brickCategory | paddleCategory | bottomEdgeCategory;
    
    // add the sprite to the scene
    [self addChild:self.ball];
    
    
    // Create the Vector
                            //       X    Y
    CGVector myVector = CGVectorMake(10, 10);
    
    //Apply the vector to the ball
    
    [self.ball.physicsBody applyImpulse:myVector];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */


    
}


// IF Contact is true
-(void)didBeginContact:(SKPhysicsContact *)contact{
    

    
    // check if ball or brick
    SKPhysicsBody * notTheBall;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        notTheBall = contact.bodyB;
    
    }else{
        notTheBall =contact.bodyA;
    }
    
    if (notTheBall.categoryBitMask == brickCategory) {
//        SKAction * playSound =[SKAction playSoundFileNamed:@"brickhit.caf" waitForCompletion:NO];
//        [self runAction:playSound];
//        
        self.score++;
        [notTheBall.node removeFromParent];
    }
    
    if (notTheBall.categoryBitMask ==paddleCategory )
    {
        
        SKAction * playSFX =[SKAction playSoundFileNamed:@"blip.caf" waitForCompletion:NO];
        
        // Who play this songe
        [self runAction:playSFX];

    }
    
    if (notTheBall.categoryBitMask ==bottomEdgeCategory)
    {
        
       // End  Scene
        EndScene * end =[EndScene sceneWithSize:self.size];
        [self.view presentScene:end transition:[SKTransition doorsCloseHorizontalWithDuration:1.0]];
        
                                   
    }
}



-(void)addBottomEdge:(CGSize)size{
    // رسم الارضية فقط
    SKNode *bottomEdge = [SKNode node];
    bottomEdge.physicsBody =  [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 1) toPoint:CGPointMake(size.width, 1)];
    
    bottomEdge.physicsBody.categoryBitMask = bottomEdgeCategory;
    [self addChild:bottomEdge];
}

@end
