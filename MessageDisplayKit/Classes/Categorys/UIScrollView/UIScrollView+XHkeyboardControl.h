//
//  UIScrollView+XHkeyboardControl.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^KeyboardWillBeDismissedBlock)(void);
typedef void(^KeyboardDidHideBlock)(void);
typedef void(^KeyboardDidShowBlock)(BOOL didShowed);
typedef void(^KeyboardDidScrollToPointBlock)(CGPoint point);
typedef void(^KeyboardWillSnapBackToPointBlock)(CGPoint point);

typedef void(^KeyboardWillChangeBlock)(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyborad);


@interface UIScrollView (XHkeyboardControl)

@property (nonatomic, weak) UIView *keyboardView;

/**
 *  根据是否需要手势控制键盘消失注册键盘的通知
 *
 *  @param isPanGestured 手势的需要与否
 */
- (void)setupPanGestureControlKeyboardHide:(BOOL)isPanGestured;

/**
 *  不需要根据是否需要手势控制键盘消失remove键盘的通知，因为注册的时候，已经固定了这里是否需要释放手势对象了
 *
 *  @param isPanGestured 根据注册通知里面的YES or NO来进行设置，千万别搞错了
 */
- (void)disSetupPanGestureControlKeyboardHide:(BOOL)isPanGestured;

/**
 *  手势控制的时候，将要开始消失了，意思在UIView动画里面的animation里面，告诉键盘也需要跟着移动了，顺便需要移动inputView的位置啊！
 */
@property (nonatomic, copy) KeyboardWillBeDismissedBlock keyboardWillBeDismissed;

/**
 *  键盘刚好隐藏
 */
@property (nonatomic, copy) KeyboardDidHideBlock keyboardDidHide;

/**
 *  键盘刚好变换完成
 */
@property (nonatomic, copy) KeyboardDidShowBlock keyboardDidChange;

/**
 *  手势控制键盘，滑动到某一点的回调
 */
@property (nonatomic, copy) KeyboardDidScrollToPointBlock keyboardDidScrollToPoint;

/**
 *  手势控制键盘，滑动到键盘以下的某个位置，然后又想撤销隐藏的手势，告诉键盘又要显示出来啦！顺便需要移动inputView的位置啊！
 */
@property (nonatomic, copy) KeyboardWillSnapBackToPointBlock keyboardWillSnapBackToPoint;

/**
 *  键盘状态改变的回调
 */
@property (nonatomic, copy) KeyboardWillChangeBlock keyboardWillChange;

/**
 *  手势控制键盘的偏移量
 */
@property (nonatomic, assign) CGFloat messageInputBarHeight;

@end
