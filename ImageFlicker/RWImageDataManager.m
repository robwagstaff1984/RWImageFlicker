//
//  RWImageDataManager.m
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/14/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWImageDataManager.h"

@implementation RWImageDataManager

+(RWImageDataManager*) sharedImageDataManager {
    
    static RWImageDataManager* _sharedImageDataManager;
    if(!_sharedImageDataManager) {
        _sharedImageDataManager = [self new];
    }
    return _sharedImageDataManager;
}

@end
