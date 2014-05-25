//
//  XHLocationServiceTableViewCell.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-25.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHLocationServiceTableViewCell.h"

@interface XHLocationServiceTableViewCell ()

@property (nonatomic, strong) UIImageView *avatorImageView;

@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *userSexImageView;

@property (nonatomic, strong) UILabel *distanseLabel;
@property (nonatomic, strong) UIImageView *albumImageView;

@property (nonatomic, strong) UILabel *introductionLabel;

@end

@implementation XHLocationServiceTableViewCell

- (void)configureCellWithItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    self.userNameLabel.text = item;
    self.distanseLabel.text = @"1000米以内";
}

#pragma mark - Propertys

- (UIImageView *)avatorImageView {
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kXHNearAvatorSpacing, kXHNearAvatorSpacing, kXHNearAvatorSize, kXHNearAvatorSize)];
        _avatorImageView.image = [UIImage imageNamed:@"avator"];
    }
    return _avatorImageView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatorImageView.frame) + kXHNearAvatorSpacing, kXHNearAvatorSpacing, 100, 30)];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _userNameLabel;
}

- (UILabel *)distanseLabel {
    if (!_distanseLabel) {
        _distanseLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userNameLabel.frame), CGRectGetMaxY(self.userNameLabel.frame), 100, 20)];
        _distanseLabel.font = [UIFont systemFontOfSize:12];
        _distanseLabel.backgroundColor = [UIColor clearColor];
        _distanseLabel.textColor = [UIColor grayColor];
    }
    return _distanseLabel;
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.avatorImageView];
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.distanseLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
