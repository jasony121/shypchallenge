//
//  FoursquareAuthManager.h
//  ShypChallenge
//
//  Created by Jason Yonker on 9/7/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoursquareAuthManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, assign, readonly) BOOL authenticated;
@property (nonatomic, assign, readonly) NSString *authToken;

- (void)showSignInDialog;
- (void)handleCallbackURL:(NSURL *)url;
- (void)signOut;

@end
