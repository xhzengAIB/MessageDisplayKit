//
//  XHAlbumOperationView.h
//  MessageDisplayKitWeChatExample
//
//  Created by Jack_iMac on 15/2/9.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
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
