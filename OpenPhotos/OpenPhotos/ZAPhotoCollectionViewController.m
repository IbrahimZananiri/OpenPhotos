//
//  ZAPhotoCollectionViewController.m
//  OpenPhotos
//
//  Created by Ibrahim on 5/16/14.
//  Copyright (c) 2014 Ibrahim Zananiri. All rights reserved.
//

#import "ZAPhotoCollectionViewController.h"
#import "ZAPhoto.h"
#import "ZAPhoto+MWPhoto.h"
#import "ZAPhotoCell.h"
#import "MWPhotoBrowser.h"
#import "ZAAPIManager.h"

@interface ZAPhotoCollectionViewController ()

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@end

@implementation ZAPhotoCollectionViewController

static NSInteger descriptionViewTag = 99;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadPhotos];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) setupRightItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(addPhotoTapped:)];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *photoCellIdentifier = @"PhotoCell";
    ZAPhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellIdentifier forIndexPath:indexPath];
    photoCell.photo = [self.photos objectAtIndex:indexPath.item];
    return photoCell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     * Get a new photo browser instance
     */
    self.photoBrowser = [self photoBrowserWithPhotoIndex:indexPath.item];
    /*
     * Show photo browser view controller
     */
//    [self.navigationController pushViewController:photoBrowser animated:YES];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    ZAPhoto *photo = [self.photos objectAtIndex:index];
    return photo.mwPhoto;
}

#pragma mark -

- (MWPhotoBrowser *) photoBrowserWithPhotoIndex:(NSUInteger)index
{
    /*
     * Allocate and initialize new MWPhotoBrowser as this view controller must not be reused.
     */
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    photoBrowser.displayActionButton = NO;
    photoBrowser.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    photoBrowser.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareCurrentPhoto:)];
    /*
     * Set Photo Index
     */
    [photoBrowser setCurrentPhotoIndex:index];
    
    return photoBrowser;
}


#pragma mark - Photo Data

- (void) reloadPhotos
{
    self.title = NSLocalizedString(@"Loading...", nil);
    [[ZAAPIManager sharedManager] getUserPhotosWithBlock:^(NSArray *photos, NSError *error) {
        if (!error) {
            self.photos = [NSMutableArray arrayWithArray:photos];
            [self setupRightItem];
            [self.collectionView reloadData];
        }
        self.title = NSLocalizedString(@"OpenPhotos", nil);
    }];
}

#pragma mark - Add Photo

- (void) addPhotoTapped:(id)sender
{
    NSLog(@"Add Photo Button Tapped");
    [self showPhotoActionSheet];
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            [self takePhoto];
        } else if (buttonIndex == 1) {
            [self choosePhoto];
        }
    }
}

- (void) showPhotoActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Take with camera", nil), NSLocalizedString(@"Choose exisiting...", nil), nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

- (void) choosePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:^{}];
    } else {
        NSLog(@"Media Type Not Available");
    }
}

- (void) takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        /*
         * UIImagePickerController bug sometimes warns when loading view while in portrait mode
         * http://stackoverflow.com/questions/20849768/best-way-to-operate-a-uiimagepickercontroller-from-a-custom-uitableviewcell
         */
        [self presentViewController:picker animated:YES completion:^{
            NSLog(@"Image Picker Animation completed");
        }];
    } else {
        NSLog(@"Media Type Not Available");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:^{
        self.selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self showDescriptionView];
    }];
}

- (void) showDescriptionView
{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"Photo Description",nil) message:NSLocalizedString(@"Enter a photo description?\nIt's optional.",nil) delegate:self cancelButtonTitle:nil otherButtonTitles: NSLocalizedString(@"Upload",nil), nil];
    alert.tag = descriptionViewTag;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == descriptionViewTag) {
        NSString *text = [alertView textFieldAtIndex:0].text;
//        NSString *userDescription = text.length > 0 ? text : nil;
        [self uploadNewPhotoWithUserDescription:text];
    }
}

- (void) uploadNewPhotoWithUserDescription: (NSString *)userDescription
{
    ZAPhoto *newPhoto = [[ZAPhoto alloc] init];
    newPhoto.image = [self.selectedImage copy];
    newPhoto.isUploading = YES;
    newPhoto.userDescription = userDescription;
    [self.photos addObject:newPhoto];
    [self.collectionView reloadData];
    self.selectedImage = nil;
    
    // Scroll to bottom in case there are many images and a scrolling view
    if ([self.collectionView numberOfSections] > 0 && [self.collectionView numberOfItemsInSection:0] > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:([self.collectionView numberOfItemsInSection:0]-1) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }

    
    [[ZAAPIManager sharedManager] uploadPhoto:newPhoto withBlock:^(ZAPhoto *photo, NSError *error) {
        if (photo) {
            [self.photos removeObject:newPhoto];
            [self.photos addObject:photo];
        } else if (error) {
            newPhoto.isUploading = NO;
        }
        [self.collectionView reloadData];
    }];
}

#pragma mark - Share Photo

- (void) shareCurrentPhoto:(id)sender
{
    if (!self.photoBrowser) return;
    ZAPhoto *currentPhoto = [self.photos objectAtIndex: self.photoBrowser.currentIndex];
    NSMutableArray *items = [NSMutableArray array];
    UIImage *image = currentPhoto.mwPhoto.underlyingImage;
    if (image) {
        [items addObject:image];
    } else {
        //return;
    }
    if (currentPhoto.userDescription) {
        [items addObject:currentPhoto.userDescription];
    }
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [self.photoBrowser presentViewController:activity animated:YES completion:nil];
}

@end
