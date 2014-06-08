//
//  MultiSelectSearchResultTableViewCell.m
//  MultiSelectTableViewController
//
//  Created by molon on 6/8/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "MultiSelectSearchResultTableViewCell.h"

@implementation MultiSelectSearchResultTableViewCell

+ (instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle]loadNibNamed:@"MultiSelectSearchResultTableViewCell" owner:nil options:nil]lastObject];
}

- (void)awakeFromNib
{
    // Initialization code
    [self reset];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self reset];
}

- (void)reset
{
    self.contentLabel.textColor = [UIColor blackColor];
    self.cellImageView.image = nil;
    self.contentLabel.text = @" ";
    self.addedTipsLabel.hidden = YES;
}

@end
