//
//  XHEmotionManagerView.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHEmotionManager.h"
#import "XHMacro.h"

#define kXHEmotionPerRowItemCount (kIsiPad ? 10 : 4)
#define kXHEmotionPageControlHeight 38
#define kXHEmotionSectionBarHeight 36

@protocol XHEmotionManagerViewDelegate <NSObject>

@optional
/**
 *  第三方gif表情被点击的回调事件
 *
 *  @param emotion   被点击的gif表情Model
 *  @param indexPath 被点击的位置
 */
- (void)didSelecteEmotion:(XHEmotion *)emotion atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol XHEmotionManagerViewDataSource <NSObject>

@required
/**
 *  通过数据源获取统一管理一类表情的回调方法
 *
 *  @param column 列数
 *
 *  @return 返回统一管理表情的Model对象
 */
- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column;

/**
 *  通过数据源获取一系列的统一管理表情的Model数组
 *
 *  @return 返回包含统一管理表情Model元素的数组
 */
- (NSArray *)emotionManagersAtManager;

/**
 *  通过数据源获取总共有多少类gif表情
 *
 *  @return 返回总数
 */
- (NSInteger)numberOfEmotionManagers;

@end

@interface XHEmotionManagerView : UIView

@property (nonatomic, weak) id <XHEmotionManagerViewDelegate> delegate;

@property (nonatomic, weak) id <XHEmotionManagerViewDataSource> dataSource;

/**
 *  是否显示表情商店的按钮
 */
@property (nonatomic, assign) BOOL isShowEmotionStoreButton; // default is YES

/**
 *  根据数据源刷新UI布局和数据
 */
- (void)reloadData;


@end
