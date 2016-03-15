//
//  XHAlbumTableViewCell.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-19.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHAlbumTableViewCell.h"

#import "XHAlbumRichTextView.h"

#import <MessageDisplayKit/XHMacro.h>

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
        WEAKSELF
        _albumRichTextView.commentButtonDidSelectedCompletion = ^(UIButton *sender){
            STRONGSELF
            if ([strongSelf.delegate respondsToSelector:@selector(didShowOperationView:indexPath:)]) {
                [strongSelf.delegate didShowOperationView:sender indexPath:strongSelf.indexPath];
            }
        };
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
