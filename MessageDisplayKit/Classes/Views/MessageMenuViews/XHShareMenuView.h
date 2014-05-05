//
//  XHShareMenuView.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-1.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHShareMenuItem.h"

#define kXHShareMenuPageControlHeight 30

@protocol XHShareMenuViewDelegate <NSObject>

@optional
- (void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index;

@end


@interface XHShareMenuView : UIView

/**
 *  第三方功能Models
 */
@property (nonatomic, strong) NSArray *shareMenuItems;

@property (nonatomic, weak) id <XHShareMenuViewDelegate> delegate;


- (void)reloadData;

@end
