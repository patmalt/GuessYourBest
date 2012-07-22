//
//  Product.m
//  test
//
//  Created by Ramy Cohen on 7/21/12.
//  Copyright 2012 University of Illinois at Urbana-Champaign. All rights reserved.
//

#import "Product.h"


@implementation Product
@synthesize title, description, image, price;

- (id)initWihTitle:(NSString*)title:inTitle andDesc:(NSString*)desc andImageName:(NSString*)imageName andPrice:(NSString*)inputPrice
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
