//
//  XHNewsTemplateTableViewCell.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-29.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHNewsTemplateTableViewCell.h"

@implementation XHNewsTemplateTableViewCell

#pragma mark - Properrtys

- (XHNewsTemplateContainerView *)newsTemplateContainerView {
    if (!_newsTemplateContainerView) {
        _newsTemplateContainerView = [[XHNewsTemplateContainerView alloc] initWithFrame:CGRectMake(kXHNewsTemplateContainerViewSpacing, kXHNewsTemplateContainerViewSpacing, CGRectGetWidth([[UIScreen mainScreen] bounds]) - kXHNewsTemplateContainerViewSpacing * 2, kXHNewsTemplateContainerViewHeight)];
    }
    return _newsTemplateContainerView;
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.newsTemplateContainerView];
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
