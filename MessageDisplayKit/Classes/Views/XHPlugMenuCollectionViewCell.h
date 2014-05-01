//
//  XHPlugMenuCollectionViewCell.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-30.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHPlugItem.h"

#define kXHPlugMenuCollectionViewCellIdentifer @"XHPlugMenuCollectionViewCellIdentifer"

@interface XHPlugMenuCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) XHPlugItem *plugItem;

@end
