//
//  XHAlbumLikesCommentsView.m
//  MessageDisplayKitWeChatExample
//
//  Created by Jack_iMac on 15/2/28.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import "XHAlbumLikesCommentsView.h"

#define kXHAlbumLikeLabelBaseTag 100

@interface XHAlbumCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong) id item;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)setupItem:(id)item atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation XHAlbumCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.commentLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect userNameLabelFrame = self.userNameLabel.frame;
    
    CGRect commentLabelFrame = self.commentLabel.frame;
    commentLabelFrame.origin.x = CGRectGetMaxX(userNameLabelFrame);
    commentLabelFrame.size = CGSizeMake(100, 16);
    self.commentLabel.frame = commentLabelFrame;
}

- (void)setupItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    self.item = item;
    self.indexPath = indexPath;
    
    self.userNameLabel.text = @"Jack";
    self.commentLabel.text = [NSString stringWithFormat:@": %@", item];
}

#pragma mark - Propertys

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, 22, 16)];
        _userNameLabel.textColor = [UIColor blueColor];
        _userNameLabel.font = [UIFont systemFontOfSize:10];
    }
    return _userNameLabel;
}

- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLabel.textColor = [UIColor blackColor];
        _commentLabel.font = [UIFont systemFontOfSize:10];
    }
    return _commentLabel;
}

@end

@interface XHAlbumLikesCommentsView () <UITableViewDataSource>

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
        self.clipsToBounds = YES;
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.likeContainerView];
        [self addSubview:self.commmentTableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

}

- (void)updateUserInterface {
    BOOL shouldShowLike = self.likes.count > 0;
    BOOL shouldShowComment = self.comments.count > 0;
    
    self.likeContainerView.hidden = !shouldShowLike;
    self.commmentTableView.hidden = !shouldShowComment;
    
    if (!shouldShowLike && !shouldShowComment) {
        self.frame = CGRectZero;
        return;
    }
    
    CGRect likeContainerViewFrame = CGRectZero;
    
    if (shouldShowLike) {
        likeContainerViewFrame = CGRectMake(0, 4, CGRectGetWidth(self.bounds), 14);
        self.likeContainerView.frame = likeContainerViewFrame;
    }
    
    CGRect commentTableViewFrame = CGRectZero;
    if (shouldShowComment) {
        commentTableViewFrame = self.commmentTableView.frame;
        commentTableViewFrame.origin.y = CGRectGetMaxY(likeContainerViewFrame) + (shouldShowLike ? 0 : 4);
        commentTableViewFrame.size.height = self.comments.count * 16;
        self.commmentTableView.frame = commentTableViewFrame;
    }
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY((shouldShowComment ? commentTableViewFrame : likeContainerViewFrame));
    self.frame = frame;
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
        CGRect likeIconImageViewFrame = _likeIconImageView.frame;
        likeIconImageViewFrame.origin = CGPointMake(5, 0);
        _likeIconImageView.frame = likeIconImageViewFrame;
    }
    return _likeIconImageView;
}

- (UITableView *)commmentTableView {
    if (!_commmentTableView) {
        _commmentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _commmentTableView.separatorColor = [UIColor clearColor];
        _commmentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_commmentTableView registerClass:[XHAlbumCommentTableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
        _commmentTableView.dataSource = self;
        _commmentTableView.scrollEnabled = NO;
        _commmentTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _commmentTableView.backgroundColor = [UIColor clearColor];
        _commmentTableView.rowHeight = 16;
    }
    return _commmentTableView;
}

#pragma mark - 公开方法

- (void)reloadLikes {
    for (UIView *view in self.likeContainerView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            view.hidden = YES;
        }
    }
    CGRect likeLabelFrame = CGRectZero;
    for (int i = 0; i < self.likes.count; i ++) {
        likeLabelFrame = CGRectMake(CGRectGetMaxX(self.likeIconImageView.frame) + i * 30 + 5, CGRectGetMinY(self.likeIconImageView.frame), 30, CGRectGetHeight(self.likeIconImageView.bounds));
        
        UILabel *likeLabel = (UILabel *)[self.likeContainerView viewWithTag:kXHAlbumLikeLabelBaseTag + i];
        if (!likeLabel) {
            likeLabel = [[UILabel alloc] initWithFrame:likeLabelFrame];
        }
        likeLabel.hidden = NO;
        likeLabel.font = [UIFont systemFontOfSize:10];
        likeLabel.textColor = [UIColor blueColor];
        likeLabel.text = [NSString stringWithFormat:@"%@%@", self.likes[i], (i == self.likes.count - 1) ? @"" : @","];
        [self.likeContainerView addSubview:likeLabel];
    }
}

- (void)reloadData {
    [self.commmentTableView reloadData];
    [self reloadLikes];
    [self updateUserInterface];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XHAlbumCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    [cell setupItem:self.comments[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

@end
