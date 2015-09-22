//
//  AVIMMessage.h
//  AVOSCloudIM
//
//  Created by Qihe Bian on 12/4/14.
//  Copyright (c) 2014 LeanCloud Inc. All rights reserved.
//

#import "AVIMCommon.h"

typedef enum : int8_t {
    AVIMMessageIOTypeIn = 1,
    AVIMMessageIOTypeOut,
} AVIMMessageIOType;

typedef enum : int8_t {
    AVIMMessageStatusNone = 0,
    AVIMMessageStatusSending = 1,
    AVIMMessageStatusSent,
    AVIMMessageStatusDelivered,
    AVIMMessageStatusFailed,
} AVIMMessageStatus;

@interface AVIMMessage : NSObject <NSCopying, NSCoding>

@property (nonatomic, readonly) AVIMMessageIOType ioType; // 表示接收和发出的消息
@property (nonatomic, assign) AVIMMessageStatus status;   // 表示消息状态
@property (nonatomic, strong) NSString *messageId;        // 消息 id
@property (nonatomic, strong) NSString *clientId;         // 消息发送/接收方 id
@property (nonatomic, strong) NSString *conversationId;   // 消息所属对话的 id
@property (nonatomic, strong) NSString *content;          // 消息文本
@property (nonatomic, assign) int64_t sendTimestamp;      // 发送时间（精确到毫秒）
@property (nonatomic, assign) int64_t deliveredTimestamp; // 接收时间（精确到毫秒）
@property (nonatomic, readonly) BOOL transient;           // 是否是暂态消息

/*!
 创建文本消息。
 @param content － 消息文本.
 */
+ (instancetype)messageWithContent:(NSString *)content;

@end
