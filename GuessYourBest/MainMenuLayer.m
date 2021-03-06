//
//  MainMenuLayer.m
//  GuessYourBest
//
//  Created by Patrick Maltagliati on 7/21/12.
//  Copyright (c) 2012 Patrick Maltagliati. All rights reserved.
//

#import "MainMenuLayer.h"
#import "AppDelegate.h"
#import "GameScreenLayer.h"

@implementation MainMenuLayer

+(id) scene
{
    CCScene *scene = [CCScene node];
    
    MainMenuLayer *layer = [MainMenuLayer node];
    	
	// add layer as a child to scene
	[scene addChild:layer];
    
    return scene;
}

-(id) init
{
    
    if( (self=[super init] )) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile:@"load_screen_bg.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        // Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
        
        CCMenuItem *game = [CCMenuItemImage itemWithNormalImage:@"new_game_red_button.png" selectedImage:@"new_game_red_button_selected.png" block:^(id sender) {
			
            if ([[GCHelper sharedInstance]userAuthenticated] == YES) {
                AppController *delegate = (AppController*)[[UIApplication sharedApplication]delegate];               
                [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:delegate.navController delegate:self];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Game Center Not Authenticated" message:@"You must use Game Center to play this game." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
		}];
		
		CCMenu *menu = [CCMenu menuWithItems:game, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 100)];
		
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

    [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameScreenLayer scene] withColor:ccWHITE]];
}

- (void)matchEnded {    
    CCLOG(@"Match ended"); 
    
    GCHelper *helper = [GCHelper sharedInstance];
    
    AppController *delegate = (AppController*)[[UIApplication sharedApplication]delegate];
    if ([delegate.guessEntryField isEditing]) {
        delegate.sendGuessFlag = NO;
        [delegate.guessEntryField resignFirstResponder];
        [delegate.guessEntryField removeFromSuperview];
    }
    
    [helper.match disconnect];
    helper.match = nil;
    helper.otherPlayerID = nil;
    
    [[CCDirector sharedDirector] popScene];
    
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    CCLOG(@"Received data");

    CCArray *arr = [[CCDirector sharedDirector] runningScene].children;

    CCNode *curr = nil;

    for (CCNode *node in arr) {
        if ([node isKindOfClass:[GameScreenLayer class]]) {
            curr = node;
            break;
        }
    }

    GameScreenLayer *game = (GameScreenLayer*)curr;

    
    Message *message = (Message *) [data bytes];
    
    if (message->messageType == kMessageSendGuess) {
        
        MessageSendGuess *messageSendGuess = (MessageSendGuess*)[data bytes];
        
        [game changeRemoteGuess:messageSendGuess->number];
        
    }
    else if (message->messageType == kMessageScore) {
        
        MessageSendScore *messageSendScore = (MessageSendScore*)[data bytes];
        [game updateRemotePlayerScore:messageSendScore->value];
    }
    else if (message->messageType == kMessageEndGame) {
        
        MessageEndGame *messageEndGame = (MessageEndGame*)[data bytes];
        [game recieveEndGameMessage:messageEndGame->value];
    }
    else if (message->messageType == kMessageWaitStart) {
        
        MessageWaitStart *messageWaitStart = (MessageWaitStart*)[data bytes];
        [game recieveWaitStart:messageWaitStart->value];
    }
    else if (message->messageType == kMessageWaitEnd) {
        
        MessageWaitEnd *messageWaitEnd = (MessageWaitEnd*)[data bytes];
        [game recieveWaitEnd:messageWaitEnd->value];
    }
    
}

- (void)inviteReceived {
     
}

@end
