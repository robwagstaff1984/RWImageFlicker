//
//  RWAFHTTPSessionManager.h
//  ImageFlicker
//
//  Created by Robert Wagstaff on 7/14/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface RWAFHTTPSessionManager : AFHTTPSessionManager

+(RWAFHTTPSessionManager*) sharedSessionManager;

-(void) searchForImageWith:(NSString*)searchTerm offset:(int)offset withSuccess:(void(^)(NSArray*))successBlock;

@end
