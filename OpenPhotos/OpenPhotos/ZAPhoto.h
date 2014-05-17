//
//  ZAPhoto.h
//  OpenPhotos
//
//  Created by Ibrahim on 5/16/14.
//  Copyright (c) 2014 Ibrahim Zananiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZAPhoto : NSObject

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, copy) NSString *userDescription;
@property (nonatomic, copy) NSString *serverID;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isUploading;

@end
