//
//  ZAPhotoCell.m
//  OpenPhotos
//
//  Created by Ibrahim on 5/16/14.
//  Copyright (c) 2014 Ibrahim Zananiri. All rights reserved.
//

#import "ZAPhotoCell.h"
#import "ZAPhoto.h"
#import "ZAPhoto+MWPhoto.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation ZAPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void) setPhoto:(ZAPhoto *)photo
{
    _photo = photo;
    
    // For better experience, use local image while and after uploading
    
    if (photo.image) {
        [self.thumbnailImageView setImage:photo.image];
    } else if (photo.mwPhoto.underlyingImage) {
        [self.thumbnailImageView setImage:photo.mwPhoto.underlyingImage];
    } else if (photo.thumbnailURL) {
        [self.thumbnailImageView setImageWithURL:photo.thumbnailURL placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    } else {
        [self.thumbnailImageView setImage:nil];
    }
    
    self.activityIndicatorView.hidden = !photo.isUploading;
}

-(void) prepareForReuse
{
    [super prepareForReuse];
}

@end
