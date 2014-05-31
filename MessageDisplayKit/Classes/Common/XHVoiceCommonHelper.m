//
//  XHVoiceCommonHelper.m
//  MessageDisplayExample
//
//  Created by Aevitx on 14-5-27.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHVoiceCommonHelper.h"

#import "XHMacro.h"

@implementation XHVoiceCommonHelper

/**
 *  根据文件名字(不包含后缀)，删除文件
 *
 *  @param fileName 文件名字(不包含后缀)
 *  @param block   删除成功后的回调
 */
+ (void)removeRecordedFileWithOnlyName:(NSString*)fileName block:(DidDeleteAudioFileBlock)block {
    
    if (!fileName || [fileName isEqual:[NSNull null]] || fileName.length <= 0) {
        DLog(@"file is not exist");
        return;
    }
    [XHVoiceCommonHelper removeRecordedFile:fileName type:@"amr"];
    
    NSString *originWavFile = [fileName stringByReplacingOccurrencesOfString:@"wavToAmr" withString:@""];
    [XHVoiceCommonHelper removeRecordedFile:originWavFile type:@"wav"];
    
    NSString *convertedWavFile = [originWavFile stringByAppendingString:@"amrToWav"];
    [XHVoiceCommonHelper removeRecordedFile:convertedWavFile type:@"amr"];
    
    if (block) {
        block();
    }
}

/**
 *  删除/documents/Audio下的文件
 *
 *  @param exception 有包含些字符串就不删除（为空表示全部删除）
 *  @param block     删除成功后的回调
 */
+ (void)removeAudioFile:(NSString*)exception block:(DidDeleteAudioFileBlock)block {
    NSString *path = [XHVoiceCommonHelper getCacheDirectory];
    
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        if (exception && ![exception isEqual:[NSNull null]] && exception.length > 0) {//包含exception字符串的文件不删除
            if ([filename rangeOfString:AUDIO_LOCAL_FILE].length <= 0) {
                [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
            }
        } else {
            [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    if (block) {
        block();
    }
}

/**
 *  根据当前时间生成字符串
 *
 *  @return 当前时间字符串
 */
+ (NSString*)getCurrentTimeString {
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [dateformat stringFromDate:[NSDate date]];
    dateStr = [dateStr stringByAppendingString:AUDIO_LOCAL_FILE];
    return dateStr;
}

/**
 *  获取缓存路径
 *
 *  @return 缓存路径
 */
+ (NSString*)getCacheDirectory {
    //1、存在/documents/Audio
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *audioDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Audio"];
    BOOL isDir = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:audioDir isDirectory:&isDir] == NO) {
        BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:audioDir withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isSuccess) {
            DLog(@"创建audio目录失败T_T");
        }
    }
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Audio"];
    
    //2、存在/documents
    //    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //3、存在/cache
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Audio"];
}

/**
 *  判断文件是否存在
 *
 *  @param _path 文件路径
 *
 *  @return 存在返回YES
 */
+ (BOOL)fileExistsAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:_path];
}

/**
 *  删除文件
 *
 *  @param _path 文件路径
 *
 *  @return 成功返回YES
 */
+ (BOOL)deleteFileAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
}

/**
 *  生成文件路径
 *
 *  @param _fileName 文件名
 *  @return 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type
{
    NSString* fileDirectory = [[[XHVoiceCommonHelper getCacheDirectory] stringByAppendingPathComponent:_fileName] stringByAppendingPathExtension:_type];
    return fileDirectory;
}

/**
 *  生成文件路径
 *
 *  @param _fileName 文件名
 *  @param _type 文件类型
 *  @return 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)_fileName
{
    NSString* fileDirectory = [[XHVoiceCommonHelper getCacheDirectory]stringByAppendingPathComponent:_fileName];
    return fileDirectory;
}

/**
 *  获取录音设置
 *
 *  @return 录音设置
 */
+ (NSDictionary*)getAudioRecorderSettingDict
{
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0], AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
    return recordSetting;
}


#pragma mark - private
/**
 *  删除某个文件
 *
 *  @param fileName 文件名字（不包含后缀）
 *  @param type     文件后缀
 */
+ (void)removeRecordedFile:(NSString*)fileName type:(NSString*)type {
    
    NSString *path = [XHVoiceCommonHelper getPathByFileName:fileName ofType:type];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *error;
    if ([fileMgr fileExistsAtPath:path]) {
        if ([fileMgr removeItemAtPath:path error:&error] != YES) {
            DLog(@"unable to delete:%@  %@", path, [error localizedDescription]);
        }
    }
}

@end
