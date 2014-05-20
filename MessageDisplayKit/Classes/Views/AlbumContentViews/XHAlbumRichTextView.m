//
//  XHAlbumRichTextView.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-19.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHAlbumRichTextView.h"
#import "XHMessageAvatorFactory.h"

@implementation XHAlbumRichTextView

+ (CGFloat)calculateRichTextHeightWithAlbum:(XHAlbum *)currentAlbum {
    __block CGFloat richTextHeight = kXHAlbumAvatorSpacing * 2;
    
    richTextHeight += [SETextView frameRectWithAttributtedString:[[NSAttributedString alloc] initWithString:currentAlbum.shareContent] constraintSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) - kXHAvatarImageSize - (kXHAlbumAvatorSpacing * 3), CGFLOAT_MAX) lineSpacing:kXHAlbumContentLineSpacing font:kXHAlbumContentFont].size.height;
    
    [currentAlbum.shareImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        richTextHeight += (kXHAlbumPhotoSize + kXHAlbumPhotoInsets);
    }];
    
    return richTextHeight;
}

#pragma mark - Propertys

- (void)setDisplayAlbum:(XHAlbum *)displayAlbum {
    _displayAlbum = displayAlbum;
    
    
}

- (SETextView *)richTextView {
    if (!_richTextView) {
        _richTextView = [[SETextView alloc] initWithFrame:self.bounds];
        _richTextView.font = self.font;
        _richTextView.textColor = self.textColor;
        _richTextView.textAlignment = self.textAlignment;
        _richTextView.lineSpacing = self.lineSpacing;
    }
    return _richTextView;
}

#pragma mark - Life Cycle

- (void)setup {
    self.font = [UIFont systemFontOfSize:17];
    self.textColor = [UIColor blackColor];
    self.textAlignment = NSTextAlignmentLeft;
    self.lineSpacing = 5;
    
    [self addSubview:self.richTextView];
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
