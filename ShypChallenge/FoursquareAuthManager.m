//
//  FoursquareAuthManager.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/7/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "FoursquareAuthManager.h"

#import "FSOAuth.h"

#import <UIKit/UIKit.h>

static NSString * const kClientID = @"PAOUBVQIP1ZCN1Y2W30CS10HRB43FGEI2CFUP0O3AZBBZD4Y";
static NSString * const kClientSecret = @"JESSJXKCHLDMSR2UTDHNGL03OBBWHTHHDG4GRBNMZQGB5A3Z";
static NSString * const kCallbackURL = @"shypchallenge://fsoauth";

static NSString * const kUserDefaultsAuthKey = @"kUserDefaultsAuthKey";

@interface FoursquareAuthManager () <UIAlertViewDelegate>

@end

@implementation FoursquareAuthManager

+ (instancetype)sharedManager
{
    static FoursquareAuthManager *instance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[self.class alloc] init];
    });
    return instance;
}

- (void)showSignInDialog {
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"You must sign in to Foursquare to perform this action"
                               delegate:self cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Signin", nil] show];
}

- (void)handleCallbackURL:(NSURL *)url {
    FSOAuthErrorCode errorCode;
    NSString *accessCode = [FSOAuth accessCodeForFSOAuthURL:url error:&errorCode];
    if (errorCode == FSOAuthErrorNone) {
        [FSOAuth requestAccessTokenForCode:accessCode clientId:kClientID callbackURIString:kCallbackURL clientSecret:kClientSecret completionBlock:^(NSString *authToken, BOOL requestCompleted, FSOAuthErrorCode errorCode) {
            if (requestCompleted && errorCode == FSOAuthErrorNone) {
                [[NSUserDefaults standardUserDefaults] setValue:authToken forKey:kUserDefaultsAuthKey];
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"Successfully signed in to Foursquare"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            } else {
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"Failed to sign in to Foursquare. Please try again."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                NSLog(@"FSOAuth failed to get access token: %lu", (unsigned long)errorCode);
            }
        }];
    } else {
        NSLog(@"FSOAuth failed to get access code from URL: %@ %lu", url, (unsigned long)errorCode);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        FSOAuthStatusCode status = [FSOAuth authorizeUserUsingClientId:kClientID callbackURIString:kCallbackURL];
        /*if (FSOAuthStatusErrorFoursquareNotInstalled == status || FSOAuthStatusErrorFoursquareOAuthNotSupported == status) {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"Please install the latest version of the Foursquare app from the app store to enable signin"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }*/
    }
}

- (void)signOut {
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kUserDefaultsAuthKey];
}

- (BOOL)authenticated {
    return self.authToken != nil;
}

- (NSString *)authToken {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kUserDefaultsAuthKey];
}

@end
