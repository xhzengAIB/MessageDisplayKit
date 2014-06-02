//
//  UIView+XHBadgeView.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-28.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKBadgeView.h"

@interface XHCircleView : UIView

@end

@interface UIView (XHBadgeView)

@property (nonatomic, assign) CGRect badgeViewFrame;
@property (nonatomic, strong, readonly) LKBadgeView *badgeView;

- (XHCircleView *)setupCircleBadge;

@end
