//
//  AppDelegate.h
//  GuessYourBest
//
//  Created by Patrick Maltagliati on 7/21/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "GameScreenLayer.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate, UITextFieldDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
    UITextField *guessEntryField;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

- (void)showMakeGuess;

@end
