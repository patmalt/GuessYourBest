//
//  Product.m
//  GuessYourBest
//
//  Created by Patrick Maltagliati on 7/22/12.
//  Copyright (c) 2012 Patrick Maltagliati. All rights reserved.
//

#import "Product.h"

@implementation Product
@synthesize title, description, image, price;

- (id)initWihTitle:(NSString*)inTitle andDesc:(NSString*)desc andImageName:(NSString*)imageName andPrice:(NSString*)inputPrice
{
    self = [super init];
    if (self) {
        self.title = inTitle;
        self.description = desc;
        self.image = imageName;
        self.price = inputPrice;
    }
    return self;
}

- (void)dealloc
{
    [title release];
    [description release];
    [image release];
    [price release];
    [super dealloc];
}


@end
