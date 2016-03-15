//
//  XHRefreshCircleView.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-6-6.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import <UIKit/UIKit.h>

//开始画圆圈时的offset
#define kXHRefreshCircleViewHeight 20

//圆圈开始旋转时的offset （即开始刷新数据时）
//#define HEIGHT_BEGIN_TO_REFRESH         (50 + HEIGHT_BEGIN_TO_DRAW_CIRCLE)

@interface XHRefreshCircleView : UIView

//圆圈开始旋转时的offset （即开始刷新数据时）
@property (nonatomic, assign) CGFloat heightBeginToRefresh;

//offset的Y值
@property (nonatomic, assign) CGFloat offsetY;

/**
 *  isRefreshViewOnTableView
 *  YES:refreshView是tableView的子view
 *  NO:refreshView是tableView.superView的子view
 */
@property (nonatomic, assign) BOOL isRefreshViewOnTableView;

/**
 *  旋转的animation
 *
 *  @return animation
 */
+ (CABasicAnimation*)repeatRotateAnimation;

@end
