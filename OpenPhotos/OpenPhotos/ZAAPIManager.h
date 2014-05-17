//
//  ZAAPIManager.h
//  OpenPhotos
//
//  Created by Ibrahim on 5/17/14.
//  Copyright (c) 2014 Ibrahim Zananiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZAPhoto;

@interface ZAAPIManager : NSObject

+ (instancetype) sharedManager;

- (NSURLSessionTask *) login:(NSString *)token withBlock:(void (^)(BOOL isAuthenticated, NSError *error))block;
- (NSURLSessionTask *) uploadPhoto:(ZAPhoto *)photo withBlock:(void (^)(ZAPhoto *photo, NSError *error))block;
- (NSURLSessionTask *) getUserPhotosWithBlock:(void (^)(NSArray *photos, NSError *error))block;

- (void) setAuth:(NSString *)auth;

@end
