//
//  AVSession.h
//  paas
//
//  Created by yang chaozhong on 5/6/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVSignature.h"
#import "AVConstants.h"
#import "AVGroup.h"
#import "AVMessage.h"

@protocol AVSessionDelegate;

typedef enum : NSUInteger {
    AVPeerStatusOffline = 1,
    AVPeerStatusOnline,
} AVPeerStatus;

@interface AVSession : NSObject

@property (nonatomic, weak) id <AVSessionDelegate> sessionDelegate;
@property (nonatomic, weak) id <AVSignatureDelegate> signatureDelegate;

/*!
 *  自身的peerId
 */
@property (nonatomic, strong) NSString *peerId;

/*!
 *  发送消息Timeout，默认10秒
 */
@property (nonatomic, assign) int messageTimeout;

/*!
 *  通过peerId获取已经打开的session
 *  @param peerId session打开时使用的peerId
 *  @return 返回使用peerId打开的session，不存在或session已关闭返回nil
 */
+ (AVSession *)getSessionWithPeerId:(NSString *)peerId;

/*!
 *  通过peerId获取已经打开的session
 *  @param peerId session打开时使用的peerId
 *  @param createAndOpen 如果不存在是否创建
 *  @return 返回使用peerId打开的session，不存在或session已关闭返回nil
 */
+ (AVSession *)getSessionWithPeerId:(NSString *)peerId
         createAndOpenWhenNotExists:(BOOL)createAndOpen
                    sessionDelegate:(id<AVSessionDelegate>)sessionDelegate
                  signatureDelegate:(id<AVSignatureDelegate>)signatureDelegate;

/*!
 *  打开 session
 *  @param peerId 用户自己的peer id
 */
- (void)openWithPeerId:(NSString *)peerId;

/*!
 *  打开 session 并关注一组 peer id 数组
 *  @param peerId 用户自己的peer id
 *  @param peerIds 关注的peer id 数组
 */
- (void)openWithPeerId:(NSString *)peerId watchedPeerIds:(NSArray *)peerIds;

- (void)open:(NSString *)selfId withPeerIds:(NSArray *)peerIds AVDeprecated("2.6.4");

/*!
 *  增量关注一组 peerIds
 *  @param peerIds peer id 数组
 */
- (void)watchPeerIds:(NSArray *)peerIds;
- (void)watchPeerIds:(NSArray *)peerIds callback:(AVBooleanResultBlock)callback;

- (BOOL)watchPeers:(NSArray *)peerIds  AVDeprecated("2.6.4");

/*!
 *  取消关注一组 peerIds
 *  @param peerIds peer id 数组
 */
- (void)unwatchPeerIds:(NSArray *)peerIds;
- (void)unwatchPeerIds:(NSArray *)peerIds callback:(AVBooleanResultBlock)callback;

- (void)unwatchPeers:(NSArray *)peerIds AVDeprecated("2.6.4");

/*!
 *  发送消息
 *  @param message 消息对象
 */
- (void)sendMessage:(AVMessage *)message;

/*!
 *  发送消息
 *  @param message 消息对象
 *  @param transient 设置为 YES, 当且仅当某个 peer 在线才会收到该条消息，且该条消息既不会存为离线消息，也不会通过消息推送系统发出去.
 *         如果设置为 NO, 则该条消息会设法通过各种途径发到 peer 客户端，比如即时通信、推送、离线消息等。
 */
- (void)sendMessage:(AVMessage *)message transient:(BOOL)transient;

/*!
 *  发送消息
 *  @param message 消息对象
 *  @param requestReceipt 是否需要回执。
 */
- (void)sendMessage:(AVMessage *)message requestReceipt:(BOOL)requestReceipt;

- (void)sendMessage:(NSString *)message isTransient:(BOOL)transient toPeerIds:(NSArray *)peerIds AVDeprecated("2.6.4");

/*!
 *  关闭 session
 */
- (void)close;

/*!
 *  判断 session 是否 open
 *  @return 如果 open，则返回 YES， 否则返回 NO
 */
- (BOOL)isOpen;

/*!
 *  判断 session 是否 paused
 *  @discussion 这里的 paused 是指无网络连接、且已经 open 的 session 所处状态。
 *  @return 如果 paused，则返回 YES， 否则返回 NO
 */
- (BOOL)isPaused;

/*!
 *  判断某个 peerId 是否 online
 *  @param peerId 用户的 peer id
 *  @return 如果 online，则返回 YES， 否则返回 NO
 */
- (BOOL)peerIdIsOnline:(NSString *)peerId;

- (BOOL)isOnline:(NSString *)peerId AVDeprecated("2.6.4");

/*!
 *  判断是否 watch 了某个用户
 *  @param peerId 用户的 peer id
 *  @return 如果已经 watch，返回 YES，否则返回 NO
 */
- (BOOL)peerIdIsWatching:(NSString *)peerId;

- (BOOL)isWatching:(NSString *)peerId AVDeprecated("2.6.4");

/*!
 *  获取自己的 peer id
 *  @return 用户的 peer id
 */
- (NSString *)getSelfPeerId AVDeprecated("2.6.4");

/*!
 *  获取已经 watch 的那部分用户中，当前在线的用户
 *  @return 在线peerId列表
 */
- (NSArray *)onlinePeerIds;

- (NSArray *)getOnlinePeers AVDeprecated("2.6.4");

/*!
 *  获取传入的用户数组中，当前在线的用户
 *  @param peerIds 用户 peer id 数组
 *  @param callback 回调，这个 callback 应该包含如下参数签名:(NSArray *objects, NSError *error)
 */
- (void)queryOnlinePeerIdsInPeerIds:(NSArray *)peerIds callback:(AVArrayResultBlock)callback;

- (void)getOnlinePeers:(NSArray *)peerIds withBlock:(AVArrayResultBlock)block AVDeprecated("2.6.4");

/*!
 *  获取已经 watch 的用户列表
 *  @return peerId列表
 */
- (NSArray *)watchedPeerIds;

- (NSArray *)getAllPeers AVDeprecated("2.6.4");

/*!
 *  根据groupId构建一个AVGroup对象
 *  @return 如果已经存在groupId的group对象，则返回该对象，否则新建一个对象
 */
- (AVGroup *)getGroup:(NSString *)groupId AVDeprecated("2.6.4");

@end

@protocol AVSessionDelegate <NSObject>
@optional
- (void)sessionOpened:(AVSession *)session;
- (void)sessionPaused:(AVSession *)session;
- (void)sessionResumed:(AVSession *)session;
- (void)sessionFailed:(AVSession *)session error:(NSError *)error;
- (void)session:(AVSession *)session didReceiveMessage:(AVMessage *)message;
- (void)session:(AVSession *)session didReceiveStatus:(AVPeerStatus)status peerIds:(NSArray *)peerIds;
/*!
 *  消息发送成功
 *  回调表示消息已经成功发送到服务器
 */
- (void)session:(AVSession *)session messageSendFinished:(AVMessage *)message;

/*!
 *  消息发送失败
 *  回调表示消息长时间没得到服务器确认或网络故障
 */
- (void)session:(AVSession *)session messageSendFailed:(AVMessage *)message error:(NSError *)error;

/*!
 *  消息到达接收方，需要消息设置requestReceipt为YES，默认为NO
 *  回调表示消息已经发送到接收方
 */
- (void)session:(AVSession *)session messageArrived:(AVMessage *)message;


- (void)onSessionOpen:(AVSession *)session AVDeprecated("2.6.4");
- (void)onSessionPaused:(AVSession *)session AVDeprecated("2.6.4");
- (void)onSessionResumed:(AVSession *)seesion AVDeprecated("2.6.4");
- (void)onSessionMessage:(AVSession *)session message:(NSString *)message peerId:(NSString *)peerId AVDeprecated("2.6.4");
- (void)onSessionMessageSent:(AVSession *)session message:(NSString *)message toPeerIds:(NSArray *)peerIds AVDeprecated("2.6.4");
- (void)onSessionMessageFailure:(AVSession *)session message:(NSString *)message toPeerIds:(NSArray *)peerIds AVDeprecated("2.6.4");
- (void)onSessionStatusOnline:(AVSession *)session peers:(NSArray *)peerIds AVDeprecated("2.6.4");
- (void)onSessionStatusOffline:(AVSession *)session peers:(NSArray *)peerId AVDeprecated("2.6.4");
- (void)onSessionError:(AVSession *)session withException:(NSException *)exception AVDeprecated("2.6.4");

@end