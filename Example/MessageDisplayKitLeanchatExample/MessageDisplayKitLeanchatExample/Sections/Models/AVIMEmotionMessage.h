//
//  AVIMEmotionMessage.h
//  MessageDisplayKitLeanchatExample
//
//  Created by lzw on 15/3/22.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import <AVOSCloudIM/AVOSCloudIM.h>

#define kAVIMMessageMediaTypeEmotion 1

@interface AVIMEmotionMessage : AVIMTypedMessage<AVIMTypedMessageSubclassing>

+ (instancetype)messageWithText:(NSString *)text
                     attributes:(NSDictionary *)attributes;

@end
