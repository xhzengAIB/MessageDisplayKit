//
//  AVIMTextMessage.h
//  AVOSCloudIM
//
//  Created by Qihe Bian on 1/12/15.
//  Copyright (c) 2015 LeanCloud Inc. All rights reserved.
//

#import "AVIMTypedMessage.h"

@interface AVIMTextMessage : AVIMTypedMessage <AVIMTypedMessageSubclassing>

/*!
 创建文本消息。
 @param text － 消息文本.
 @param attributes － 用户附加属性
 */
+ (instancetype)messageWithText:(NSString *)text
                     attributes:(NSDictionary *)attributes;
@end
