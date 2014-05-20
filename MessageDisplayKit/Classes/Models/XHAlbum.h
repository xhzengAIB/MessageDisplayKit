//
//  XHAlbum.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-19.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>

// 朋友圈分享的图片以及图片之间的间隔
#define kXHAlbumPhotoSize 80
#define kXHAlbumPhotoInsets 5

// 朋友圈分享内容字体和间隔
#define kXHAlbumContentFont [UIFont systemFontOfSize:17]
#define kXHAlbumContentLineSpacing 4

// 朋友圈评论按钮大小
#define kXHAlbumCommentButtonWidth 30
#define kXHAlbumCommentButtonHeight 20

@interface XHAlbum : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *profileAvatorUrlString;

@property (nonatomic, copy) NSString *shareContent;

@property (nonatomic, strong) NSArray *shareImages;

@property (nonatomic, strong) NSArray *shareComments;

@property (nonatomic, strong) NSArray *shareLikes;

@end
