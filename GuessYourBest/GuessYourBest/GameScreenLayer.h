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
#import "Product.h"

@interface GameScreenLayer : CCLayer {
    
    
    int localPlayerScore;
    int remotePlayerScore;
    CCLabelTTF *localPlaerScoreLabel;
    CCLabelTTF *remotePlaerScoreLabel;
    
    CCLabelTTF *localGuessLabel;
    CCLabelTTF *remoteGuessLabel;
    float localPlayerGuess;
    float remotePlayerLabel;
    
    CCSprite *productImage;
    CCLabelTTF *productTitleLabel;
    CCLabelTTF *productDescLabel;
    
    NSDictionary *productDictionary;
    int productCount;
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
- (void) changeRemoteGuess:(NSString*)string;
- (void) loadAndSetNewProductForKey:(NSString*)key;
- (NSDictionary*) populateProductDictionary;

@end
