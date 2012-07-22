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

@interface GameScreenLayer : CCLayer {
    
    
    int localPlayerScore;
    int remotePlayerScore;
    CCLabelTTF *localPlaerScoreLabel;
    CCLabelTTF *remotePlaerScoreLabel;
    
    CCLabelTTF *localGuessLabel;
    CCLabelTTF *remoteGuessLabel;
    float localPlayerGuess;
    float remotePlayerLabel;
}

@property (assign) CCLabelTTF *localPlaerScoreLabel;
@property (assign) CCLabelTTF *remotePlaerScoreLabel;

@property (assign) CCLabelTTF *localGuessLabel;
@property (assign) CCLabelTTF *remoteGuessLabel;


+ (id) scene;
- (void) makeGuess:(NSString*)guess;
- (void) showGuessPicker;
- (void) showAlert:(NSString*)string;

@end
