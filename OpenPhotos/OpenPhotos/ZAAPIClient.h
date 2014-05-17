//
//  ZAAPIClient.h
//  OpenPhotos
//
//  Created by Ibrahim on 5/17/14.
//  Copyright (c) 2014 Ibrahim Zananiri. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface ZAAPIClient : AFHTTPSessionManager

+ (instancetype) sharedClient;
- (void) setAuth:(NSString *)auth;

@end
