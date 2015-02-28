//
//  XHAlbumLikesCommentsView.m
//  MessageDisplayKitWeChatExample
//
//  Created by Jack_iMac on 15/2/28.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import "XHAlbumLikesCommentsView.h"

@interface XHAlbumLikesCommentsView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIView *likeContainerView;
@property (nonatomic, strong) UIImageView *likeIconImageView;

@property (nonatomic, strong) UITableView *commmentTableView;

@end

@implementation XHAlbumLikesCommentsView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.likeContainerView];
        [self addSubview:self.commmentTableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect likeIconImageViewFrame = self.likeIconImageView.frame;
    likeIconImageViewFrame.origin = CGPointMake(5, 7);
    self.likeContainerView.frame = likeIconImageViewFrame;
    
    CGRect likeContainerViewFrame = CGRectMake(0, 4, CGRectGetWidth(self.bounds), 20);
    self.likeContainerView.frame = likeContainerViewFrame;
    
    CGRect commentTableViewFrame = self.commmentTableView.frame;
    commentTableViewFrame.size.height = 20;
    commentTableViewFrame.origin.y = CGRectGetMaxY(likeContainerViewFrame);
    self.commmentTableView.frame = commentTableViewFrame;
}

#pragma mark - Propertys

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundImageView.image = [[UIImage imageNamed:@"Album_likes_comments_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 24, 8, 8) resizingMode:UIImageResizingModeStretch];
    }
    return _backgroundImageView;
}

- (UIView *)likeContainerView {
    if (!_likeContainerView) {
        _likeContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [_likeContainerView addSubview:self.likeIconImageView];
    }
    return _likeContainerView;
}
- (UIImageView *)likeIconImageView {
    if (!_likeIconImageView) {
        _likeIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Album_like_icon"]];
    }
    return _likeIconImageView;
}

- (UITableView *)commmentTableView {
    if (!_commmentTableView) {
        _commmentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _commmentTableView.scrollEnabled = NO;
        _commmentTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _commmentTableView.backgroundColor = [UIColor redColor];
        _commmentTableView.rowHeight = 8;
    }
    return _commmentTableView;
}

#pragma mark - 公开方法

- (void)reloadData {
    
}

@end
