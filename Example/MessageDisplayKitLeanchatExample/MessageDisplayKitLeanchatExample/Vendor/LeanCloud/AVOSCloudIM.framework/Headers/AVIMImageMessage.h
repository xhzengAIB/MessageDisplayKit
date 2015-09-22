//
//  AVIMImageMessage.h
//  AVOSCloudIM
//
//  Created by Qihe Bian on 1/12/15.
//  Copyright (c) 2015 LeanCloud Inc. All rights reserved.
//

#import "AVIMTypedMessage.h"

@interface AVIMImageMessage : AVIMTypedMessage <AVIMTypedMessageSubclassing>
@property(nonatomic, readonly)uint width;  //宽度，单位：像素
@property(nonatomic, readonly)uint height;  //高度，单位：像素
@property(nonatomic, readonly)uint64_t size;  //文件大小，单位：字节
@property(nonatomic, strong, readonly)NSString *format;  //格式，如：png，jpg等

@end
