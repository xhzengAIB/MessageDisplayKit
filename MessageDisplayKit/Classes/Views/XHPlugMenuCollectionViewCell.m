//
//  XHPlugMenuCollectionViewCell.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-30.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPlugMenuCollectionViewCell.h"

@interface XHPlugMenuCollectionViewCell ()

@property (nonatomic, weak) UIImageView *plugIconImageView;
@property (nonatomic, weak) UILabel *plugTitleLabel;

@end

@implementation XHPlugMenuCollectionViewCell

#pragma mark - Propertys

- (void)setPlugItem:(XHPlugItem *)plugItem {
    _plugItem = plugItem;
    
    self.plugIconImageView.image = plugItem.normalIconImage;
    self.plugTitleLabel.text = plugItem.title;
}

#pragma mark - Life cycle

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    if (!_plugIconImageView) {
        UIImageView *plugIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kXHPlugItemIconSize, kXHPlugItemIconSize)];
        [self.contentView addSubview:plugIconImageView];
        self.plugIconImageView = plugIconImageView;
    }
    
    if (!_plugTitleLabel) {
        UILabel *plugTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.plugIconImageView.frame), kXHPlugItemIconSize, KXHPlugItemHeight - kXHPlugItemIconSize)];
        plugTitleLabel.backgroundColor = [UIColor clearColor];
        plugTitleLabel.textColor = [UIColor blackColor];
        plugTitleLabel.font = [UIFont systemFontOfSize:12];
        plugTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:plugTitleLabel];
        
        self.plugTitleLabel = plugTitleLabel;
    }
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
