//
//  ZAPhotoCell.h
//  OpenPhotos
//
//  Created by Ibrahim on 5/16/14.
//  Copyright (c) 2014 Ibrahim Zananiri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZAPhoto;

@interface ZAPhotoCell : UICollectionViewCell

@property (nonatomic, strong) ZAPhoto *photo;

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end
