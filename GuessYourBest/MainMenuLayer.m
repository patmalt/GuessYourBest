//
//  MainMenuLayer.m
//  GuessYourBest
//
//  Created by Patrick Maltagliati on 7/21/12.
//  Copyright (c) 2012 Patrick Maltagliati. All rights reserved.
//

#import "MainMenuLayer.h"
#import "AppDelegate.h"

@implementation MainMenuLayer

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    MainMenuLayer *layer = [MainMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    return scene;
}

-(id) init
{
    
    if( (self=[super init] )) {
        
        CCLabelTTF *message = [CCLabelTTF labelWithString:@"Guess Your Best" fontName:@"Marker Felt" fontSize:64];
        message.position =  ccp(240, 220);
        [self addChild: message];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// Achievement Menu Item using blocks
		CCMenuItem *game = [CCMenuItemFont itemWithString:@"New Game" block:^(id sender) {
			
			AppController *delegate = (AppController*)[[UIApplication sharedApplication]delegate];               
            [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:delegate.navController delegate:self];
			
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


#pragma mark GCHelperDelegate

- (void)matchStarted {    
    CCLOG(@"Match started");        
}

- (void)matchEnded {    
    CCLOG(@"Match ended");    
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    CCLOG(@"Received data");
}

@end
