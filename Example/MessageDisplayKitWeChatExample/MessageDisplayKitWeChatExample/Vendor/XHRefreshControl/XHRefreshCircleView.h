//
//  XHRefreshCircleView.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-6-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
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
