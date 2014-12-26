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
    self.distanseLabel.text = @"10米以内";
    if (indexPath.row % 2) {
        self.userNameLabel.text = @"杨仁捷";
        self.introductionLabel.text = @"杨仁捷是UI/UE设计师，也是我的好拍档，有着编程功底，绝对是一个好设计师，UI设计可以帮程序员节省一大堆代码，这才是真正的设计师";
    } else {
        self.userNameLabel.text = @"吴盛潮";
        self.introductionLabel.text = @"吴盛潮是iOS开发者，也是我的好伙伴，iOS大神，找大神，找大神，一直会以技术支持的角色，所以你们不比害怕问题解决不了！";
    }
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
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatorImageView.frame) + kXHNearAvatorSpacing, kXHNearAvatorSpacing, 55, 30)];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _userNameLabel;
}
- (UIImageView *)userSexImageView {
    if (!_userSexImageView) {
        _userSexImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Contact_Male"]];
        CGRect userSexImageViewFrame = _userSexImageView.frame;
        userSexImageViewFrame.origin.x = CGRectGetMaxX(self.userNameLabel.frame);
        userSexImageViewFrame.origin.y = CGRectGetMidY(self.userNameLabel.frame) - CGRectGetHeight(userSexImageViewFrame) / 2.0;
        _userSexImageView.frame = userSexImageViewFrame;
    }
    return _userSexImageView;
}

- (UILabel *)distanseLabel {
    if (!_distanseLabel) {
        _distanseLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userNameLabel.frame), CGRectGetMaxY(self.userNameLabel.frame), 50, 15)];
        _distanseLabel.font = [UIFont systemFontOfSize:12];
        _distanseLabel.backgroundColor = [UIColor clearColor];
        _distanseLabel.textColor = [UIColor grayColor];
    }
    return _distanseLabel;
}
- (UIImageView *)albumImageView {
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AlbumFlagMark"]];
        CGRect albumImageViewFrame = _albumImageView.frame;
        albumImageViewFrame.origin.x = CGRectGetMaxX(self.distanseLabel.frame);
        albumImageViewFrame.origin.y = CGRectGetMinY(self.distanseLabel.frame);
        _albumImageView.frame = albumImageViewFrame;
    }
    return _albumImageView;
}

- (UILabel *)introductionLabel {
    if (!_introductionLabel) {
        _introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) - kXHNearAvatorSpacing - 160, kXHNearAvatorSpacing, 160, kXHNearAvatorSize)];
        _introductionLabel.font = [UIFont systemFontOfSize:10];
        _introductionLabel.backgroundColor = [UIColor clearColor];
        _introductionLabel.textColor = [UIColor colorWithRed:0.097 green:0.633 blue:1.000 alpha:1.000];
        _introductionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _introductionLabel.numberOfLines = 0;
    }
    return _introductionLabel;
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.avatorImageView];
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.userSexImageView];
        [self.contentView addSubview:self.distanseLabel];
        [self.contentView addSubview:self.albumImageView];
        [self.contentView addSubview:self.introductionLabel];
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
