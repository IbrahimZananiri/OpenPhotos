//
//  ZAAPIClient.m
//  OpenPhotos
//
//  Created by Ibrahim on 5/17/14.
//  Copyright (c) 2014 Ibrahim Zananiri. All rights reserved.
//

#import "ZAAPIClient.h"
#import "AFURLRequestSerialization.h"

@implementation ZAAPIClient

+ (instancetype) sharedClient
{
    static ZAAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ZAAPIClient alloc] initWithBaseURL: [NSURL URLWithString:kAPIBase]];
        
        // JSON Request Serializer
        _sharedClient.requestSerializer = [[AFJSONRequestSerializer alloc] init];
        
        // HTTP Headers
        [_sharedClient.requestSerializer setValue:kAPIClientID forHTTPHeaderField:@"ClientID"];
    });
    
    return _sharedClient;
}

- (void) setAuth:(NSString *)auth
{
    [[ZAAPIClient sharedClient].requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
}

@end
