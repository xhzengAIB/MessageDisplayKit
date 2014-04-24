//
//  UIScrollView+XHkeyboardControl.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "UIScrollView+XHkeyboardControl.h"

#import <objc/runtime.h>

static NSString * const KeyboardWillBeDismissedBlockKey = @"KeyboardWillBeDismissedBlockKey";
static NSString * const KeyboardDidHideBlockKey = @"KeyboardDidHideBlockKey";
static NSString * const KeyboardDidShowBlockKey = @"KeyboardDidShowBlockKey";
static NSString * const KeyboardDidScrollToPointBlockKey = @"KeyboardDidScrollToPointBlockKey";
static NSString * const KeyboardWillSnapBackToPointBlockKey = @"KeyboardWillSnapBackToPointBlockKey";
static NSString * const KeyboardWillChangeBlockKey = @"KeyboardWillChangeBlockKey";

static NSString * const KeyboardViewKey = @"KeyboardViewKey";
static NSString * const PreviousKeyboardYKey = @"PreviousKeyboardYKey";


@interface UIScrollView (XHKetboradControl)

@property (nonatomic, weak) UIView *keyboardView;
@property (nonatomic, assign) CGFloat previousKeyboardY;

@end

@implementation UIScrollView (XHkeyboardControl)

#pragma mark - Setters

- (void)setKeyboardWillBeDismissed:(KeyboardWillBeDismissedBlock)keyboardWillBeDismissed {
    objc_setAssociatedObject(self, &KeyboardWillBeDismissedBlockKey, keyboardWillBeDismissed, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (KeyboardWillBeDismissedBlock)keyboardWillBeDismissed {
    return objc_getAssociatedObject(self, &KeyboardWillBeDismissedBlockKey);
}

- (void)setKeyboardDidHide:(KeyboardDidHideBlock)keyboardDidHide {
    objc_setAssociatedObject(self, &KeyboardDidHideBlockKey, keyboardDidHide, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (KeyboardDidHideBlock)keyboardDidHide {
    return objc_getAssociatedObject(self, &KeyboardDidHideBlockKey);
}

- (void)setKeyboardDidShow:(KeyboardDidShowBlock)keyboardDidShow {
    objc_setAssociatedObject(self, &KeyboardDidShowBlockKey, keyboardDidShow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (KeyboardDidShowBlock)keyboardDidShow {
    return objc_getAssociatedObject(self, &KeyboardDidShowBlockKey);
}

- (void)setKeyboardWillSnapBackToPoint:(KeyboardWillSnapBackToPointBlock)keyboardWillSnapBackToPoint {
    objc_setAssociatedObject(self, &KeyboardWillSnapBackToPointBlockKey, keyboardWillSnapBackToPoint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (KeyboardWillSnapBackToPointBlock)keyboardWillSnapBackToPoint {
    return objc_getAssociatedObject(self, &KeyboardWillSnapBackToPointBlockKey);
}

- (void)setKeyboardDidScrollToPoint:(KeyboardDidScrollToPointBlock)keyboardDidScrollToPoint {
    objc_setAssociatedObject(self, &KeyboardDidScrollToPointBlockKey, keyboardDidScrollToPoint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (KeyboardDidScrollToPointBlock)keyboardDidScrollToPoint {
    return objc_getAssociatedObject(self, &KeyboardDidScrollToPointBlockKey);
}

- (void)setKeyboardWillChange:(KeyboardWillChangeBlock)keyboardWillChange {
    objc_setAssociatedObject(self, &KeyboardWillChangeBlockKey, keyboardWillChange, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (KeyboardWillChangeBlock)keyboardWillChange {
    return objc_getAssociatedObject(self, &KeyboardWillChangeBlockKey);
}

- (void)setKeyboardView:(UIView *)keyboardView {
    objc_setAssociatedObject(self, &KeyboardViewKey, keyboardView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)keyboardView {
    return objc_getAssociatedObject(self, &KeyboardViewKey);
}

- (void)setPreviousKeyboardY:(CGFloat)previousKeyboardY {
    objc_setAssociatedObject(self, &PreviousKeyboardYKey, [NSNumber numberWithFloat:previousKeyboardY], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)previousKeyboardY {
    return [objc_getAssociatedObject(self, &PreviousKeyboardYKey) floatValue];
}

#pragma mark - Helper Method

+ (UIView *)findKeyboard {
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView)
        {
            return keyboardView;
        }
    }
    return nil;
}

+ (UIView *)findKeyboardInView:(UIView *)view {
    for (UIView *subView in [view subviews])
    {
        if (strstr(object_getClassName(subView), "UIKeyboard"))
        {
            return subView;
        }
        else
        {
            UIView *tempView = [self findKeyboardInView:subView];
            if (tempView)
            {
                return tempView;
            }
        }
    }
    return nil;
}

- (void)setupPanGestureControlKeyboardHide:(BOOL)isPanGestured {
    // 键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboardNotification:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboardNotification:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowHideNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowHideNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    if (isPanGestured)
        [self.panGestureRecognizer addTarget:self action:@selector(handlePanGesture:)];
}

- (void)disSetupPanGestureControlKeyboardHide:(BOOL)isPanGestured {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if (isPanGestured)
        [self.panGestureRecognizer removeTarget:self action:@selector(handlePanGesture:)];
}

#pragma mark - Gestures

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    if(!self.keyboardView || self.keyboardView.hidden)
        return;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    UIWindow *panWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint location = [pan locationInView:panWindow];
    CGPoint velocity = [pan velocityInView:panWindow];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.previousKeyboardY = self.keyboardView.frame.origin.y;
            break;
        case UIGestureRecognizerStateEnded:
            if(velocity.y > 0 && self.keyboardView.frame.origin.y > self.previousKeyboardY) {
                
                [UIView animateWithDuration:0.3
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     self.keyboardView.frame = CGRectMake(0.0f,
                                                                          screenHeight,
                                                                          self.keyboardView.frame.size.width,
                                                                          self.keyboardView.frame.size.height);
                                     
                                     if (self.keyboardWillBeDismissed) {
                                         self.keyboardWillBeDismissed();
                                     }
                                 }
                                 completion:^(BOOL finished) {
                                     self.keyboardView.hidden = YES;
                                     self.keyboardView.frame = CGRectMake(0.0f,
                                                                          self.previousKeyboardY,
                                                                          self.keyboardView.frame.size.width,
                                                                          self.keyboardView.frame.size.height);
                                     [self resignFirstResponder];
                                     
                                     if (self.keyboardDidHide) {
                                         self.keyboardDidHide();
                                     }
                                 }];
            }
            else { // gesture ended with no flick or a flick upwards, snap keyboard back to original position
                [UIView animateWithDuration:0.2
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     if (self.keyboardWillSnapBackToPoint) {
                                         self.keyboardWillSnapBackToPoint(CGPointMake(0.0f, self.previousKeyboardY));
                                     }
                                     
                                     self.keyboardView.frame = CGRectMake(0.0f,
                                                                          self.previousKeyboardY,
                                                                          self.keyboardView.frame.size.width,
                                                                          self.keyboardView.frame.size.height);
                                 }
                                 completion:^(BOOL finished){
                                     if (self.keyboardDidHide) {
                                         self.keyboardDidHide();
                                     }
                                 }];
            }
            break;
            
            // gesture is currently panning, match keyboard y to touch y
        default:
            if(location.y > self.keyboardView.frame.origin.y || self.keyboardView.frame.origin.y != self.previousKeyboardY) {
                
                CGFloat newKeyboardY = self.previousKeyboardY + (location.y - self.previousKeyboardY);
                newKeyboardY = newKeyboardY < self.previousKeyboardY ? self.previousKeyboardY : newKeyboardY;
                newKeyboardY = newKeyboardY > screenHeight ? screenHeight : newKeyboardY;
                
                self.keyboardView.frame = CGRectMake(0.0f,
                                                     newKeyboardY,
                                                     self.keyboardView.frame.size.width,
                                                     self.keyboardView.frame.size.height);
                
                if (self.keyboardDidScrollToPoint) {
                    self.keyboardDidScrollToPoint(CGPointMake(0.0f, newKeyboardY));
                }
            }
            break;
    }
}

#pragma mark - Keyboard notifications

- (void)handleKeyboardWillShowHideNotification:(NSNotification *)notification {
    if([notification.name isEqualToString:UIKeyboardDidShowNotification]) {
        self.keyboardView = [UIScrollView findKeyboard].superview;
        self.keyboardView.hidden = NO;
    }
    else if([notification.name isEqualToString:UIKeyboardDidHideNotification]) {
        self.keyboardView.hidden = NO;
        [self resignFirstResponder];
    }
}

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification {
    self.keyboardView.hidden = NO;
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboardNotification:(NSNotification *)notification {
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification {
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (self.keyboardWillChange) {
        self.keyboardWillChange(keyboardRect, [self animationOptionsForCurve:curve], duration);
    }
}

- (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve {
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            
        default:
            return kNilOptions;
    }
}

@end
