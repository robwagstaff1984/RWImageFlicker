//
//  RWAFHTTPRequestOperationManager.h
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/14/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface RWAFHTTPRequestOperationManager : AFHTTPRequestOperationManager

+(RWAFHTTPRequestOperationManager*) sharedJSONRequestOperationManager;

@end
