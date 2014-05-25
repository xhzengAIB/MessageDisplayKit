//
//  XHAlbumRichTextView.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-19.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHAlbum.h"

#import "SETextView.h"

@interface XHAlbumRichTextView : UIView

@property (nonatomic, strong) NSFont *font;
@property (nonatomic, strong) NSColor *textColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) CGFloat lineSpacing;

@property (nonatomic, strong) SETextView *richTextView;

@property (nonatomic, strong) XHAlbum *displayAlbum;

+ (CGFloat)calculateRichTextHeightWithAlbum:(XHAlbum *)currentAlbum;

@end
