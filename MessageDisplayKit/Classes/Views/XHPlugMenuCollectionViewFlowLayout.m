//
//  XHPlugMenuCollectionViewFlowLayout.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-30.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPlugMenuCollectionViewFlowLayout.h"

@implementation XHPlugMenuCollectionViewFlowLayout

- (id)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(kXHPlugItemIconSize, KXHPlugItemHeight);
        self.minimumLineSpacing = 16;
    }
    return self;
}

@end
