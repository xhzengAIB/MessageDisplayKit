//
//  XHVoiceCommonHelper.h
//  MessageDisplayExample
//
//  Created by Aevitx on 14-5-27.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define AUDIO_LOCAL_FILE                    @"localfile"

typedef void(^DidDeleteAudioFileBlock)();

@interface XHVoiceCommonHelper : NSObject
/**
 *  根据文件名字(不包含后缀)，删除文件
 *
 *  @param fileName 文件名字(不包含后缀)
 *  @param block   删除成功后的回调
 */
+ (void)removeRecordedFileWithOnlyName:(NSString*)fileName block:(DidDeleteAudioFileBlock)block;


/**
 *  删除/documents/Audio下的文件
 *
 *  @param exception 有包含些字符串就不删除（为空表示全部删除）
 *  @param block     删除成功后的回调
 */
+ (void)removeAudioFile:(NSString*)exception block:(DidDeleteAudioFileBlock)block;




/**
 *  根据当前时间生成字符串
 *
 *  @return 当前时间字符串
 */
+ (NSString*)getCurrentTimeString;


/**
 *  获取缓存路径
 *
 *  @return 缓存路径
 */
+ (NSString*)getCacheDirectory;


/**
 *  判断文件是否存在
 *
 *  @param _path 文件路径
 *
 *  @return 存在返回YES
 */
+ (BOOL)fileExistsAtPath:(NSString*)_path;


/**
 *  删除文件
 *
 *  @param _path 文件路径
 *
 *  @return 成功返回YES
 */
+ (BOOL)deleteFileAtPath:(NSString*)_path;


/**
 *  生成文件路径
 *
 *  @param _fileName 文件名
 *  @param _type 文件类型
 *  @return 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)_fileName;
+ (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type;


/**
 *  获取录音设置
 *
 *  @return 录音设置
 */
+ (NSDictionary*)getAudioRecorderSettingDict;

@end
