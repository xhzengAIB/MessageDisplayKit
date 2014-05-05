//
//  VoiceRecorderBaseVC.h
//  Jeans
//
//  Created by Jeans on 3/23/13.
//  Copyright (c) 2013 Jeans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioToolbox/AudioToolbox.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

//默认最大录音时间
#define kDefaultMaxRecordTime               60

#define AUDIO_LOCAL_FILE                    @"localfile"

@protocol VoiceRecorderBaseVCDelegate <NSObject>

@optional
////录音完成回调，返回文件路径和文件名
//- (void)VoiceRecorderBaseVCRecordFinish:(NSString *)_filePath fileName:(NSString*)_fileName;

//录音完成后的回调
- (void)recorderDidFinishRecording:(AVAudioRecorder *)recorder fileName:(NSString*)fileName successfully:(BOOL)flag;
////录音开始中断
//- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder fileName:(NSString*)fileName;
////录音结束中断
//- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder fileName:(NSString*)fileName withOptions:(NSUInteger)flags;

@end

@interface VoiceRecorderBaseVC : UIViewController{
    
@protected
    NSInteger               maxRecordTime;  //最大录音时间
    NSString                *recordFileName;//录音文件名
    NSString                *recordFilePath;//录音文件路径
}

@property (assign, nonatomic)           id<VoiceRecorderBaseVCDelegate> vrbDelegate;

@property (assign, nonatomic)           NSInteger               maxRecordTime;//最大录音时间
@property (copy, nonatomic)             NSString                *recordFileName;//录音文件名
@property (copy, nonatomic)             NSString                *recordFilePath;//录音文件路径

/**
 生成当前时间字符串
 @returns 当前时间字符串
 */
+ (NSString*)getCurrentTimeString;

/**
 获取缓存路径
 @returns 缓存路径
 */
+ (NSString*)getCacheDirectory;

/**
 判断文件是否存在
 @param _path 文件路径
 @returns 存在返回yes
 */
+ (BOOL)fileExistsAtPath:(NSString*)_path;

/**
 删除文件
 @param _path 文件路径
 @returns 成功返回yes
 */
+ (BOOL)deleteFileAtPath:(NSString*)_path;


#pragma mark -

/**
 生成文件路径
 @param _fileName 文件名
 @param _type 文件类型
 @returns 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)_fileName;
+ (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type;

/**
 获取录音设置
 @returns 录音设置
 */
+ (NSDictionary*)getAudioRecorderSettingDict;
@end
