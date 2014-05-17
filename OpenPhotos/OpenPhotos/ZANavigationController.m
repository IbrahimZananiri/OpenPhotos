//
//  ZANavigationController.m
//  OpenPhotos
//
//  Created by Ibrahim on 5/16/14.
//  Copyright (c) 2014 Ibrahim Zananiri. All rights reserved.
//

#import "ZANavigationController.h"

@implementation ZANavigationController

/*
 *  Allow Rotation only for Photo Slideshow Class Type
 */

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [self isViewControllerPhotoSlideshow] ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if ([self isViewControllerPhotoSlideshow]) {
        return UIInterfaceOrientationLandscapeLeft;
    }
    return UIInterfaceOrientationPortrait;
}

- (BOOL) isViewControllerPhotoSlideshow
{
    return NO;
}

@end
