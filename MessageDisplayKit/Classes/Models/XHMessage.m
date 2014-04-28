//
//  XHMessage.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessage.h"

@implementation XHMessage

- (instancetype)initWithText:(NSString *)text
                      sender:(NSString *)sender
                        date:(NSDate *)date {
    self = [super init];
    if (self) {
        self.text = text;
        
        self.sender = sender;
        self.date = date;
        
        self.messageMediaType = XHBubbleMessageText;
    }
    return self;
}

/**
 *  初始化图片类型的消息
 *
 *  @param photo          目标图片
 *  @param thumbnailUrl   目标图片在服务器的缩略图地址
 *  @param originPhotoUrl 目标图片在服务器的原图地址
 *  @param sender         发送者
 *  @param date           发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithPhoto:(UIImage *)photo
                 thumbnailUrl:(NSString *)thumbnailUrl
               originPhotoUrl:(NSString *)originPhotoUrl
                       sender:(NSString *)sender
                         date:(NSDate *)date {
    self = [super init];
    if (self) {
        self.photo = photo;
        self.thumbnailUrl = thumbnailUrl;
        self.originPhotoUrl = originPhotoUrl;
        
        self.sender = sender;
        self.date = date;
        
        self.messageMediaType = XHBubbleMessagePhoto;
    }
    return self;
}

/**
 *  初始化视频类型的消息
 *
 *  @param videoConverPhoto 目标视频的封面图
 *  @param videoPath        目标视频的本地路径，如果是下载过，或者是从本地发送的时候，会存在
 *  @param videoUrl         目标视频在服务器上的地址
 *  @param sender           发送者
 *  @param date             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVideoConverPhoto:(UIImage *)videoConverPhoto
                               videoPath:(NSString *)videoPath
                                videoUrl:(NSString *)videoUrl
                                  sender:(NSString *)sender
                                    date:(NSDate *)date {
    self = [super init];
    if (self) {
        self.videoConverPhoto = videoConverPhoto;
        self.videoPath = videoPath;
        self.videoUrl = videoUrl;
        
        self.sender = sender;
        self.date = date;
        
        self.messageMediaType = XHBubbleMessageVideo;
    }
    return self;
}

/**
 *  初始化语音类型的消息
 *
 *  @param viocePath 目标语音的本地路径
 *  @param vioceUrl  目标语音在服务器的地址
 *  @param sender    发送者
 *  @param date      发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithViocePath:(NSString *)viocePath
                         vioceUrl:(NSString *)vioceUrl
                           sender:(NSString *)sender
                             date:(NSDate *)date {
    self = [super init];
    if (self) {
        self.viocePath = viocePath;
        self.videoUrl = vioceUrl;
        
        self.sender = sender;
        self.date = date;
        
        self.messageMediaType = XHBubbleMessageVioce;
    }
    return self;
}

- (void)dealloc {
    _text = nil;
    
    _photo = nil;
    _thumbnailUrl = nil;
    _originPhotoUrl = nil;
    
    _videoConverPhoto = nil;
    _videoPath = nil;
    _videoUrl = nil;
    
    _viocePath = nil;
    _vioceUrl = nil;
    
    _avator = nil;
    _avatorUrl = nil;
    
    _sender = nil;
    
    _date = nil;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _text = [aDecoder decodeObjectForKey:@"text"];
        
        _photo = [aDecoder decodeObjectForKey:@"photo"];
        _thumbnailUrl = [aDecoder decodeObjectForKey:@"thumbnailUrl"];
        _originPhotoUrl = [aDecoder decodeObjectForKey:@"originPhotoUrl"];
        
        _videoConverPhoto = [aDecoder decodeObjectForKey:@"videoConverPhoto"];
        _videoPath = [aDecoder decodeObjectForKey:@"videoPath"];
        _videoUrl = [aDecoder decodeObjectForKey:@"videoUrl"];
        
        _viocePath = [aDecoder decodeObjectForKey:@"viocePath"];
        _vioceUrl = [aDecoder decodeObjectForKey:@"vioceUrl"];
        
        _avator = [aDecoder decodeObjectForKey:@"avator"];
        _avatorUrl = [aDecoder decodeObjectForKey:@"avatorUrl"];
        
        _sender = [aDecoder decodeObjectForKey:@"sender"];
        _date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.text forKey:@"text"];
    
    [aCoder encodeObject:self.photo forKey:@"photo"];
    [aCoder encodeObject:self.thumbnailUrl forKey:@"thumbnailUrl"];
    [aCoder encodeObject:self.originPhotoUrl forKey:@"originPhotoUrl"];
    
    [aCoder encodeObject:self.videoConverPhoto forKey:@"videoConverPhoto"];
    [aCoder encodeObject:self.videoPath forKey:@"videoPath"];
    [aCoder encodeObject:self.videoUrl forKey:@"videoUrl"];
    
    [aCoder encodeObject:self.viocePath forKey:@"viocePath"];
    [aCoder encodeObject:self.vioceUrl forKey:@"vioceUrl"];
    
    [aCoder encodeObject:self.avator forKey:@"avator"];
    [aCoder encodeObject:self.avatorUrl forKey:@"avatorUrl"];
    
    [aCoder encodeObject:self.sender forKey:@"sender"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    switch (self.messageMediaType) {
        case XHBubbleMessageText:
            return [[[self class] allocWithZone:zone] initWithText:[self.text copy]
                                                            sender:[self.sender copy]
                                                              date:[self.date copy]];
        case XHBubbleMessagePhoto:
            return [[[self class] allocWithZone:zone] initWithPhoto:[self.photo copy]
                                                       thumbnailUrl:[self.thumbnailUrl copy]
                                                     originPhotoUrl:[self.originPhotoUrl copy]
                                                             sender:[self.sender copy]
                                                               date:[self.date copy]];
        case XHBubbleMessageVideo:
            return [[[self class] allocWithZone:zone] initWithVideoConverPhoto:[self.videoConverPhoto copy]
                                                                     videoPath:[self.videoPath copy]
                                                                      videoUrl:[self.videoUrl copy]
                                                                        sender:[self.sender copy]
                                                                          date:[self.date copy]];
        case XHBubbleMessageVioce:
            return [[[self class] allocWithZone:zone] initWithViocePath:[self.viocePath copy]
                                                                     vioceUrl:[self.vioceUrl copy]
                                                                        sender:[self.sender copy]
                                                                          date:[self.date copy]];
        default:
            return nil;
    }
}

@end
