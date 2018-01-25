//
//  Photo.m
//  Cats
//
//  Created by Jose on 24/1/18.
//  Copyright © 2018 Jose. All rights reserved.
//

#import "Photo.h"

@implementation Photo

-(UIImage *)image
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:_url]];
}

@end
