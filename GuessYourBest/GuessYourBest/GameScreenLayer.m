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
@synthesize productImage,productDescLabel,productTitleLabel,productDictionary;

+(id) scene
{
    CCScene *newScene = [CCScene node];
    GameScreenLayer *layer = [GameScreenLayer node];
	// add layer as a child to scene
	[newScene addChild: layer];
    return newScene;
}


-(id) init
{
    
    if( (self=[super init] )) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile:@"game_screen_bg.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        GKPlayer *remotePlayer = [[[GCHelper sharedInstance]playersDict] objectForKey:[[GCHelper sharedInstance]otherPlayerID]];
        
        CCLabelTTF *localPlayerAliasLabel = [CCLabelTTF labelWithString:localPlayer.alias fontName:@"Marker Felt" fontSize:20];
        localPlayerAliasLabel.position = ccp(65,305);
        localPlayerAliasLabel.color = ccc3(158,31,99);
        [self addChild:localPlayerAliasLabel];
        
        CCLabelTTF *remotePlayerAliasLabel = [CCLabelTTF labelWithString:remotePlayer.alias fontName:@"Marker Felt" fontSize:20];
        remotePlayerAliasLabel.position = ccp(405,305);
        remotePlayerAliasLabel.color = ccc3(158,31,99);
        [self addChild:remotePlayerAliasLabel];
        
        localPlayerScore = 0;
        remotePlayerScore = 0;
        
        localPlaerScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i",localPlayerScore] fontName:@"Marker Felt" fontSize:20];
        localPlaerScoreLabel.position = ccp(60,250);
        localPlaerScoreLabel.color = ccc3(158,31,99);
        [self addChild:localPlaerScoreLabel];
        
        remotePlaerScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i",remotePlayerScore] fontName:@"Marker Felt" fontSize:20];
        remotePlaerScoreLabel.position = ccp(400,250);
        remotePlaerScoreLabel.color = ccc3(158,31,99);
        [self addChild:remotePlaerScoreLabel];
        
        
        // Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// Achievement Menu Item using blocks
		CCMenuItem *quit = [CCMenuItemImage itemWithNormalImage:@"quit_red_button.png" selectedImage:@"quit_red_button_selected.png" block:^(id sender){
            [[[GCHelper sharedInstance]delegate]matchEnded];
		}];
        
        
		CCMenu *menu = [CCMenu menuWithItems:quit, nil];
		[menu setPosition:ccp( size.width/2 + 150, size.height/2 - 110)];
		[self addChild:menu];
        
        
        CCMenuItemImage *guess = [CCMenuItemImage itemWithNormalImage:@"guess_purple_button.png" selectedImage:@"guess_purple_button_selected.png" target:self selector:@selector(showGuessPicker)];
        CCMenu *guessMenu = [CCMenu menuWithItems:guess, nil];
		[guessMenu setPosition:ccp( size.width/2 - 150, size.height/2 - 110)];
        [self addChild:guessMenu];
        
        remoteGuessLabel = [CCLabelTTF labelWithString:@"---" fontName:@"Marker Felt" fontSize:20];
        remoteGuessLabel.position = ccp(400,220);
        remoteGuessLabel.color = ccc3(158,31,99);
        [self addChild:remoteGuessLabel];
        
        localGuessLabel = [CCLabelTTF labelWithString:@"---" fontName:@"Marker Felt" fontSize:20];
        localGuessLabel.position = ccp(60,220);
        localGuessLabel.color = ccc3(158,31,99);
        [self addChild:localGuessLabel];
        
        productCount = 0;
        productDictionary = [self populateProductDictionary];
		[self loadAndSetNewProductForKey:[NSString stringWithFormat:@"%i",productCount]];
        productCount++;
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


- (void) makeGuess:(NSString*)guess
{
    MessageSendScore message;
    message.message.messageType = kMessageSendGuess;
    
    float a = [guess floatValue];
    
    [localGuessLabel setString:[NSString stringWithFormat:@"$%.0f",a]];
    
    message.number = a;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageSendScore)];
    [self sendData:data];
}


- (void)sendData:(NSData *)data
{
    NSError *error;
    BOOL success = [[GCHelper sharedInstance].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (!success) {
        CCLOG(@"Error sending init packet");
        [[[GCHelper sharedInstance]delegate] matchEnded];
    }
}


- (void) changeRemoteGuess:(NSString*)string
{
    [remoteGuessLabel setString:string];
}


- (void) loadAndSetNewProductForKey:(NSString*)key
{
    Product *curr = [productDictionary objectForKey:key];
    
    if (productTitleLabel == nil) {
        productTitleLabel = [CCLabelTTF labelWithString:curr.title fontName:@"Marker Felt" fontSize:12];
        productTitleLabel.position = ccp(240,220);
        productTitleLabel.color = ccc3(158,31,99);
        [self addChild:productTitleLabel];
    }
    else {
        [productTitleLabel setString:curr.title];
    }
    
}


- (NSDictionary*) populateProductDictionary
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithCapacity:5];
    
    NSString *productsPath = [[NSBundle mainBundle] pathForResource:@"products" ofType:@"plist"];
    NSDictionary *prodDict = [NSDictionary dictionaryWithContentsOfFile:productsPath];
    
    for (int count = 0; count < 4; count++) {
        
        int rand = arc4random() % 10;
        
        NSDictionary *currentDict = [prodDict objectForKey:[NSString stringWithFormat:@"%i",rand]];
        NSString *title = [currentDict objectForKey:@"title"];
        NSString *price = [currentDict objectForKey:@"title"];
        NSString *desc = [currentDict objectForKey:@"title"];
        NSString *imageName = [currentDict objectForKey:@"title"];
        Product *newProd = [[Product alloc]initWihTitle:title andDesc:desc andImageName:imageName andPrice:price];
        [tempDict setObject:newProd forKey:[NSString stringWithFormat:@"%i",count]];
        [newProd release];
    }
    
    return [NSDictionary dictionaryWithDictionary:tempDict];
    
    [tempDict release];
}

@end
