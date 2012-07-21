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


typedef enum {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
} GameState;

typedef enum {
    kEndReasonWin,
    kEndReasonLose,
    kEndReasonDisconnect
} EndReason;

typedef enum {
    kMessageTypeGameBegin,
    kMessageTypeMove,
    kMessageTypeGameOver
} MessageType;

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
} MessageGameBegin;

typedef struct {
    Message message;
} MessageMove;

typedef struct {
    Message message;
    BOOL player1Won;
} MessageGameOver;


@interface GameScreenLayer : CCLayer {
    
    NSString *otherPlayerID;
    GameState gameState;
    
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
- (void) makeGuess:(float)guess;
- (void) showGuessPicker;

@end
