//
//  ZAPhotoCollectionViewController.h
//  OpenPhotos
//
//  Created by Ibrahim on 5/16/14.
//  Copyright (c) 2014 Ibrahim Zananiri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface ZAPhotoCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, MWPhotoBrowserDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *photos;

@end
