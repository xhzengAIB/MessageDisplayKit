//
//  AVIMTypedMessage.h
//  AVOSCloudIM
//
//  Created by Qihe Bian on 1/8/15.
//  Copyright (c) 2014 LeanCloud Inc. All rights reserved.
//

#import "AVIMMessage.h"

typedef int8_t AVIMMessageMediaType;

//SDK定义的消息类型，自定义类型使用大于0的值
enum : AVIMMessageMediaType {
    kAVIMMessageMediaTypeNone = 0,
    kAVIMMessageMediaTypeText = -1,
    kAVIMMessageMediaTypeImage = -2,
    kAVIMMessageMediaTypeAudio = -3,
    kAVIMMessageMediaTypeVideo = -4,
    kAVIMMessageMediaTypeLocation = -5
};
@protocol AVIMTypedMessageSubclassing <NSObject>
@required
/*!
 子类实现此方法用于返回该类对应的消息类型
 @return 消息类型
 */
+ (AVIMMessageMediaType)classMediaType;
@end

@interface AVIMTypedMessage : AVIMMessage
@property(nonatomic)AVIMMessageMediaType mediaType;           //消息类型，可自定义
@property(nonatomic, strong)NSString *text;        // 消息文本
@property(nonatomic, strong)NSDictionary *attributes;  // 自定义属性
@property(nonatomic, strong, readonly)AVFile *file;  // 附件
@property(nonatomic, strong, readonly)AVGeoPoint *location;  // 位置

/*
 子类调用此方法进行注册，一般可在子类的 [+(void)load] 方法里面调用
 */
+ (void)registerSubclass;

@end
