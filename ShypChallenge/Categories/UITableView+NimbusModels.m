//
//  UITableView+Nib.m
//  ShypChallenge
//
//  Created by Jason Yonker on 9/7/15.
//  Copyright (c) 2015 OMG Labs Inc. All rights reserved.
//

#import "UITableView+NimbusModels.h"

@implementation UITableView (NimbusModels)

- (UITableViewCell *)cellWithNib:(UINib *)cellNib
                       indexPath:(NSIndexPath *)indexPath
                          object:(id)object {
    UITableViewCell* cell = nil;
    
    NSString* identifier = NSStringFromClass([object class]);
    [self registerNib:cellNib forCellReuseIdentifier:identifier];
    
    cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // Allow the cell to configure itself with the object's information.
    if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:)]) {
        [(id<NICell>)cell shouldUpdateCellWithObject:object];
    }
    
    return cell;
}

- (UITableViewCell *)cellWithClass:(Class)cellClass
                            object:(id)object {
    UITableViewCell* cell = nil;
    
    NSString* identifier = NSStringFromClass(cellClass);
    
    if ([cellClass respondsToSelector:@selector(shouldAppendObjectClassToReuseIdentifier)]
        && [cellClass shouldAppendObjectClassToReuseIdentifier]) {
        identifier = [identifier stringByAppendingFormat:@".%@", NSStringFromClass([object class])];
    }
    
    cell = [self dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        UITableViewCellStyle style = UITableViewCellStyleDefault;
        if ([object respondsToSelector:@selector(cellStyle)]) {
            style = [object cellStyle];
        }
        cell = [[cellClass alloc] initWithStyle:style reuseIdentifier:identifier];
    }
    
    // Allow the cell to configure itself with the object's information.
    if ([cell respondsToSelector:@selector(shouldUpdateCellWithObject:)]) {
        [(id<NICell>)cell shouldUpdateCellWithObject:object];
    }
    
    return cell;
}

@end
