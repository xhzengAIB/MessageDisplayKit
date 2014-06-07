//
//  XHPopMenuItemView.h
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-6-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHPopMenuItem.h"

@interface XHPopMenuItemView : UITableViewCell

@property (nonatomic, strong) XHPopMenuItem *popMenuItem;

- (void)setupPopMenuItem:(XHPopMenuItem *)popMenuItem atIndexPath:(NSIndexPath *)indexPath isBottom:(BOOL)isBottom;

@end
