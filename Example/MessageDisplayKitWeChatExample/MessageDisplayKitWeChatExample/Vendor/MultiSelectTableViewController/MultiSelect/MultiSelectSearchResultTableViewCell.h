//
//  MultiSelectSearchResultTableViewCell.h
//  MultiSelectTableViewController
//
//  Created by molon on 6/8/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiSelectSearchResultTableViewCell : UITableViewCell

+ (instancetype)instanceFromNib;

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *addedTipsLabel;

@end
