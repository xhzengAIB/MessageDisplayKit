//
//  AVHistoryMessageQuery.h
//  AVOS
//
//  Created by Qihe Bian on 10/21/14.
//
//

#import <Foundation/Foundation.h>
#import "AVHistoryMessage.h"
#import "AVConstants.h"

@interface AVHistoryMessageQuery : NSObject
@property(nonatomic)int64_t timestamp;
@property(nonatomic)int limit;

/**
 *  构造通用 AVHistoryMessageQuery
 *  @return query 对象
 */
+ (instancetype)query;

/**
 *  构造通用 AVHistoryMessageQuery
 *  @param timestamp 截止时间，0表示不指定
 *  @param limit 限制返回结果数量，0表示不指定
 *  @return query 对象
 */
+ (instancetype)queryWithTimestamp:(int64_t)timestamp limit:(int)limit;

/**
 *  构造指定 conversationId 的 AVHistoryMessageQuery
 *  @param conversationId 对话Id
 *  @return query 对象
 */
+ (instancetype)queryWithConversationId:(NSString *)conversationId;

/**
 *  构造指定 conversationId 的 AVHistoryMessageQuery
 *  @param conversationId 对话Id
 *  @param timestamp 截止时间，0表示不指定
 *  @param limit 限制返回结果数量，0表示不指定
 *  @return query 对象
 */
+ (instancetype)queryWithConversationId:(NSString *)conversationId timestamp:(int64_t)timestamp limit:(int)limit;

/**
 *  构造查询指定来源 peerId 的 AVHistoryMessageQuery
 *  @param fromPeerId 来源peerId
 *  @return query 对象
 */
+ (instancetype)queryWithFromPeerId:(NSString *)fromPeerId;

/**
 *  构造查询指定来源 peerId 的 AVHistoryMessageQuery
 *  @param fromPeerId 来源peerId
 *  @param timestamp 截止时间，0表示不指定
 *  @param limit 限制返回结果数量，0表示不指定
 *  @return query 对象
 */
+ (instancetype)queryWithFromPeerId:(NSString *)fromPeerId timestamp:(int64_t)timestamp limit:(int)limit;

/**
 *  构造查询两个 peerId 之间历史记录的 AVHistoryMessageQuery
 *  @param firstPeerId 参与对话的一个peerId
 *  @param secondPeerId 参与对话的另一个peerId
 *  @return query 对象
 */
+ (instancetype)queryWithFirstPeerId:(NSString *)firstPeerId secondPeerId:(NSString *)secondPeerId;

/**
 *  构造查询两个 peerId 之间历史记录的 AVHistoryMessageQuery
 *  @param firstPeerId 参与对话的一个peerId
 *  @param secondPeerId 参与对话的另一个peerId
 *  @param timestamp 截止时间，0表示不指定
 *  @param limit 限制返回结果数量，0表示不指定
 *  @return query 对象
 */
+ (instancetype)queryWithFirstPeerId:(NSString *)firstPeerId secondPeerId:(NSString *)secondPeerId timestamp:(int64_t)timestamp limit:(int)limit;

/**
 *  构造查询群组历史记录的 AVHistoryMessageQuery
 *  @param groupId 群组Id
 *  @return query 对象
 */
+ (instancetype)queryWithGroupId:(NSString *)groupId;

/**
 *  构造查询群组历史记录的 AVHistoryMessageQuery
 *  @param groupId 群组Id
 *  @param timestamp 截止时间，0表示不指定
 *  @param limit 限制返回结果数量，0表示不指定
 *  @return query 对象
 */
+ (instancetype)queryWithGroupId:(NSString *)groupId timestamp:(int64_t)timestamp limit:(int)limit;

/**
 *  开始查询
 *  @return 历史聊天记录数组，发生错误返回nil
 */
-(NSArray *)find;

/**
 *  开始查询
 *  @param error 发生错误通过error返回
 *  @return 历史聊天记录数组，发生错误返回nil
 */
-(NSArray *)find:(NSError **)error;

/**
 *  开始查询
 *  @param callback 结果回调
 */
-(void)findInBackgroundWithCallback:(AVArrayResultBlock)callback;
@end
