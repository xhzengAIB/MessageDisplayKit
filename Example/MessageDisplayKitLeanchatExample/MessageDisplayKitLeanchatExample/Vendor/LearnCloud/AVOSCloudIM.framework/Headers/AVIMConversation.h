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

@class AVIMClient;

typedef uint64_t AVIMMessageSendOption;
enum : AVIMMessageSendOption {
    AVIMMessageSendOptionNone = 0,
    AVIMMessageSendOptionTransient = 1 << 0,
    AVIMMessageSendOptionRequestReceipt = 1 << 1,
};

@interface AVIMConversation : NSObject
@property(nonatomic, strong, readonly)NSString *conversationId; // 对话 id
@property(nonatomic, strong, readonly)NSString *creator; // 创建者 id
@property(nonatomic, strong, readonly)NSString *name;           // 对话名字
@property(nonatomic, strong, readonly)NSArray *members;         // 对话参与者列表
@property(nonatomic, readonly)BOOL muted;         // 静音状态
@property(nonatomic, readonly)BOOL transient; // 是否为临时会话（开放群组）
@property(nonatomic, strong, readonly)NSDictionary *attributes; // 自定义属性
@property(nonatomic, weak, readonly)AVIMClient *imClient;         // 所属的 AVIM

/*!
 生成一个新的 AVIMConversationUpdateBuilder 实例。
 @return 新的 AVIMConversationUpdateBuilder 实例.
 */
- (AVIMConversationUpdateBuilder *)newUpdateBuilder;

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
 @param options － 可选参数，可以使用或 “|” 操作表示多个选项
 @param callback － 结果回调
 @return None.
 */
- (void)sendMessage:(AVIMMessage *)message
            options:(AVIMMessageSendOption)options
           callback:(AVIMBooleanResultBlock)callback;

/*!
 查询历史消息。
 @param messageId 此消息以前的消息
 @param timestamp 此时间以前的消息
 @param limit 返回结果数量，0为默认值，默认值为20，最大1000
 @param callback 查询结果回调
 @return None.
 */
- (void)queryMessagesBeforeId:(NSString *)messageId
                    timestamp:(int64_t)timestamp
                        limit:(NSUInteger)limit
                     callback:(AVIMArrayResultBlock)callback;
@end
