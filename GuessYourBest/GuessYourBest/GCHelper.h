//
//  GCHelper.h
//  GuessYourBest
//
//  Created by Patrick Maltagliati on 7/21/12.
//  Copyright (c) 2012 Patrick Maltagliati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@protocol GCHelperDelegate 
    - (void)matchStarted;
    - (void)matchEnded;
    - (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
@end

@interface GCHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate> {
    
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    
    UIViewController *presentingViewController;
    GKMatch *match;
    BOOL matchStarted;
    id <GCHelperDelegate> delegate;
    
    NSMutableDictionary *playersDict;
    NSString *otherPlayerID;
    
    NSString *resultString;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (assign) BOOL userAuthenticated;

@property (retain) UIViewController *presentingViewController;
@property (retain) GKMatch *match;
@property (assign) id <GCHelperDelegate> delegate;

@property (assign) NSMutableDictionary *playersDict;
@property (assign) NSString *otherPlayerID;

@property (assign) NSString *resultString;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GCHelperDelegate>)theDelegate;

@end
