//
//  UITableView+Nib.h
//  ShypChallenge
//
//  Created by Jason Yonker on 9/7/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NimbusModels.h"

// Manually create cells from nib or class in the same way that NICellFactory does
@interface UITableView (NimbusModels)

- (UITableViewCell *)cellWithClass:(Class)cellClass
                            object:(id)object;

- (UITableViewCell *)cellWithNib:(UINib *)cellNib
                       indexPath:(NSIndexPath *)indexPath
                          object:(id)object;

@end
