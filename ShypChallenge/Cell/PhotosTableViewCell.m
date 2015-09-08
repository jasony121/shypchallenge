//
//  PhotosTableViewCell.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/6/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "PhotosTableViewCell.h"

#import "Venue+Util.h"

#import "UIImageView+AFNetworking.h"

@implementation PhotosTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)shouldUpdateCellWithObject:(Venue *)venue {
    [self.photoImageViews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        imageView.image = nil;
        if (idx < venue.venuePhotos.count) {
            [imageView setImageWithURL:[venue.venuePhotos[idx] thumbnailURL]];
        } else {
            [imageView cancelImageRequestOperation];
        }
    }];
    
    return YES;
}

@end
