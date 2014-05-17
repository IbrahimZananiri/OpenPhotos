//
//  ZAPhoto+MWPhoto.m
//  OpenPhotos
//
//  Created by Ibrahim on 5/16/14.
//  Copyright (c) 2014 Ibrahim Zananiri. All rights reserved.
//

#import "ZAPhoto+MWPhoto.h"
#import <objc/runtime.h>

/*
 *  With this category, add -mwPhoto to ZAPhoto instances, providing separation and caching
 */

static void *cachedMwPhotoKey;

@implementation ZAPhoto (MWPhoto)

- (MWPhoto *) mwPhoto
{
    MWPhoto *cachedMwPhoto = objc_getAssociatedObject(self, &cachedMwPhotoKey);
    if (!cachedMwPhoto) {
        if (self.image) {
            cachedMwPhoto = [MWPhoto photoWithImage:self.image];
        } else if (self.imageURL) {
            cachedMwPhoto = [MWPhoto photoWithURL:self.imageURL];
        }
        cachedMwPhoto.caption = self.userDescription;
        objc_setAssociatedObject(self, &cachedMwPhotoKey, cachedMwPhoto, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cachedMwPhoto;
}

@end
