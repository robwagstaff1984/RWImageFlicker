//
//  RWAFHTTPRequestOperationManager.m
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/14/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWAFHTTPRequestOperationManager.h"

@implementation RWAFHTTPRequestOperationManager

+(RWAFHTTPRequestOperationManager*) sharedJSONRequestOperationManager {
    
    static RWAFHTTPRequestOperationManager* _sharedJSONRequestOperationManager;
    if(!_sharedJSONRequestOperationManager) {
        _sharedJSONRequestOperationManager = [self new];
        _sharedJSONRequestOperationManager = [RWAFHTTPRequestOperationManager manager];
    }
    return _sharedJSONRequestOperationManager;
}   

@end


