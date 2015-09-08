//
//  ConnectingOverlay.h
//  AutoImage
//
//  Created by Jason Yonker on 9/7/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ConnectingOverlayWindowContentPosition)
{
    kConnectingOverlayWindowContentPositionCentered,
    kConnectingOverlayWindowContentPositionAboveKeyboard,
};

@interface ConnectingOverlayWindow : UIWindow

@property (nonatomic, assign) ConnectingOverlayWindowContentPosition contentPosition;

- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;
- (void)hideAfterShowingErrorMessage:(NSString *)error;
- (void)hideAfterShowingCheckConnectionError;

@end
