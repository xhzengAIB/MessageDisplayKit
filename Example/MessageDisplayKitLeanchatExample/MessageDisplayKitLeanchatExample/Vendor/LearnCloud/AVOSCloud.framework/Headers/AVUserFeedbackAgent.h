//
//  AVUserFeedbackAgent.h
//  paas
//
//  Created by yang chaozhong on 4/22/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVConstants.h"
@interface AVUserFeedbackAgent : NSObject

#pragma mark - methods

/**
 *  AVUserFeedbackAgent 实例
 */
+(instancetype)sharedInstance;

/**
 *  打开默认用户反馈界面
 *  @param viewController 默认的用户反馈界面将会展示在 viewController 之上，可以设置为当前的 viewController，比如 self。
 *  @param title 反馈标题
 *  @param contact 联系方式，邮箱或qq.
 */
- (void)showConversations:(UIViewController *)viewController title:(NSString *)title contact:(NSString *)contact;

/**
 *  从服务端同步反馈回复
 *  @param title 反馈标题, 当用户没有创建过用户反馈时，需要传入这个参数用于创建用户反馈。
 *  @param contact 联系方式，邮箱或qq。
 *  @param block 结果回调
 *  @discussion 可以在 block 中处理反馈数据 (AVUserFeedbackThread 数组)，然后将其传入自定义用户反馈界面。
 */
- (void)syncFeedbackThreadsWithBlock:(NSString *)title contact:(NSString *)contact block:(AVArrayResultBlock)block;

/**
 *  发送用户反馈
 *  @param content 同上，用户反馈内容。
 *  @param block 结果回调
 */
- (void)postFeedbackThread:(NSString *)content block:(AVIdResultBlock)block;

@end
