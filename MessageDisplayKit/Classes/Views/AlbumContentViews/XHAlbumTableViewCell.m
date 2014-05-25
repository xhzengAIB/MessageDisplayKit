//
//  XHAlbumTableViewCell.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-19.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHAlbumTableViewCell.h"

#import "XHAlbumRichTextView.h"

@interface XHAlbumTableViewCell ()

@property (nonatomic, strong) XHAlbumRichTextView *albumRichTextView;

@end

@implementation XHAlbumTableViewCell

+ (CGFloat)calculateCellHeightWithAlbum:(XHAlbum *)currentAlbum {
    return [XHAlbumRichTextView calculateRichTextHeightWithAlbum:currentAlbum];
}

#pragma mark - Propertys

- (void)setCurrentAlbum:(XHAlbum *)currentAlbum {
    if (!currentAlbum)
        return;
    _currentAlbum = currentAlbum;
    
    self.albumRichTextView.displayAlbum = currentAlbum;
}

- (XHAlbumRichTextView *)albumRichTextView {
    if (!_albumRichTextView) {
        _albumRichTextView = [[XHAlbumRichTextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 40)];
    }
    return _albumRichTextView;
}

#pragma mark - Life Cycle

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.albumRichTextView];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    _currentAlbum = nil;
    self.albumRichTextView = nil;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
