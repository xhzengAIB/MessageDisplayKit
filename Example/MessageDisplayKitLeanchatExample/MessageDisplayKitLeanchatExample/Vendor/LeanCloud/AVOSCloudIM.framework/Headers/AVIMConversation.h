//
//  AVIMConversation.h
//  AVOSCloudIM
//
//  Created by Qihe Bian on 12/4/14.
//  Copyright (c) 2014 LeanCloud Inc. All rights reserved.
//

#import "AVIMCommon.h"
#import "AVIMMessage.h"
#import "AVIMTypedMessage.h"
#import "AVIMConversationUpdateBuilder.h"
#import "AVIMKeyedConversation.h"

@class AVIMClient;

typedef uint64_t AVIMMessageSendOption;
enum : AVIMMessageSendOption {
    AVIMMessageSendOptionNone = 0,
    AVIMMessageSendOptionTransient = 1 << 0,
    AVIMMessageSendOptionRequestReceipt = 1 << 1,
};

@interface AVIMConversation : NSObject

@property (nonatomic, strong, readonly) NSString     *conversationId; // 对话 id
@property (nonatomic, strong, readonly) NSString     *creator;        // 创建者 id
@property (nonatomic, strong, readonly) NSDate       *createAt;       // 创建时间
@property (nonatomic, strong, readonly) NSDate       *updateAt;       // 最后更新时间
@property (nonatomic, strong, readonly) NSDate       *lastMessageAt;  // 对话中最后一条消息的发送时间
@property (nonatomic, strong, readonly) NSString     *name;           // 对话名字
@property (nonatomic, strong, readonly) NSArray      *members;        // 对话参与者列表
@property (nonatomic, strong, readonly) NSDictionary *attributes;     // 自定义属性
@property (nonatomic, assign, readonly) BOOL          transient;      // 是否为临时会话（开放群组）
@property (nonatomic, assign, readonly) BOOL          muted;          // 静音状态
@property (nonatomic, weak, readonly)   AVIMClient   *imClient;       // 所属的 client

/*!
 生成一个新的 AVIMConversationUpdateBuilder 实例。
 @return 新的 AVIMConversationUpdateBuilder 实例.
 */
- (AVIMConversationUpdateBuilder *)newUpdateBuilder;

/*!
 创建一个 AVIMKeyedConversation 对象。
 @return AVIMKeyedConversation 对象。
 */
- (AVIMKeyedConversation *)keyedConversation;

/*!
 拉取服务器最新数据。
 @param callback － 结果回调
 @return None.
 */
- (void)fetchWithCallback:(AVIMBooleanResultBlock)callback;

/*!
 发送更新。
 @param updateDict － 需要更新的数据，可通过 AVIMConversationUpdateBuilder 生成
 @param callback － 结果回调
 @return None.
 */
- (void)update:(NSDictionary *)updateDict
      callback:(AVIMBooleanResultBlock)callback;

/*!
 加入对话。
 @param callback － 结果回调
 @return None.
 */
- (void)joinWithCallback:(AVIMBooleanResultBlock)callback;

/*!
 离开对话。
 @param callback － 结果回调
 @return None.
 */
- (void)quitWithCallback:(AVIMBooleanResultBlock)callback;

/*!
 静音，不再接收此对话的离线推送。
 @param callback － 结果回调
 @return None.
 */
- (void)muteWithCallback:(AVIMBooleanResultBlock)callback;

/*!
 取消静音，开始接收此对话的离线推送。
 @param callback － 结果回调
 @return None.
 */
- (void)unmuteWithCallback:(AVIMBooleanResultBlock)callback;

/*!
 标记该会话已读。
 将服务端该会话的未读消息数置零。
 */
- (void)markAsReadInBackground;

/*!
 邀请新成员加入对话。
 @param clientIds － 成员列表
 @param callback － 结果回调
 @return None.
 */
- (void)addMembersWithClientIds:(NSArray *)clientIds
                       callback:(AVIMBooleanResultBlock)callback;

/*!
 从对话踢出部分成员。
 @param clientIds － 成员列表
 @param callback － 结果回调
 @return None.
 */
- (void)removeMembersWithClientIds:(NSArray *)clientIds
                          callback:(AVIMBooleanResultBlock)callback;

/*!
 查询成员人数（开放群组即为在线人数）。
 @param callback － 结果回调
 @return None.
 */
- (void)countMembersWithCallback:(AVIMIntegerResultBlock)callback;

/*!
 往对话中发送消息。
 @param message － 消息对象
 @param callback － 结果回调
 @return None.
 */
- (void)sendMessage:(AVIMMessage *)message
           callback:(AVIMBooleanResultBlock)callback;

/*!
 往对话中发送消息。
 @param message － 消息对象
 @param progressBlock - 发送进度回调。仅对文件上传有效，发送文本消息时不进行回调。
 @param callback － 结果回调
 @return None.
 */
- (void)sendMessage:(AVIMMessage *)message
      progressBlock:(AVProgressBlock)progressBlock
           callback:(AVIMBooleanResultBlock)callback;

/*!
 往对话中发送消息。
 @param message － 消息对象
 @param options － 可选参数，可以使用或 “|” 操作表示多个选项
 @param callback － 结果回调
 @return None.
 */
- (void)sendMessage:(AVIMMessage *)message
            options:(AVIMMessageSendOption)options
           callback:(AVIMBooleanResultBlock)callback;

/*!
 往对话中发送消息。
 @param message － 消息对象
 @param options － 可选参数，可以使用或 “|” 操作表示多个选项
 @param progressBlock - 发送进度回调。仅对文件上传有效，发送文本消息时不进行回调。
 @param callback － 结果回调
 @return None.
 */
- (void)sendMessage:(AVIMMessage *)message
            options:(AVIMMessageSendOption)options
      progressBlock:(AVProgressBlock)progressBlock
           callback:(AVIMBooleanResultBlock)callback;

/*!
 从服务端拉取该会话的最近 limit 条消息。
 @param limit 返回结果的数量，默认 20 条，最多 1000 条。
 @param callback 查询结果回调。
 @return None。
 */
- (void)queryMessagesFromServerWithLimit:(NSUInteger)limit
                                callback:(AVIMArrayResultBlock)callback;

/*!
 从缓存中查询该会话的最近 limit 条消息。
 @param limit 返回结果的数量，默认 20 条，最多 1000 条。
 @return 消息数组。
 */
- (NSArray *)queryMessagesFromCacheWithLimit:(NSUInteger)limit;

/*!
 获取该会话的最近 limit 条消息。
 @param limit 返回结果的数量，默认 20 条，最多 1000 条。
 @param callback 查询结果回调。
 @return None。
 */
- (void)queryMessagesWithLimit:(NSUInteger)limit
                      callback:(AVIMArrayResultBlock)callback;

/*!
 查询历史消息，获取某条消息或指定时间戳之前的 limit 条消息。
 @param messageId 此消息以前的消息。
 @param timestamp 此时间以前的消息。
 @param limit 返回结果的数量，默认 20 条，最多 1000 条。
 @param callback 查询结果回调。
 @return None。
 */
- (void)queryMessagesBeforeId:(NSString *)messageId
                    timestamp:(int64_t)timestamp
                        limit:(NSUInteger)limit
                     callback:(AVIMArrayResultBlock)callback;

@end
