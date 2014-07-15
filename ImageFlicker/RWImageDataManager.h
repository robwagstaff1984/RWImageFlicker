//
//  RWImageDataManager.h
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/14/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWImageDataManager : NSObject

@property (nonatomic, strong) NSOrderedSet* images;

+(RWImageDataManager*) sharedImageDataManager;

@end
