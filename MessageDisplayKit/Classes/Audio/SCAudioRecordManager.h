//
//  SCAudioRecordManager.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-22.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

/**
 *  所需Framewokds：AudioToolBox、AVFoundation、CoreAudio
 */

#import <Foundation/Foundation.h>
#import "AudioToolbox/AudioToolbox.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

#import "SCDefines.h"

#import "SCRecordView.h"


#define AUDIO_LOCAL_FILE                    @"localfile"

typedef void(^DidDeleteAudioFileBlock)();

typedef void(^DidFinishConvertToAmrBlock)(NSString *amrFilePath, float theDuration);
typedef void(^UpdateMetersBlock)(float avgPower);

@protocol SCAudioRecordManagerDelegate;

@interface SCAudioRecordManager : NSObject


@property (nonatomic, assign) NSInteger maxRecordTime;//最大录音时间


@property (nonatomic, copy) NSString *wavFileStr;
@property (nonatomic, copy) NSString *amrFileStr;
@property (nonatomic, assign) float recordedDuration;

@property (nonatomic, copy) DidFinishConvertToAmrBlock didFinishConvertToAmrBlock;
@property (nonatomic, copy) UpdateMetersBlock updateMetersBlock;

@property (nonatomic, assign) id <SCAudioRecordManagerDelegate> delegate;

/**
 *  开始录音
 */
- (void)beginRecord;


/**
 *  结束录音
 */
- (void)endRecord;


/**
 *  暂停录音
 */
- (void)pauseRecord;


/**
 *  暂停后继续录音
 */
- (void)resumeRecord;


/**
 *  录音完成后，得到录音时间的回调
 *
 *  @param block 回调内容
 */
- (void)buildDidFinishConvertToAmrBlock:(DidFinishConvertToAmrBlock)block;


/**
 *  录音时，建立更新音频峰值的回调
 *
 *  @param block 回调内容
 */
- (void)buildUpdateMetersBlock:(UpdateMetersBlock)block;


/**
 *  录音时，更新音频峰值
 *
 *  @param _avgPower  峰值
 *  @param recordView 展示峰值变化的view
 */
- (void)updateMetersByAvgPower:(float)_avgPower recordView:(SCRecordView*)recordView;


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



@protocol SCAudioRecordManagerDelegate <NSObject>

@optional
/**
 *  更新音频峰值，delegate方法
 *
 *  @param manager  SCAudioRecordManager
 *  @param avgPower 音频值
 */
- (void)SCAudioRecordManager:(SCAudioRecordManager*)manager updateAudioMeters:(float)avgPower;

/**
 *  wav转化为amr前
 *
 *  @param manager  SCAudioRecordManager
 *  @param filePath wav文件所在路径
 *  @param duration 音频时长
 */
- (void)SCAudioRecordManager:(SCAudioRecordManager*)manager beforeConvertToAmr:(NSString*)filePath recordDuration:(float)duration;

/**
 *  转换为amr成功后
 *
 *  @param manager  SCAudioRecordManager
 *  @param filePath amr文件所在路径
 *  @param fileName amr文件名字
 *  @param duration 音频时长
 */
- (void)SCAudioRecordManager:(SCAudioRecordManager*)manager didFinishConvertToAmr:(NSString*)filePath fileName:(NSString*)fileName recordDuration:(float)duration;

@end


