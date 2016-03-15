//
//  UIView+XHBadgeView.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-28.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageDisplayKit/LKBadgeView.h>

@interface XHCircleView : UIView

@end

@interface UIView (XHBadgeView)

@property (nonatomic, assign) CGRect badgeViewFrame;
@property (nonatomic, strong, readonly) LKBadgeView *badgeView;

- (XHCircleView *)setupCircleBadge;

- (void)destroyCircleBadge;

@end
