//
//  XHMessageTableViewController.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHMessageTableView.h"
#import "XHMessageInputView.h"


@protocol XHMessageTableViewControllerDelegate <NSObject>

@required

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date;
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date;
- (void)didSendVideo:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date;
- (void)didSendVioce:(NSString *)viocePath fromSender:(NSString *)sender onDate:(NSDate *)date;

- (XHBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling;

@end

@protocol XHMessageTableViewControllerDataSource <NSObject>

@required

- (id<XHMessageModel>)messageForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface XHMessageTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, XHMessageTableViewControllerDelegate, XHMessageTableViewControllerDataSource, XHMessageInputViewDelegate>

@property (nonatomic, weak) id <XHMessageTableViewControllerDelegate> delegate;

@property (nonatomic, weak) id <XHMessageTableViewControllerDataSource> dataSource;

/**
 *  数据源，显示多少消息
 */
@property (nonatomic, strong) NSMutableArray *messages;

/**
 *  消息的主体，默认为nil
 */
@property (nonatomic, copy) NSString *messageSender;

/**
 *  用于显示消息的TableView
 */
@property (nonatomic, weak, readonly) XHMessageTableView *messageTableView;

/**
 *  用于显示发送消息类型控制的工具条，在底部
 */
@property (nonatomic, weak, readonly) XHMessageInputView *messageInputView;

#pragma mark - Message View Controller Default stup
/**
 *  是否允许手势关闭键盘，默认是允许
 */
@property (nonatomic, assign) BOOL allowsPanToDismissKeyboard; // default is YES

/**
 *  是否允许发送语音
 */
@property (nonatomic, assign) BOOL allowsSendVoice; // default is YES

/**
 *  是否允许发送多媒体
 */
@property (nonatomic, assign) BOOL allowsSendMultiMedia; // default is YES

/**
 *  是否支持发送表情
 */
@property (nonatomic, assign) BOOL allowsSendFace; // default is YES

/**
 *  输入框的样式，默认为扁平化
 */
@property (nonatomic, assign) XHMessageInputViewStyle inputViewStyle;

#pragma mark - DataSource Change
/**
 *  添加一条新的消息
 *
 *  @param addedMessage 添加的目标消息对象
 */
- (void)addMessage:(XHMessage *)addedMessage;

/**
 *  删除一条已存在的消息
 *
 *  @param reomvedMessage 删除的目标消息对象
 */
- (void)removeMessage:(XHMessage *)reomvedMessage;

/**
 *  插入旧消息数据到头部，仿微信的做法
 *
 *  @param oldMessages 目标的旧消息数据
 */
- (void)insertOldMessages:(NSArray *)oldMessages;

#pragma mark - Messages view controller
/**
 *  完成发送消息的函数
 */
- (void)finishSendMessage;

/**
 *  设置View、tableView的背景颜色
 *
 *  @param color 背景颜色
 */
- (void)setBackgroundColor:(UIColor *)color;

/**
 *  是否滚动到底部
 *
 *  @param animated YES Or NO
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

/**
 *  滚动到哪一行
 *
 *  @param indexPath 目标行数变量
 *  @param position  UITableViewScrollPosition 整形常亮
 *  @param animated  是否滚动动画，YES or NO
 */
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
			  atScrollPosition:(UITableViewScrollPosition)position
					  animated:(BOOL)animated;

@end
