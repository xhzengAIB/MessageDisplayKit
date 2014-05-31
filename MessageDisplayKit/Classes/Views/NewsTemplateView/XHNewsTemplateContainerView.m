//
//  XHNewsTemplateContainerView.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-29.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHNewsTemplateContainerView.h"

#import "XHNewsContainerView.h"

#import "XHMacro.h"

@interface XHNewsTemplateContainerView ()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation XHNewsTemplateContainerView

#pragma mark - Propertys

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.image = XH_STRETCH_IMAGE([UIImage imageNamed:@"NewsBackgroundImage"], UIEdgeInsetsMake(7, 7, 7, 7));
    }
    return _backgroundImageView;
}

- (UIImageView *)topNewsImageView {
    if (!_topNewsImageView) {
        _topNewsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.bounds) - 20, CGRectGetHeight(self.bounds) - 180)];
        _topNewsImageView.image = [UIImage imageNamed:@"AlbumHeaderBackgrounImage"];
        [_topNewsImageView addSubview:self.topNewsTitleLabel];
    }
    return _topNewsImageView;
}
- (UILabel *)topNewsTitleLabel {
    if (!_topNewsTitleLabel) {
        _topNewsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_topNewsImageView.bounds) - 30, CGRectGetWidth(_topNewsImageView.bounds), 30)];
        _topNewsTitleLabel.backgroundColor = [UIColor blackColor];
        _topNewsTitleLabel.textColor = [UIColor whiteColor];
        _topNewsTitleLabel.font = [UIFont boldSystemFontOfSize:15];
        _topNewsTitleLabel.text = @"我们是一个专业的团队，群聊开始做吧！";
    }
    return _topNewsTitleLabel;
}

- (UIImageView *)sepatorImageViewWithWidth:(CGFloat)width {
    UIImageView *sepatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5)];
    sepatorImageView.backgroundColor = [UIColor grayColor];
    return sepatorImageView;
}

- (UIView *)containerView {
    if (!_containerView) {
        UIImageView *sepatorImageView = [self sepatorImageViewWithWidth:CGRectGetWidth(self.bounds)];
        CGRect sepatorImageViewFrame = sepatorImageView.frame;
        sepatorImageViewFrame.origin.y = CGRectGetMaxY(self.topNewsImageView.frame) + 10;
        sepatorImageView.frame = sepatorImageViewFrame;
        [self addSubview:sepatorImageView];
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(sepatorImageViewFrame), CGRectGetWidth(self.bounds) - 20, 50 * 3 + 2)];
        for (int i = 0; i < 3; i ++) {
            XHNewsContainerView *currentNewsView = [[XHNewsContainerView alloc] initWithFrame:CGRectMake(0, i * (50 + 1), CGRectGetWidth(_containerView.bounds), 50)];
            if (i < 2) {
                UIImageView *sepatorImageView = [self sepatorImageViewWithWidth:CGRectGetWidth(self.topNewsImageView.bounds)];
                CGRect sepatorImageViewFrame = sepatorImageView.frame;
                sepatorImageViewFrame.origin.y = CGRectGetMaxY(currentNewsView.frame);
                sepatorImageView.frame = sepatorImageViewFrame;
                [_containerView addSubview:sepatorImageView];
            }
            [_containerView addSubview:currentNewsView];
        }
    }
    return _containerView;
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.topNewsImageView];
        [self addSubview:self.containerView];
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
