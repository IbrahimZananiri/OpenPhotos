//
//  ZAAPIManager.m
//  OpenPhotos
//
//  Created by Ibrahim on 5/17/14.
//  Copyright (c) 2014 Ibrahim Zananiri. All rights reserved.
//

#import "ZAAPIManager.h"
#import "ZAAPIClient.h"
#import "ZAPhoto.h"

@implementation ZAAPIManager

/*
 * Manager Singleton
 */
+ (instancetype) sharedManager
{
    static ZAAPIManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[ZAAPIManager alloc] init];
    });
    return _sharedManager;
}

/*
 * Login User only with token and invoke block with auth success boolean or error
 */
- (NSURLSessionTask *) login:(NSString *)token withBlock:(void (^)(BOOL isAuthenticated, NSError *error))block
{
    [[ZAAPIClient sharedClient] setAuth: token];
    
    return [[ZAAPIClient sharedClient] POST:@"/users" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (block) block(YES, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@", error);
        [[ZAAPIClient sharedClient] setAuth: nil];
        if (block) block(NO, error);
        
    }];
}

/*
 * Upload a Photo and invoke block with photo or error
 */
- (NSURLSessionTask *) uploadPhoto:(ZAPhoto *)photo withBlock:(void (^)(ZAPhoto *photo, NSError *error))block
{
    NSLog(@"Uploading Photo: %@", photo);
    NSData *imageData = UIImageJPEGRepresentation(photo.image, 0.0f);
    
    NSDictionary *parameters = [self serializePhoto:photo];
    
    return [[ZAAPIClient sharedClient] POST:@"/users/me/photos" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        ZAPhoto *photo = [self deserializePhotoFromDictionary:responseObject];
        NSLog(@"Upload Successful for Photo with Server ID: %@", photo.serverID);
        if (block) block(photo, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@", error);
        if (block) block(nil, error);
        
    }];
}


- (NSURLSessionTask *) getUserPhotosWithBlock:(void (^)(NSArray *photos, NSError *error))block
{
    return [[ZAAPIClient sharedClient] GET:@"/users/me/photos" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *photos = [NSMutableArray array];
        for (NSDictionary *photoDictionary in responseObject) {
            ZAPhoto *photo = [self deserializePhotoFromDictionary:photoDictionary];
            [photos addObject:photo];
        }
        if (block) block(photos, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        if (block) block(nil, error);
    }];
}


- (NSDictionary *) serializePhoto:(ZAPhoto *)photo
{
    if (photo.image == nil) return nil;
//    NSData *imageData = UIImageJPEGRepresentation(photo.image, 0.74);
//    NSString *imageBase64 = [imageData base64EncodedStringWithOptions:0];
    return @{
      //@"image": imageBase64,
      @"userDescription": photo.userDescription
    };
}

- (ZAPhoto *) deserializePhotoFromDictionary:(NSDictionary *)dictionary
{
    ZAPhoto *photo = [[ZAPhoto alloc] init];
    photo.serverID = [dictionary objectForKey:@"_id"];
    photo.imageURL = [NSURL URLWithString: [dictionary objectForKey:@"imageURL"]];
    photo.thumbnailURL = [NSURL URLWithString: [dictionary objectForKey:@"thumbnailURL"]];
    photo.userDescription = [dictionary objectForKey:@"userDescription"];
    return photo;
}


- (void) setAuth:(NSString *)auth
{
    [[ZAAPIClient sharedClient] setAuth:auth];
}

@end
