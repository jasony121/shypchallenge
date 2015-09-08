//
//  ConnectingOverlay.m
//  AutoImage
//
//  Created by Jason Yonker on 9/7/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "ConnectingOverlayWindow.h"
#import "UIView+Visibility.h"

@implementation ConnectingOverlayWindow {
    UIActivityIndicatorView *_activityIndicatorView;
    UILabel *_errorMessage;
    UILabel *_connectingLabel;
}

- (id)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        UIView * contentView = self;
        if (NSClassFromString(@"UIVisualEffectView")) {
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            visualEffectView.frame = self.bounds;
            [self addSubview:visualEffectView];
            visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            visualEffectView.alpha = 0.98;
            contentView = visualEffectView.contentView;
        } else {
            self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        }
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [contentView addSubview:_activityIndicatorView];
        _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        
        _errorMessage = [[UILabel alloc] init];
        [contentView addSubview:_errorMessage];
        //_errorMessage.textColor = [UIColor whiteColor];
        _errorMessage.alpha = 0;
        _errorMessage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _errorMessage.textAlignment = NSTextAlignmentCenter;
        _errorMessage.numberOfLines = 0;
        
        _connectingLabel = [[UILabel alloc] init];
        [contentView addSubview:_connectingLabel];
        _connectingLabel.text = @"Connecting";
        self.accessibilityLabel = @"Connecting";
        //_connectingLabel.textColor = [UIColor whiteColor];
        _connectingLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _connectingLabel.textAlignment = NSTextAlignmentCenter;
        _connectingLabel.font = [UIFont boldSystemFontOfSize:14];
        
        [self setContentPosition:kConnectingOverlayWindowContentPositionCentered];

        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.windowLevel = UIWindowLevelStatusBar;
        
        self.alpha = 0;
    }
    return self;
}

- (void)setContentPosition:(ConnectingOverlayWindowContentPosition)contentPosition
{
    _contentPosition = contentPosition;
    
    _activityIndicatorView.center = self.center;
    _connectingLabel.frame = CGRectMake(10, self.center.y + 30, self.bounds.size.width - 20, 20);
    _errorMessage.frame = CGRectMake(0, 0, self.bounds.size.width - 20, 88);
    _errorMessage.center = self.center;
    
    if (contentPosition == kConnectingOverlayWindowContentPositionAboveKeyboard) {
        CGFloat offset = -self.bounds.size.height / 5;
        _activityIndicatorView.frame = CGRectOffset(_activityIndicatorView.frame, 0, offset);
        _connectingLabel.frame = CGRectOffset(_connectingLabel.frame, 0, offset);
        _errorMessage.frame = CGRectOffset(_errorMessage.frame, 0, offset);
    }
}

- (void)showAnimated:(BOOL)animated
{
    [self makeKeyAndVisible];
    
    void (^animations)() = ^() {
        self.alpha = 1.0;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:animations];
    } else {
        animations();
    }
    
    [_activityIndicatorView startAnimating];
}

- (void)hide
{
    [self hideAnimated:YES];
}

- (void)hideAnimated:(BOOL)animated
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideAnimated:) object:nil];
    void (^animations)() = ^() {
        self.alpha = 0;
    };
    void (^completion)(BOOL) = ^(BOOL finished) {
        [self resignKeyWindow];
        [_activityIndicatorView stopAnimating];
    };
    if (animated) {
        [UIView animateWithDuration:0.25 animations:animations completion:completion];
    } else {
        animations();
        completion(YES);
    }
}

- (void)hideAfterShowingErrorMessage:(NSString *)error
{
    self.accessibilityLabel = error;
    [_activityIndicatorView setInvisible:YES animated:YES];
    [_connectingLabel setInvisible:YES animated:YES];
    [_errorMessage setInvisible:NO animated:YES];
    _errorMessage.text = error;
    [self performSelector:@selector(hide) withObject:nil afterDelay:3];
}

- (void)hideAfterShowingCheckConnectionError
{
    [self hideAfterShowingErrorMessage:@"Error. Check your connection and try again."];
}

@end
