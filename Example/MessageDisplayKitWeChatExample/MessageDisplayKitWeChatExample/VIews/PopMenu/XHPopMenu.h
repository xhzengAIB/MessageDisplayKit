//
//  XHPopMenu.h
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-6-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHPopMenuItem.h"

typedef void(^PopMenuDidSlectedCompledBlock)(NSInteger index, XHPopMenuItem *menuItem);

@interface XHPopMenu : UIView

- (instancetype)initWithMenus:(NSArray *)menus;

- (instancetype)initWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

- (void)showMenuAtPoint:(CGPoint)point;

- (void)showMenuOnView:(UIView *)view atPoint:(CGPoint)point;

@property (nonatomic, copy) PopMenuDidSlectedCompledBlock popMenuDidSlectedCompled;

@property (nonatomic, copy) PopMenuDidSlectedCompledBlock popMenuDidDismissCompled;

@end
