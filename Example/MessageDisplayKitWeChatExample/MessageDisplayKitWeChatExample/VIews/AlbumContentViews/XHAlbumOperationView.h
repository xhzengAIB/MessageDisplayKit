//
//  XHAlbumOperationView.h
//  MessageDisplayKitWeChatExample
//
//  Created by Jack_iMac on 15/2/9.
//  Copyright (c) 2015年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XHAlbumOperationType) {
    XHAlbumOperationTypeReply = 0,
    XHAlbumOperationTypeLike = 1,
};

typedef void(^DidSelectedOperationBlock)(XHAlbumOperationType operationType);

@interface XHAlbumOperationView : UIView

@property (nonatomic, assign) BOOL shouldShowed;

@property (nonatomic, copy) DidSelectedOperationBlock didSelectedOperationCompletion;

+ (instancetype)initailzerAlbumOperationView;

- (void)showAtView:(UIView *)containerView rect:(CGRect)targetRect;

- (void)dismiss;

@end
