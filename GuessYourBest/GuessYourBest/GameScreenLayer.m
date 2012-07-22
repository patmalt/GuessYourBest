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
#import "Product.h"

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
        localPlayerAliasLabel.position = ccp(65,308);
        localPlayerAliasLabel.color = ccc3(158,31,99);
        [self addChild:localPlayerAliasLabel];
        
        remoteAlias = remotePlayer.alias;
        CCLabelTTF *remotePlayerAliasLabel = [CCLabelTTF labelWithString:remoteAlias fontName:@"Marker Felt" fontSize:20];
        remotePlayerAliasLabel.position = ccp(405,308);
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
        
        localPlayerGuessed = NO;
        remotePlayerGuessed = NO;
        
        localEndGame = NO;
        remoteEndGame = NO;

        productDictionary = [[self populateProductDictionary]retain];        
        [self loadAndSetNewProductForKey:[NSString stringWithFormat:@"%i",productCount]];
    }
    
    return self;
}


- (void) dealloc
{
    [super dealloc];
    [productDictionary release];
}


- (void) showGuessPicker
{
    AppController *delegate = (AppController*)[[UIApplication sharedApplication]delegate];  
    [delegate showMakeGuess];
}


- (void) makeGuess:(NSString*)guess
{
    MessageSendGuess message;
    message.message.messageType = kMessageSendGuess;
    
    float a = [guess floatValue];
    
    [localGuessLabel setString:[NSString stringWithFormat:@"$%.0f",a]];
    
    localPlayerGuessed = YES;
    localPlayerGuess = a;
    
    if ([remoteGuessLabel.string isEqual:[NSString stringWithFormat:@"???"]]) {
        [remoteGuessLabel setString:[NSString stringWithFormat:@"$%.0f",remotePlayerGuess]];
    }
    
    message.number = a;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageSendGuess)];
    [self sendData:data];
    
    [self tryToDetermineWinnerOfProduct];
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


- (void) changeRemoteGuess:(float)value
{
    if ([localGuessLabel.string isEqual:[NSString stringWithFormat:@"---"]]) {
        [remoteGuessLabel setString:@"???"];
    }
    else {
        [remoteGuessLabel setString:[NSString stringWithFormat:@"$%.0f",value]];
    }
    
    remotePlayerGuess = value;
    remotePlayerGuessed = YES;
    
    [self tryToDetermineWinnerOfProduct];
}


- (void)tryToDetermineWinnerOfProduct
{
    if (!(localPlayerGuessed && remotePlayerGuessed)) {return;}
    
    Product *curr = (Product*)[productDictionary objectForKey:[NSString stringWithFormat:@"%i",productCount]];

    float actualPrice = [curr.price floatValue];

    float localPlayerDiff = actualPrice - localPlayerGuess;
    float remotePlayerDiff = actualPrice - remotePlayerGuess;
    
    NSString *localString;
    NSString *remoteString;
    
    int localFlag;
    int remoteFlag;
    
    if (localPlayerDiff == 0) {
        localFlag = 0;
        localString = [NSString stringWithFormat:@"You guessed the retail price exactly!"];
    }
    else if (localPlayerDiff < 0) {
        localFlag = -1;
        localString = [NSString stringWithFormat:@"Your guess was over the retail price!"];
    }
    else {
        localFlag = 1;
        localString = [NSString stringWithFormat:@"You guessed $%.0f under the retail price!",localPlayerDiff];
    }
    

    NSString *otherPlayer = remoteAlias;
    
    if (remotePlayerDiff == 0) {
        remoteFlag = 0;
        remoteString = [NSString stringWithFormat:@"%@ guessed the retail price exactly!",otherPlayer];
    }
    else if (remotePlayerDiff < 0) {
        remoteFlag = -1;
        remoteString = [NSString stringWithFormat:@"%@ guessed over the retail price!",otherPlayer];
    }
    else {
        remoteFlag = 1;
        remoteString = [NSString stringWithFormat:@"%@ guessed $%.0f under the retail price",otherPlayer,remotePlayerDiff];
    }
    
    NSString *result;
    
    if ((localFlag == 0 && remoteFlag == 0) || (localFlag == -1 && remoteFlag == -1) || (localPlayerDiff == remotePlayerDiff)) {
        result = [NSString stringWithFormat:@"Tie!"];
    }
    else {
        
        if ( ((localPlayerDiff < remotePlayerDiff) && (localPlayerDiff >= 0)) || (localPlayerDiff >= 0 && remotePlayerDiff < 0)) {
            
            result = [NSString stringWithFormat:@"You won this product!"];
            
            if (localPlayerDiff == 0) {
                localPlayerScore += 2;
            }
            else {
                localPlayerScore++;
            }
            
            [localPlaerScoreLabel setString:[NSString stringWithFormat:@"Score: %i",localPlayerScore]];
            [self sendLocalPlayerScore];
            
        }
        else {
            result = [NSString stringWithFormat:@"%@ won this product",otherPlayer];
        }
    }
    
    NSString *message = [NSString stringWithFormat:@"%@\n%@\n%@",result,localString,remoteString];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Acutal Price $%@",curr.price] message:message delegate:self cancelButtonTitle:@"Next Product" otherButtonTitles: nil];
    alert.tag = 8888;
    [alert show];
    [alert release];
}


- (void)sendLocalPlayerScore
{
    MessageSendScore message;
    message.message.messageType = kMessageScore;
    message.value = localPlayerScore;
    
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageSendScore)];
    [self sendData:data];
}


- (void)updateRemotePlayerScore:(int)value
{
    remotePlayerScore = value;
    [remotePlaerScoreLabel setString:[NSString stringWithFormat:@"Score: %i",value]];
}


- (void)checkWinner
{
    NSString *winner;
    NSString *title;
    if (localPlayerScore > remotePlayerScore) {
        winner = [NSString stringWithFormat:@"You Win!"];
        title = [NSString stringWithFormat:@"Congratulations"];
    }
    else if (localPlayerScore < remotePlayerScore) {
        winner = [NSString stringWithFormat:@"You Lost to %@!",remoteAlias];
        title = [NSString stringWithFormat:@"Sorry"];
        
    }
    else {
        winner = [NSString stringWithFormat:@"You tied %@",remoteAlias];
        title = [NSString stringWithFormat:@"Tie"];
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:winner delegate:self cancelButtonTitle:@"Quit" otherButtonTitles: nil];
    alert.tag = 9999;
    [alert show];
    [alert release];
}


- (void) loadAndSetNewProductForKey:(NSString*)key
{
    Product *curr = (Product*)[productDictionary objectForKey:key];
    
    if (self.productTitleLabel == nil) {
        productTitleLabel = [CCLabelTTF labelWithString:curr.title fontName:@"Marker Felt" fontSize:12];
        productTitleLabel.position = ccp(240,290);
        productTitleLabel.color = ccc3(158,31,99);
        [self addChild:productTitleLabel];
    }
    else {
        [productTitleLabel setString:curr.title];
    }
    
    if (productDescLabel == nil) {
        productDescLabel = [CCLabelTTF labelWithString:curr.description fontName:@"Marker Felt" fontSize:12];
        productDescLabel.position = ccp(240,90);
        productDescLabel.color = ccc3(158,31,99);
        [self addChild:productDescLabel];
    }
    else {
        [productDescLabel setString:curr.description];
    }
    
    if (productImage == nil) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        productImage = [CCSprite spriteWithFile:curr.image];
        productImage.position = ccp(size.width/2, size.height/2+20);
        
        [self addChild:productImage];
    }
    else {
        CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:curr.image];
        [productImage setTexture: tex];
    }
    
    [localGuessLabel setString:@"---"];
    [remoteGuessLabel setString:@"---"];
    
    localPlayerGuessed = NO;
    remotePlayerGuessed = NO;
}


- (NSDictionary*) populateProductDictionary
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithCapacity:5];
    
    NSString *productsPath = [[NSBundle mainBundle] pathForResource:@"products" ofType:@"plist"];
    NSDictionary *prodDict = [NSDictionary dictionaryWithContentsOfFile:productsPath];
    
    for (int count = 0; count <= 4; count++) {
        
        //int rand = arc4random() % 10;
        
        NSDictionary *currentDict = [prodDict objectForKey:[NSString stringWithFormat:@"%i",count]];
        NSString *title = [currentDict objectForKey:@"title"];
        NSString *price = [currentDict objectForKey:@"price"];
        
        NSString *desc = [currentDict objectForKey:@"description"];
        NSString *imageName = [currentDict objectForKey:@"imageName"];
        
        Product *newProd = [[Product alloc]initWihTitle:title andDesc:desc andImageName:imageName andPrice:price];
        
        [tempDict setObject:newProd  forKey:[NSString stringWithFormat:@"%i",count]];
        
        [newProd release];
    }


    return [NSDictionary dictionaryWithDictionary:tempDict];
    [tempDict release];
    
}


- (void)sendEndGameMessage
{
    localEndGame = YES;
    
    MessageEndGame message;
    message.message.messageType = kMessageEndGame;
    message.value = YES;
    
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageSendScore)];
    [self sendData:data];
    
    [self endMatch];
}


- (void)recieveEndGameMessage:(BOOL)value
{
    remoteEndGame = value;
    [self endMatch];
}


- (void)endMatch 
{
    
    if (!(localEndGame && remoteEndGame)) {return;}
    
    [[[GCHelper sharedInstance]delegate]matchEnded];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 9999) {
        
        [self sendEndGameMessage];
    }
    else if (alertView.tag == 8888) {
        
        if (productCount == 4) {
            [self checkWinner];
        }
        else {
            
            productCount++;
            [self loadAndSetNewProductForKey:[NSString stringWithFormat:@"%i",productCount]];
            
            localPlayerGuessed = NO;
            remotePlayerGuessed = NO;
        }
        
    }
}

@end
