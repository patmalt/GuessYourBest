//
//  GameScreenLayer.h
//  GuessYourBest
//
//  Created by Patrick Maltagliati on 7/21/12.
//  Copyright (c) 2012 Patrick Maltagliati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "MessageTypes.h"

@interface GameScreenLayer : CCLayer <UIAlertViewDelegate> {
    
    
    int localPlayerScore;
    int remotePlayerScore;
    CCLabelTTF *localPlaerScoreLabel;
    CCLabelTTF *remotePlaerScoreLabel;
    
    CCLabelTTF *localGuessLabel;
    CCLabelTTF *remoteGuessLabel;
    float localPlayerGuess;
    float remotePlayerGuess;
    
    CCSprite *productImage;
    CCLabelTTF *productTitleLabel;
    CCLabelTTF *productDescLabel;
    
    int productCount;
    
    BOOL localPlayerGuessed;
    BOOL remotePlayerGuessed;
    
    NSDictionary *productDictionary;
    NSString *remoteAlias;
    
    BOOL localEndGame;
    BOOL remoteEndGame;
    
    BOOL localWaiting;
    BOOL remoteWaiting;
    
    CCMenuItem *quitMenuItem;
    CCMenuItem *guessMenuItem;
}

@property (assign) CCLabelTTF *localPlaerScoreLabel;
@property (assign) CCLabelTTF *remotePlaerScoreLabel;

@property (assign) CCLabelTTF *localGuessLabel;
@property (assign) CCLabelTTF *remoteGuessLabel;

@property (assign) CCSprite *productImage;
@property (assign) CCLabelTTF *productTitleLabel;
@property (assign) CCLabelTTF *productDescLabel;

@property (assign) NSDictionary *productDictionary;

+ (id) scene;
- (void) makeGuess:(NSString*)guess;
- (void) showGuessPicker;
- (void) changeRemoteGuess:(float)value;
- (void) loadAndSetNewProductForKey:(NSString*)key;
- (NSDictionary*) populateProductDictionary;
- (void)tryToDetermineWinnerOfProduct;
- (void)sendLocalPlayerScore;
- (void)updateRemotePlayerScore:(int)value;
- (void)checkWinner;
- (void)recieveEndGameMessage:(BOOL)value;

- (void)recieveWaitStart:(BOOL)value;
- (void)recieveWaitEnd:(BOOL)value;

@end
