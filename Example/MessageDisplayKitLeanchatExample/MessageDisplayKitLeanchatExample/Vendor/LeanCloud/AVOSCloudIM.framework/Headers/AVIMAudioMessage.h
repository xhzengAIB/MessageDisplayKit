//
//  AVIMAudioMessage.h
//  AVOSCloudIM
//
//  Created by Qihe Bian on 1/12/15.
//  Copyright (c) 2015 LeanCloud Inc. All rights reserved.
//

#import "AVIMTypedMessage.h"

@interface AVIMAudioMessage : AVIMTypedMessage <AVIMTypedMessageSubclassing>
@property(nonatomic, readonly)uint64_t size;  //文件大小，单位：字节
@property(nonatomic, readonly)float duration; //时长，单位：秒
@property(nonatomic, strong, readonly)NSString *format;  //格式，如：mp3，aac等

@end
