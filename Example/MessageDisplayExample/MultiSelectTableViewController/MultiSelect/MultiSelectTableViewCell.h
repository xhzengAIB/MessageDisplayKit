//
//  MultiSelectTableViewCell.h
//  MultiSelectTableViewController
//
//  Created by molon on 6/8/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, MultiSelectTableViewSelectState) {
    MultiSelectTableViewSelectStateNoSelected = 0,
    MultiSelectTableViewSelectStateSelected,
    MultiSelectTableViewSelectStateDisabled,
};

@interface MultiSelectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, assign) MultiSelectTableViewSelectState selectState;

+ (instancetype)instanceFromNib;

@end
