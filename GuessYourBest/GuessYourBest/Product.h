//
//  Product.h
//  GuessYourBest
//
//  Created by Patrick Maltagliati on 7/22/12.
//  Copyright (c) 2012 Patrick Maltagliati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject {
	NSString * title;
	NSString * description;
	NSString * image;
    NSString * price;
}

@property (nonatomic,retain) NSString * title;
@property (nonatomic,retain) NSString * description;
@property (nonatomic,retain) NSString * image;
@property (nonatomic,retain) NSString * price;

- (id)initWihTitle:(NSString*)inTitle andDesc:(NSString*)desc andImageName:(NSString*)imageName andPrice:(NSString*)inputPrice;


@end
