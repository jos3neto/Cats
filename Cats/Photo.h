//
//  Photo.h
//  Cats
//
//  Created by Jose on 24/1/18.
//  Copyright © 2018 Jose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject

@property (nonatomic) NSURL* url;
-(UIImage *)image;

@end
