//
//  UIView+Visibility.m
//  AutoImage
//
//  Created by Jason Yonker on 5/1/14.
//  Copyright (c) 2014 Jason Yonker. All rights reserved.
//

#import "UIView+Visibility.h"

@implementation UIView (Visibility)

- (void)setInvisible:(BOOL)invisible animated:(BOOL)animated
{
    void (^animations)() = ^() {
        self.alpha = invisible ? 0 : 1.0;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:animations];
    } else {
        animations();
    }
}

@end
