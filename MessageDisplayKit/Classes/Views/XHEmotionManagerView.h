//
//  XHEmotionManagerView.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHEmotionManager.h"

#define kXHEmotionPerRowItemCount 4
#define kXHEmotionPageControlHeight 38
#define kXHEmotionSectionBarHeight 35

@protocol XHEmotionManagerViewDelegate <NSObject>

@optional

- (void)didSelecteEmotion:(XHEmotion *)emotion atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol XHEmotionManagerViewDataSource <NSObject>

@required

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column;

- (NSArray *)emotionManagersAtManager;

- (NSInteger)numberOfEmotionManagers;

@end

@interface XHEmotionManagerView : UIView

@property (nonatomic, weak) id <XHEmotionManagerViewDelegate> delegate;

@property (nonatomic, weak) id <XHEmotionManagerViewDataSource> dataSource;

@property (nonatomic, assign) BOOL isShowEmotionStoreButton; // default is YES

- (void)reloadData;


@end
