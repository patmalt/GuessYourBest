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
#import "AppDelegate.h"

@implementation GameScreenLayer

@synthesize localPlaerScoreLabel, localGuessLabel, remotePlaerScoreLabel, remoteGuessLabel;

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
        
        localPlayerScore = 0;
        remotePlayerScore = 0;
        
        localPlaerScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",localPlayerScore] fontName:@"Marker Felt" fontSize:20];
        localPlaerScoreLabel.position = ccp(60,200);
        [self addChild:localPlaerScoreLabel];
        
        remotePlaerScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",remotePlayerScore] fontName:@"Marker Felt" fontSize:20];
        remotePlaerScoreLabel.position = ccp(400,200);
        [self addChild:remotePlaerScoreLabel];
        
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        GKPlayer *remotePlayer = [[[GCHelper sharedInstance]playersDict] objectForKey:[[GCHelper sharedInstance]otherPlayerID]];
        
        CCLabelTTF *localPlayerAliasLabel = [CCLabelTTF labelWithString:localPlayer.alias fontName:@"Marker Felt" fontSize:20];
        localPlayerAliasLabel.position = ccp(60,220);
        [self addChild:localPlayerAliasLabel];
        
        CCLabelTTF *remotePlayerAliasLabel = [CCLabelTTF labelWithString:remotePlayer.alias fontName:@"Marker Felt" fontSize:20];
        remotePlayerAliasLabel.position = ccp(400,220);
        [self addChild:remotePlayerAliasLabel];
        
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
		[self addChild:menu];
        
        
        CCMenuItemFont *makeGuess = [CCMenuItemFont itemWithString:@"Guess" target:self selector:@selector(showNumberPicker)];
        CCMenu *guessMenu = [CCMenu menuWithItems:makeGuess, nil];
        [guessMenu alignItemsHorizontallyWithPadding:20];
		[guessMenu setPosition:ccp( size.width/2 - 40, size.height/2 - 80)];
        [self addChild:guessMenu];
		
    }
    
    return self;
}


- (void) dealloc
{
    [super dealloc];
}

- (void) showGuessPicker
{
    AppController *delegate = (AppController*)[[UIApplication sharedApplication]delegate];  
    [delegate showMakeGuess];
}


- (void) makeGuess:(float)guess
{
    NSMutableData *dataToSend = [NSMutableData dataWithCapacity:0];
    [dataToSend appendBytes:&guess length:sizeof(float)];
    [self sendData:dataToSend];
    
}

- (void)sendGuess 
{
    
}

- (void)sendData:(NSData *)data {
    NSError *error;
    BOOL success = [[GCHelper sharedInstance].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (!success) {
        CCLOG(@"Error sending init packet");
        [[[GCHelper sharedInstance]delegate] matchEnded];
    }
}

@end
