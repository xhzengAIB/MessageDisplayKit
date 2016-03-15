//
//  XHAlbumRichTextView.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-19.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageDisplayKit/SETextView.h>

#import "XHAlbum.h"

typedef void(^CommentButtonDidSelectedBlock)(UIButton *sender);

@interface XHAlbumRichTextView : UIView

@property (nonatomic, strong) NSFont *font;
@property (nonatomic, strong) NSColor *textColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) CGFloat lineSpacing;

@property (nonatomic, strong) SETextView *richTextView;

@property (nonatomic, strong) XHAlbum *displayAlbum;

@property (nonatomic, copy) CommentButtonDidSelectedBlock commentButtonDidSelectedCompletion;

+ (CGFloat)calculateRichTextHeightWithAlbum:(XHAlbum *)currentAlbum;

@end
