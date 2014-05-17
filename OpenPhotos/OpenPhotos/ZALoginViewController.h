//
//  ZALoginViewController.h
//  OpenPhotos
//
//  Created by Ibrahim on 5/17/14.
//  Copyright (c) 2014 Ibrahim Zananiri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZALoginViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

- (IBAction) loginWithFacebookTapped:(id)sender;

@end
