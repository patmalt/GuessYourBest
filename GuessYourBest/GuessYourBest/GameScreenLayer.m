//
//  GameScreenLayer.m
//  GuessYourBest
//
//  Created by Patrick Maltagliati on 7/21/12.
//  Copyright (c) 2012 Patrick Maltagliati. All rights reserved.
//

#import "GameScreenLayer.h"

#import "MainMenuLayer.h"
#import "GCHelper.h"

@implementation GameScreenLayer

+(id) scene
{
    CCScene *scene = [CCScene node];
    GameScreenLayer *layer = [GameScreenLayer node];
	// add layer as a child to scene
	[scene addChild: layer];
    return scene;
}


-(id) init
{
    
    if( (self=[super init] )) {
        
        //NSString *localPlayerAlias = [GKLocalPlayer localPlayer].alias;
       // NSString *remotePlaterAlias = 
        
        CCLabelTTF *message = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Game Screen"] fontName:@"Marker Felt" fontSize:20];
        message.position =  ccp(240, 220);
        [self addChild: message];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// Achievement Menu Item using blocks
		CCMenuItem *game = [CCMenuItemFont itemWithString:@"Quit" block:^(id sender) {

            [[[GCHelper sharedInstance]delegate]matchEnded];
            
		}];
        
        
		CCMenu *menu = [CCMenu menuWithItems:game, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
    }
    
    return self;
}


- (void) dealloc
{
    [super dealloc];
}



@end
