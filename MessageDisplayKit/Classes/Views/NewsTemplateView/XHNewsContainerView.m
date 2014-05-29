//
//  XHNewsContainerView.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-29.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHNewsContainerView.h"

@implementation XHNewsContainerView

#pragma mark - Propertys

- (UILabel *)newsSummeryLabel {
    if (!_newsSummeryLabel) {
        _newsSummeryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.bounds) - 5 * 3 - 40, 40)];
        _newsSummeryLabel.numberOfLines = 2;
        _newsSummeryLabel.font = [UIFont boldSystemFontOfSize:14];
        _newsSummeryLabel.textColor = [UIColor blackColor];
        _newsSummeryLabel.backgroundColor = [UIColor clearColor];
        _newsSummeryLabel.text = @"这里是iOS开发者大会，欢迎来到华捷，我们今天的主题是群聊，大多数人会为群里的核心技术在哪里？";
    }
    return _newsSummeryLabel;
}

- (UIImageView *)newsThumbailImageView {
    if (!_newsThumbailImageView) {
        _newsThumbailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 40, 5, 40, 40)];
        _newsThumbailImageView.image = [UIImage imageNamed:@"MeIcon"];
    }
    return _newsThumbailImageView;
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.newsSummeryLabel];
        [self addSubview:self.newsThumbailImageView];
    }
    return self;
}

@end
