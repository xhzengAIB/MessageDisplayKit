//
//  AVIMVideoMessage.h
//  AVOSCloudIM
//
//  Created by Qihe Bian on 1/12/15.
//  Copyright (c) 2015 LeanCloud Inc. All rights reserved.
//

#import "AVIMTypedMessage.h"

@interface AVIMVideoMessage : AVIMTypedMessage <AVIMTypedMessageSubclassing>
@property(nonatomic, readonly)uint64_t size;  //文件大小，单位：字节
@property(nonatomic, readonly)float duration;  //时长，单位：秒
@property(nonatomic, strong, readonly)NSString *format;  //格式，如：mp4，m4v等

/*!
 使用本地文件创建视频消息。
 @param text － 消息文本.
 @param attachedFilePath － 文件路径
 @param attributes － 用户附加属性
 */
+ (instancetype)messageWithText:(NSString *)text
               attachedFilePath:(NSString *)attachedFilePath
                     attributes:(NSDictionary *)attributes;
@end
