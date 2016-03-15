//
//  AVIMEmotionMessage.m
//  MessageDisplayKitLeanchatExample
//
//  Created by lzw on 15/3/22.
//  Copyright (c) 2015年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "AVIMEmotionMessage.h"

@implementation AVIMEmotionMessage

+(void)load{
    [self registerSubclass];
}

+ (AVIMMessageMediaType)classMediaType{
    return kAVIMMessageMediaTypeEmotion;
}

+ (instancetype)messageWithText:(NSString *)text
                     attributes:(NSDictionary *)attributes{
    AVIMEmotionMessage* message=[[self alloc] init];
    message.mediaType=[self classMediaType];
    message.text=text;
    message.attributes=attributes;
    return message;
}

@end
