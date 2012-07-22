//
//  Product.h
//  test
//
//  Created by Ramy Cohen on 7/21/12.
//  Copyright 2012 University of Illinois at Urbana-Champaign. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Product : NSObject {
	NSString * title;
	NSString * description;
	NSString * image;
    NSString * price;
}

@property (assign) NSString * title;
@property (assign) NSString * description;
@property (assign) NSString * image;
@property (assign) NSString * price;

- (id)initWihTitle:(NSString*)title:inTitle andDesc:(NSString*)desc andImageName:(NSString*)imageName andPrice:(NSString*)inputPrice;

@end
