//
//  MessageTypes.h
//  GuessYourBest
//
//  Created by Patrick Maltagliati on 7/21/12.
//  Copyright (c) 2012 Patrick Maltagliati. All rights reserved.
//


typedef enum {
    kMessageRemoteTyping,
    kMessageSendGuess,
    kMessageScore,
    kMessageEndGame,
    kMessageWaitStart,
    kMessageWaitEnd
} MessageType;

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
    float number;
} MessageSendGuess;

typedef struct {
    Message message;
    BOOL typing;
} MessageRemoteTyping;

typedef struct {
    Message message;
    int value;
} MessageSendScore;

typedef struct {
    Message message;
    BOOL value;
} MessageEndGame;

typedef struct {
    Message message;
    BOOL value;
} MessageWaitStart;

typedef struct {
    Message message;
    BOOL value;
} MessageWaitEnd;