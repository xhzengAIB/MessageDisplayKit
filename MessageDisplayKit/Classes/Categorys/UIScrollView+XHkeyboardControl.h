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
typedef void(^KeyboardDidShowBlock)(void);
typedef void(^KeyboardDidScrollToPointBlock)(CGPoint point);
typedef void(^KeyboardWillSnapBackToPointBlock)(CGPoint point);

typedef void(^KeyboardWillChangeBlock)(CGRect keyboardRect, UIViewAnimationOptions options, double duration);


@interface UIScrollView (XHkeyboardControl)

- (void)setupPanGestureControlKeyboardHide:(BOOL)isPanGestured;
- (void)disSetupPanGestureControlKeyboardHide:(BOOL)isPanGestured;

@property (nonatomic, copy) KeyboardWillBeDismissedBlock keyboardWillBeDismissed;
@property (nonatomic, copy) KeyboardDidHideBlock keyboardDidHide;
@property (nonatomic, copy) KeyboardDidShowBlock keyboardDidShow;
@property (nonatomic, copy) KeyboardDidScrollToPointBlock keyboardDidScrollToPoint;
@property (nonatomic, copy) KeyboardWillSnapBackToPointBlock keyboardWillSnapBackToPoint;

@property (nonatomic, copy) KeyboardWillChangeBlock keyboardWillChange;

@end
