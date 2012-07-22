//
//  MessageTypes.h
//  GuessYourBest
//
//  Created by Patrick Maltagliati on 7/21/12.
//  Copyright (c) 2012 Patrick Maltagliati. All rights reserved.
//


typedef enum {
    kMessageRemoteTyping,
    kMessageSendGuess
} MessageType;

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
    float number;
} MessageSendScore;

typedef struct {
    Message message;
    BOOL typing;
} MessageRemoteTyping;