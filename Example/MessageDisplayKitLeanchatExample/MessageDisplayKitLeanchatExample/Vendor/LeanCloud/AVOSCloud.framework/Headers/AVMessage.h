//
//  AVMessage.h
//  AVOS
//
//  Created by Qihe Bian on 8/6/14.
//
//

#import <Foundation/Foundation.h>

@class AVSession;
@class AVGroup;
typedef enum : NSUInteger {
    AVMessageTypePeerIn = 1,
    AVMessageTypePeerOut,
    AVMessageTypeGroupIn,
    AVMessageTypeGroupOut,
} AVMessageType;

@interface AVMessage : NSObject <NSCopying>
@property(nonatomic)AVMessageType type;
@property(nonatomic, strong)NSString *payload;
@property(nonatomic, strong)NSString *fromPeerId;
@property(nonatomic, strong)NSString *toPeerId;
@property(nonatomic, strong)NSString *groupId;
@property(nonatomic)int64_t timestamp;
@property(nonatomic)int64_t receiptTimestamp;
@property(nonatomic)BOOL offline;

/*!
 *  构造一个发送到group的message对象
 *  @param group 要发送的group
 *  @param payload 消息载体
 *  @return message 对象
 */
+ (AVMessage *)messageForGroup:(AVGroup *)group payload:(NSString *)payload;

/*!
 *  构造一个发送给 toPeerId 的message对象
 *  @param session 服务器会话
 *  @param toPeerId 要发往的 peerId
 *  @param payload 消息载体
 *  @return message 对象
 */
+ (AVMessage *)messageForPeerWithSession:(AVSession *)session
                                toPeerId:(NSString *)toPeerId
                                 payload:(NSString *)payload;

@end
