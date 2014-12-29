//
//  EndScene.m
//  SpriteKitDemo2
//
//  Created by fahad alrahbi on 30/12/14.
//  Copyright (c) 2014 fahad alrahbi. All rights reserved.
//

#import "EndScene.h"
#import "GameScene.h"
@implementation EndScene

-(void)didMoveToView:(SKView *)view {

    self.size = self.view.frame.size;
    
    
    self.backgroundColor =[SKColor blackColor];
    SKLabelNode * lable =[SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    lable.text=[NSString stringWithFormat:@"GAME OVER  "];
    lable.fontColor=[SKColor whiteColor];
    lable.fontSize = 44;
    lable.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    
    SKAction * faildSound =[SKAction playSoundFileNamed:@"gameover.caf" waitForCompletion:YES];
    [self runAction:faildSound];
    
    
    [self addChild:lable];
    
    
    // Labe 2
    SKLabelNode * backLable = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    backLable.text=@"Tap to play Again";
    backLable.fontColor=[SKColor whiteColor];
    backLable.fontSize=22;
    backLable.position=CGPointMake(self.size.width/2, 50);
   
    
    // Lable 3  Developer
    
    SKLabelNode * devName =[SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    devName.text =@"Developed By Fahad Alrahbi";
    devName.position=CGPointMake(self.size.width/2, 30);
    devName.fontColor=[SKColor yellowColor];
    devName.fontSize = 18;
    
    [self addChild:devName];
    
    SKAction * moveLable = [SKAction moveToY:(self.size.height/2-40) duration:1.0];
    [backLable runAction:moveLable];
    
    
    [self addChild:backLable];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    
    GameScene * playAgain =[GameScene  sceneWithSize:self.size];
    [self.view presentScene:playAgain transition:[SKTransition doorsOpenHorizontalWithDuration:2.0]];

}
@end
