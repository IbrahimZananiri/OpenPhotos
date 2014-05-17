//
//  ZALoginViewController.m
//  OpenPhotos
//
//  Created by Ibrahim on 5/17/14.
//  Copyright (c) 2014 Ibrahim Zananiri. All rights reserved.
//

#import "ZALoginViewController.h"
#import <Accounts/Accounts.h>
#import "ZAAPIManager.h"

@implementation ZALoginViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) setLoginOperationActive:(BOOL)active
{
    self.loginButton.enabled = !active;
    if (active) {
        [self.loginButton setTitle:NSLocalizedString(@"Logging In...", nil) forState:UIControlStateNormal];
    } else {
        [self.loginButton setTitle:NSLocalizedString(@"Login With Facebook", nil) forState:UIControlStateNormal];
    }
}

- (IBAction) loginWithFacebookTapped:(id)sender
{
    [self setLoginOperationActive:YES];
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *fbAccountType = [accountStore
                                    accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [accountStore requestAccessToAccountsWithType:fbAccountType
                                          options:@{
                                                    ACFacebookAppIdKey: kFbAppId,
                                                    ACFacebookPermissionsKey: @[]
                                                    }
                                       completion:^(BOOL granted, NSError *error) {
                                           if (granted) {
                                                NSArray *accounts = [accountStore accountsWithAccountType:fbAccountType];
                                                ACAccount *account = [accounts lastObject];
                                                NSLog(@"Authenticated from Facebook. Username is: %@", account.username);
                                               [[ZAAPIManager sharedManager] setAuth:account.credential.oauthToken];
                                                UINavigationController *photosViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Photos"];
                                               [self presentViewController:photosViewController animated:YES completion:nil];
                                           } else {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   NSLog(@"%@", error);
                                                   NSString *message = error.code == 6 ? @"Please add a Facebook account in device Settings." : @"Please grant OpenPhotos access to Facebook";
                                                   UIAlertView *alert = [[UIAlertView alloc]
                                                                         initWithTitle:NSLocalizedString(@"Facebook Login", nil)
                                                                         message:NSLocalizedString(message, nil)
                                                                         delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil];
                                                   [alert show];
                                               });
                                           }
                                           [self setLoginOperationActive:NO];
                                       }];
    
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
