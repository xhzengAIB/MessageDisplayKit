//
//  XHAlbum.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-19.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import <Foundation/Foundation.h>

// 朋友圈分享人的名称高度
#define kXHAlbumUserNameHeigth 18

// 朋友圈分享的图片以及图片之间的间隔
#define kXHAlbumPhotoSize 60
#define kXHAlbumPhotoInsets 5

// 朋友圈分享内容字体和间隔
#define kXHAlbumContentFont [UIFont systemFontOfSize:13]
#define kXHAlbumContentLineSpacing 4

// 朋友圈评论按钮大小
#define kXHAlbumCommentButtonWidth 25
#define kXHAlbumCommentButtonHeight 25

@interface XHAlbum : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *profileAvatarUrlString;

@property (nonatomic, copy) NSString *albumShareContent;

@property (nonatomic, strong) NSArray *albumSharePhotos;

@property (nonatomic, strong) NSArray *albumShareComments;

@property (nonatomic, strong) NSArray *albumShareLikes;

@property (nonatomic, strong) NSDate *timestamp;

@end
