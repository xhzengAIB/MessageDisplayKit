//
//  XHEmotionSectionBar.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XHEmotionSectionBarDelegate <NSObject>

- (void)didSelecteEmotionManager:(XHEmotionManager *)emotionManager atSection:(NSInteger)section;

@end

@interface XHEmotionSectionBar : UIView

@property (nonatomic, weak) id <XHEmotionSectionBarDelegate> delegate;

@property (nonatomic, strong) NSArray *emotionManagers;

- (void)reloadData;

@end
