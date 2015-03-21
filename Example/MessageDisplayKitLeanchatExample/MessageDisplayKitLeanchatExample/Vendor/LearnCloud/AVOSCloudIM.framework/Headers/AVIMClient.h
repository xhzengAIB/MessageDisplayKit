//
//  AVIM.h
//  AVOSCloudIM
//
//  Created by Qihe Bian on 12/4/14.
//  Copyright (c) 2014 LeanCloud Inc. All rights reserved.
//

#import "AVIMCommon.h"
#import "AVIMSignature.h"

@class AVIMConversation;
@class AVIMMessage;
@class AVIMTypedMessage;
@class AVIMConversationQuery;
@protocol AVIMClientDelegate;

typedef enum : NSUInteger {
    AVIMClientStatusNone,
    AVIMClientStatusOpening,
    AVIMClientStatusOpened,
    AVIMClientStatusPaused,
    AVIMClientStatusResuming,
    AVIMClientStatusClosing,
    AVIMClientStatusClosed
} AVIMClientStatus;

typedef uint64_t AVIMConversationOption;
enum : AVIMConversationOption {
    AVIMConversationOptionNone = 0,
    AVIMConversationOptionTransient = 1 << 0,
};

@interface AVIMClient : NSObject
@property(nonatomic, weak)id<AVIMClientDelegate> delegate;
@property(nonatomic, weak)id<AVIMSignatureDataSource> signatureDataSource;
@property(nonatomic, readonly)NSString *clientId;
@property(nonatomic, readonly)AVIMClientStatus status;
/*!
 开启某个账户的聊天
 @param clientId - 操作发起人的 id，以后使用该账户的所有聊天行为，都由此人发起。
 @param callback － 聊天开启之后的回调
 @return None.
 */
- (void)openWithClientId:(NSString *)clientId
                callback:(AVIMBooleanResultBlock)callback;

/*!
 结束某个账户的聊天
 @param callback － 聊天关闭之后的回调
 @return None.
 */
- (void)closeWithCallback:(AVIMBooleanResultBlock)callback;

/*!
 创建一个新的用户对话。
 在单聊的场合，传入对方一个 clientId 即可；群聊的时候，支持同时传入多个 clientId 列表
 @param name - 会话名称。
 @param clientIds - 聊天参与者（发起人除外）的 clientId 列表。
 @param callback － 对话建立之后的回调
 @return None.
 */
- (void)createConversationWithName:(NSString *)name
                         clientIds:(NSArray *)clientIds
                          callback:(AVIMConversationResultBlock)callback;

/*!
 创建一个新的用户对话。
 在单聊的场合，传入对方一个 clientId 即可；群聊的时候，支持同时传入多个 clientId 列表
 @param name - 会话名称。
 @param clientIds - 聊天参与者（发起人除外）的 clientId 列表。
 @param attributes - 会话的自定义属性。
 @param options － 可选参数，可以使用或 “|” 操作表示多个选项
 @param callback － 对话建立之后的回调
 @return None.
 */
- (void)createConversationWithName:(NSString *)name
                         clientIds:(NSArray *)clientIds
                        attributes:(NSDictionary *)attributes
                           options:(AVIMConversationOption)options
                          callback:(AVIMConversationResultBlock)callback;

/*!
 构造一个对话查询对象
 @return 对话查询对象.
 */
- (AVIMConversationQuery *)conversationQuery;

@end

@protocol AVIMClientDelegate <NSObject>
@optional
/*!
 当前聊天状态被暂停，常见于网络断开时触发。
 */
- (void)imClientPaused:(AVIMClient *)imClient;
/*!
 当前聊天状态开始恢复，常见于网络断开后开始重新连接。
 */
- (void)imClientResuming:(AVIMClient *)imClient;
/*!
 当前聊天状态已经恢复，常见于网络断开后重新连接上。
 */
- (void)imClientResumed:(AVIMClient *)imClient;

/*!
 接收到新的普通消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message;

/*!
 接收到新的富媒体消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message;

/*!
 消息已投递给对方。
 @param conversation － 所属对话
 @param message - 具体的消息
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message;

/*!
 对话中有新成员加入的通知。
 @param conversation － 所属对话
 @param clientIds - 加入的新成员列表
 @param clientId - 邀请者的 id
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation membersAdded:(NSArray *)clientIds byClientId:(NSString *)clientId;
/*!
 对话中有成员离开的通知。
 @param conversation － 所属对话
 @param clientIds - 离开的成员列表
 @param clientId - 操作者的 id
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation membersRemoved:(NSArray *)clientIds byClientId:(NSString *)clientId;

/*!
 被邀请加入对话的通知。
 @param conversation － 所属对话
 @param clientId - 邀请者的 id
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation invitedByClientId:(NSString *)clientId;

/*!
 从对话中被移除的通知。
 @param conversation － 所属对话
 @param clientId - 操作者的 id
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation kickedByClientId:(NSString *)clientId;

@end
