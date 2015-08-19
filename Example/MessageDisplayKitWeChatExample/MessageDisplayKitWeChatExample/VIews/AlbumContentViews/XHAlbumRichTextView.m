//
//  XHAlbumRichTextView.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-19.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHAlbumRichTextView.h"
#import <MessageDisplayKit/XHMessageAvatarFactory.h>

#import "XHAlbumPhotoCollectionViewCell.h"
#import "XHAlbumCollectionViewFlowLayout.h"

#import "XHImageViewer.h"

#import "XHAlbumLikesCommentsView.h"

#define kXHPhotoCollectionViewCellIdentifier @"XHPhotoCollectionViewCellIdentifier"

@interface XHAlbumCollectionView : UICollectionView

@end

@implementation XHAlbumCollectionView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSIndexPath *touchIndexPath = [self indexPathForItemAtPoint:point];
    if (!touchIndexPath) {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}

@end

@interface XHAlbumRichTextView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) XHAlbumCollectionView *sharePhotoCollectionView;

@property (nonatomic, strong) UILabel *timestampLabel;
@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) XHAlbumLikesCommentsView *albumLikesCommentsView;

@end

@implementation XHAlbumRichTextView

+ (CGFloat)getRichTextHeightWithText:(NSString *)text {
    if (!text || !text.length)
        return 0;
    return [SETextView frameRectWithAttributtedString:[[NSAttributedString alloc] initWithString:text] constraintSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) - kXHAvatarImageSize - (kXHAlbumAvatarSpacing * 3), CGFLOAT_MAX) lineSpacing:kXHAlbumContentLineSpacing font:kXHAlbumContentFont].size.height;
}

+ (CGFloat)getSharePhotoCollectionViewHeightWithPhotos:(NSArray *)photos {
    // 上下间隔已经在frame上做了
    NSInteger row = (photos.count / 3 + (photos.count % 3 ? 1 : 0));
    return (row * (kXHAlbumPhotoSize) + ((row - 1) * kXHAlbumPhotoInsets));
}

+ (CGFloat)calculateRichTextHeightWithAlbum:(XHAlbum *)currentAlbum {
    CGFloat richTextHeight = kXHAlbumAvatarSpacing * 2;
    
    richTextHeight += kXHAlbumUserNameHeigth;
    
    richTextHeight += kXHAlbumContentLineSpacing;
    richTextHeight += [self getRichTextHeightWithText:currentAlbum.albumShareContent];
    
    richTextHeight += kXHAlbumPhotoInsets;
    richTextHeight += [self getSharePhotoCollectionViewHeightWithPhotos:currentAlbum.albumSharePhotos];
    
    richTextHeight += kXHAlbumContentLineSpacing;
    richTextHeight += kXHAlbumCommentButtonHeight;
    
    richTextHeight += 4;
    richTextHeight += 14;
    richTextHeight += currentAlbum.albumShareComments.count * 16;
    
    return richTextHeight;
}

#pragma mark - Actions

- (void)commentButtonDidClicked:(UIButton *)sender {
    if (self.commentButtonDidSelectedCompletion) {
        self.commentButtonDidSelectedCompletion(sender);
    }
}

#pragma mark - Propertys

- (void)setDisplayAlbum:(XHAlbum *)displayAlbum {
    if (!displayAlbum)
        return;
    _displayAlbum = displayAlbum;
    
    self.userNameLabel.text = displayAlbum.userName;
    
    self.richTextView.attributedText = [[NSAttributedString alloc] initWithString:displayAlbum.albumShareContent];
    
    self.timestampLabel.text = @"3小时前";
    
    [self.sharePhotoCollectionView reloadData];
    
    self.albumLikesCommentsView.likes = displayAlbum.albumShareLikes;
    self.albumLikesCommentsView.comments = displayAlbum.albumShareComments;
    [self.albumLikesCommentsView reloadData];
    
    [self setNeedsLayout];
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kXHAlbumAvatarSpacing, kXHAlbumAvatarSpacing, kXHAvatarImageSize, kXHAvatarImageSize)];
        _avatarImageView.image = [UIImage imageNamed:@"MeIcon"];
    }
    return _avatarImageView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        CGFloat userNameLabelX = CGRectGetMaxX(self.avatarImageView.frame) + kXHAlbumAvatarSpacing;
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userNameLabelX, CGRectGetMinY(self.avatarImageView.frame), CGRectGetWidth([[UIScreen mainScreen] bounds]) - userNameLabelX - kXHAlbumAvatarSpacing, kXHAlbumUserNameHeigth)];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.textColor = [UIColor colorWithRed:0.294 green:0.595 blue:1.000 alpha:1.000];
    
    }
    return _userNameLabel;
}

- (SETextView *)richTextView {
    if (!_richTextView) {
        _richTextView = [[SETextView alloc] initWithFrame:self.bounds];
        _richTextView.backgroundColor = [UIColor clearColor];
        _richTextView.font = self.font;
        _richTextView.textColor = self.textColor;
        _richTextView.textAlignment = self.textAlignment;
        _richTextView.lineSpacing = self.lineSpacing;
    }
    return _richTextView;
}

- (XHAlbumCollectionView *)sharePhotoCollectionView {
    if (!_sharePhotoCollectionView) {
        _sharePhotoCollectionView = [[XHAlbumCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[XHAlbumCollectionViewFlowLayout alloc] init]];
        _sharePhotoCollectionView.backgroundColor = self.richTextView.backgroundColor;
        [_sharePhotoCollectionView registerClass:[XHAlbumPhotoCollectionViewCell class] forCellWithReuseIdentifier:kXHPhotoCollectionViewCellIdentifier];
        [_sharePhotoCollectionView setScrollsToTop:NO];
        _sharePhotoCollectionView.delegate = self;
        _sharePhotoCollectionView.dataSource = self;
    }
    return _sharePhotoCollectionView;
}

- (UILabel *)timestampLabel {
    if (!_timestampLabel) {
        _timestampLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timestampLabel.backgroundColor = [UIColor clearColor];
        _timestampLabel.font = [UIFont systemFontOfSize:11];
        _timestampLabel.textColor = [UIColor grayColor];
    }
    return _timestampLabel;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_commentButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
        [_commentButton setImage:[UIImage imageNamed:@"AlbumOperateMoreHL"] forState:UIControlStateHighlighted];
        [_commentButton addTarget:self action:@selector(commentButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (XHAlbumLikesCommentsView *)albumLikesCommentsView {
    if (!_albumLikesCommentsView) {
        _albumLikesCommentsView = [[XHAlbumLikesCommentsView alloc] initWithFrame:CGRectZero];
    }
    return _albumLikesCommentsView;
}
#pragma mark - Life Cycle

- (void)setup {
    self.font = kXHAlbumContentFont;
    self.textColor = [UIColor blackColor];
    self.textAlignment = NSTextAlignmentLeft;
    self.lineSpacing = kXHAlbumContentLineSpacing;
    
    [self addSubview:self.avatarImageView];
    [self addSubview:self.userNameLabel];
    
    [self addSubview:self.richTextView];
    [self addSubview:self.sharePhotoCollectionView];
    
    [self addSubview:self.timestampLabel];
    [self addSubview:self.commentButton];
    
    [self addSubview:self.albumLikesCommentsView];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.font = nil;
    self.textColor = nil;
    self.richTextView = nil;
    _displayAlbum = nil;
    
    self.avatarImageView = nil;
    self.userNameLabel = nil;
    self.sharePhotoCollectionView.delegate = nil;
    self.sharePhotoCollectionView.dataSource = nil;
    self.sharePhotoCollectionView = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat richTextViewX = CGRectGetMinX(self.userNameLabel.frame);
    CGRect richTextViewFrame = CGRectMake(richTextViewX, CGRectGetMaxY(self.userNameLabel.frame) + kXHAlbumContentLineSpacing, CGRectGetWidth([[UIScreen mainScreen] bounds]) - richTextViewX - kXHAlbumAvatarSpacing, [XHAlbumRichTextView getRichTextHeightWithText:self.displayAlbum.albumShareContent]);
    self.richTextView.frame = richTextViewFrame;
    
    CGRect sharePhotoCollectionViewFrame = CGRectMake(richTextViewX, CGRectGetMaxY(richTextViewFrame) + kXHAlbumPhotoInsets, kXHAlbumPhotoInsets * 4 + kXHAlbumPhotoSize * 3, [XHAlbumRichTextView getSharePhotoCollectionViewHeightWithPhotos:self.displayAlbum.albumSharePhotos]);
    self.sharePhotoCollectionView.frame = sharePhotoCollectionViewFrame;
    
    CGRect commentButtonFrame = self.commentButton.frame;
    commentButtonFrame.origin = CGPointMake(CGRectGetMaxX(richTextViewFrame) - kXHAlbumCommentButtonWidth, CGRectGetMaxY(sharePhotoCollectionViewFrame) + kXHAlbumContentLineSpacing);
    commentButtonFrame.size = CGSizeMake(kXHAlbumCommentButtonWidth, kXHAlbumCommentButtonHeight);
    self.commentButton.frame = commentButtonFrame;
    
    CGRect timestampLabelFrame = self.timestampLabel.frame;
    timestampLabelFrame.origin = CGPointMake(CGRectGetMinX(richTextViewFrame), CGRectGetMinY(commentButtonFrame));
    timestampLabelFrame.size = CGSizeMake(CGRectGetWidth(self.bounds) - kXHAlbumAvatarSpacing * 3 - kXHAvatarImageSize - kXHAlbumCommentButtonWidth, CGRectGetHeight(commentButtonFrame));
    self.timestampLabel.frame = timestampLabelFrame;
    
    // 这里出现延迟布局的情况，所以就不能正常排版
    CGRect likesCommentsViewFrame = self.albumLikesCommentsView.frame;
    likesCommentsViewFrame.origin = CGPointMake(CGRectGetMinX(richTextViewFrame), CGRectGetMaxY(timestampLabelFrame));
    likesCommentsViewFrame.size.width = CGRectGetWidth(richTextViewFrame);
    self.albumLikesCommentsView.frame = likesCommentsViewFrame;
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(likesCommentsViewFrame) + kXHAlbumAvatarSpacing;
    self.frame = frame;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.displayAlbum.albumSharePhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XHAlbumPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXHPhotoCollectionViewCellIdentifier forIndexPath:indexPath];
    
    cell.indexPath = indexPath;
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self showImageViewerAtIndexPath:indexPath];
}

- (void)showImageViewerAtIndexPath:(NSIndexPath *)indexPath {
    XHAlbumPhotoCollectionViewCell *cell = (XHAlbumPhotoCollectionViewCell *)[self.sharePhotoCollectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableArray *imageViews = [NSMutableArray array];
    
    NSArray *visibleCell = [self.sharePhotoCollectionView visibleCells];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"indexPath" ascending:YES];
    
    visibleCell = [visibleCell sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    [visibleCell enumerateObjectsUsingBlock:^(XHAlbumPhotoCollectionViewCell *cell, NSUInteger idx, BOOL *stop) {
        [imageViews addObject:cell.photoImageView];
    }];
    
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    [imageViewer showWithImageViews:imageViews selectedView:cell.photoImageView];
}

@end
