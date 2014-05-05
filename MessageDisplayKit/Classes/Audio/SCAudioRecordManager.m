//
//  SCAudioRecordManager.m
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-22.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCAudioRecordManager.h"
//#import "VoiceRecorderBaseVC.h"
#import "VoiceConverter.h"
#import "SCDefines.h"
#import "SVProgressHUD.h"

#define AUDIO_FILE_MANAGER  [NSFileManager defaultManager]



@interface SCAudioRecordManager () <AVAudioRecorderDelegate> {
    BOOL                    isFinalConvertedDone;
    CGFloat                 curCount;           //当前计数,初始为0
    BOOL                    canNotSend;         //不能发送
    dispatch_source_t       gcdTimer;           //gcd的timer
}


@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, copy) NSString *preWavFileStr;//
@property (nonatomic, copy) NSString *preAmrFileStr;//

@end

@implementation SCAudioRecordManager

- (id)init {
    self = [super init];
    if (self) {
        self.maxRecordTime = 60;
    }
    return self;
}

- (void)dealloc {
    self.wavFileStr = nil;
    self.amrFileStr = nil;
    self.preWavFileStr = nil;
    self.preAmrFileStr = nil;
    self.recorder = nil;
    [self isAudioDeleted];
}

#pragma mark - actions
/**
 *  开始录音
 */
- (void)beginRecord {
    
    SCDLog(@"begin record");
    
    isFinalConvertedDone = NO;
    
    //设置文件名
    self.wavFileStr = [SCAudioRecordManager getCurrentTimeString];
    
    //初始化录音
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:[SCAudioRecordManager getPathByFileName:_wavFileStr ofType:@"wav"]]
                                                settings:[SCAudioRecordManager getAudioRecorderSettingDict]
                                                   error:nil];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
    
    //还原计数
    curCount = 0;
    //还原发送
    canNotSend = NO;
    
    //下面这两句代码声音是Speaker，外放声音。不加的话是用耳机的。code by Aevit
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    
    //开始录音
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    
    [self.recorder record];
    
    //启动计时器
    [self stopTimer];
    [self startTimer];
}

/**
 *  暂停录音
 */
- (void)pauseRecord {
    
    SCDLog(@"pause record");
    if (self.recorder.isRecording) {
        [self.recorder pause];
    }
}

/**
 *  暂停后继续录音
 */
- (void)resumeRecord {
    
    SCDLog(@"resume record");
    if (!self.recorder.isRecording) {
        [self.recorder record];
    }
}

/**
 *  结束录音
 */
- (void)endRecord {
    
    SCDLog(@"end record");
    
    if (self.recorder.isRecording)
        [self.recorder stop];
}

#pragma mark - update meters
/**
 *  启动定时器，更新音频峰值
 */
- (void)startTimer{
    
    if (!gcdTimer) {
        //间隔时间
        uint64_t interval = 0.1f * NSEC_PER_SEC;
        //创建Timer
        gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        //使用dispatch_source_set_timer函数设置timer参数
        dispatch_source_set_timer(gcdTimer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
        //设置回调
        dispatch_source_set_event_handler(gcdTimer, ^() {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateMeters];
            });
        });
    }
    //dispatch_source默认是Suspended状态，通过dispatch_resume函数开始它
    dispatch_resume(gcdTimer);
}

/**
 *  停止定时器
 */
- (void)stopTimer{
    if (gcdTimer) {
        dispatch_suspend(gcdTimer);
    }
}

/**
 *  录音时，建立更新音频峰值的回调
 *
 *  @param block 回调内容
 */
- (void)buildUpdateMetersBlock:(UpdateMetersBlock)block {
    if (block) {
        self.updateMetersBlock = block;
    }
}

/**
 *  录音时，更新音频峰值
 *
 *  @param _avgPower  峰值
 *  @param recordView 展示峰值变化的view
 */
- (void)updateMetersByAvgPower:(float)_avgPower recordView:(SCRecordView*)recordView {
    //-160表示完全安静，0表示最大输入值
    
    NSInteger addRectNum = 0;
    
    if (_avgPower >= -40 && _avgPower < -30)
        addRectNum = 1;
    else if (_avgPower >= -30 && _avgPower < -25)
        addRectNum = 2;
    else if (_avgPower >= -25)
        addRectNum = 3;
    
    recordView.highestRowRectNum = 4;
    recordView.highestRowRectNum += addRectNum;
}

/**
 *  更新音频峰值
 */
- (void)updateMeters {
    if (_recorder.isRecording){
        
        //更新峰值
        [_recorder updateMeters];
        if (_updateMetersBlock) {
            _updateMetersBlock([_recorder averagePowerForChannel:0]);
        } else if ([_delegate respondsToSelector:@selector(SCAudioRecordManager:updateAudioMeters:)]) {
            [_delegate SCAudioRecordManager:self updateAudioMeters:[_recorder averagePowerForChannel:0]];
        }
        
        //倒计时
        if (curCount >= _maxRecordTime - 10 && curCount < _maxRecordTime) {
            //剩下10秒
            SCDLog(@"录音剩下:%d秒", (int)(_maxRecordTime - curCount));
        } else if (curCount >= _maxRecordTime){
            //时间到
            SCDLog(@"达到最大录音时间");
            [self stopTimer];
        }
        curCount += 0.1f;
    }
}

/**
 *  停止计时器，并将currCount置为0
 */
- (void)isAudioDeleted {
    SCDLog(@"录音文件被删除了");
    [self stopTimer];
    curCount = 0;
}

#pragma mark - public
/**
 *  根据文件名字(不包含后缀)，删除文件
 *
 *  @param fileName 文件名字(不包含后缀)
 *  @param block   删除成功后的回调
 */
+ (void)removeRecordedFileWithOnlyName:(NSString*)fileName block:(DidDeleteAudioFileBlock)block {
    
    if (!fileName || [fileName isEqual:[NSNull null]] || fileName.length <= 0) {
        SCDLog(@"file is not exist");
        return;
    }
    [SCAudioRecordManager removeRecordedFile:fileName type:@"amr"];
    
    NSString *originWavFile = [fileName stringByReplacingOccurrencesOfString:@"wavToAmr" withString:@""];
    [SCAudioRecordManager removeRecordedFile:originWavFile type:@"wav"];
    
    NSString *convertedWavFile = [originWavFile stringByAppendingString:@"amrToWav"];
    [SCAudioRecordManager removeRecordedFile:convertedWavFile type:@"amr"];
    
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
    NSString *path = [SCAudioRecordManager getCacheDirectory];
    
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

#pragma mark - wav转amr
- (void)convertWavToAmr:(NSString*)wavFileNameStr {
    
    if (wavFileNameStr.length > 0) {
        
        NSString *amrFileName = [wavFileNameStr stringByAppendingString:@"wavToAmr"];
        self.amrFileStr = amrFileName;
        
        //转格式
        [VoiceConverter wavToAmr:[SCAudioRecordManager getPathByFileName:wavFileNameStr ofType:@"wav"] amrSavePath:[SCAudioRecordManager getPathByFileName:amrFileName ofType:@"amr"]];
        
        //显示信息
        NSDate *beforeConvertDate = [NSDate date];
        [self showInfoWithFilePath:[SCAudioRecordManager getPathByFileName:_amrFileStr ofType:@"amr"] fileName:_amrFileStr convertTime:[[NSDate date] timeIntervalSinceDate:beforeConvertDate]];
        
        if (_didFinishConvertToAmrBlock) {
            _didFinishConvertToAmrBlock([SCAudioRecordManager getPathByFileName:amrFileName ofType:@"amr"], _recordedDuration);
        } else if ([_delegate respondsToSelector:@selector(SCAudioRecordManager:didFinishConvertToAmr:fileName:recordDuration:)]) {
            [_delegate SCAudioRecordManager:self didFinishConvertToAmr:[SCAudioRecordManager getPathByFileName:amrFileName ofType:@"amr"] fileName:amrFileName recordDuration:_recordedDuration];
        }
    }
}

#pragma mark - amr转wav
- (void)convertAmrToWav:(NSString*)amrName {
    if (amrName.length > 0){
        NSString *wavName = [amrName stringByReplacingOccurrencesOfString:@"wavToAmr" withString:@"amrToWav"];
        
        //转格式
        [VoiceConverter amrToWav:[SCAudioRecordManager getPathByFileName:amrName ofType:@"amr"] wavSavePath:[SCAudioRecordManager getPathByFileName:wavName ofType:@"wav"]];
        
        //显示信息
        NSDate *beforeConvertDate = [NSDate date];
        [self showInfoWithFilePath:[SCAudioRecordManager getPathByFileName:wavName ofType:@"wav"] fileName:wavName convertTime:[[NSDate date] timeIntervalSinceDate:beforeConvertDate]];
    }
}

#pragma mark - 合并音频
- (void)combineRecorders {
    BOOL shouldCombineAudio = (_preWavFileStr && _preWavFileStr.length > 0 && ![_preWavFileStr isEqualToString:_wavFileStr] ? YES : NO);
    
    if (!shouldCombineAudio) {
        self.preWavFileStr = _wavFileStr;
        self.preAmrFileStr = _amrFileStr;
        return;
    }
    
    //先保存之前录的音频data
    NSData *preWavData = (shouldCombineAudio ? [NSData dataWithContentsOfFile:[SCAudioRecordManager getPathByFileName:_preWavFileStr ofType:@"wav"]] : nil);
    
    //新录的音频data
    NSData *nowWavData = [NSData dataWithContentsOfFile:[SCAudioRecordManager getPathByFileName:_wavFileStr ofType:@"wav"]];
    
    //合并音频data
    NSMutableData *finalData = [[NSMutableData alloc] init];
    [finalData appendData:preWavData];
    [finalData appendData:nowWavData];
    
    //保存合并后的音频data为file
    NSString *combinedWavStr = [SCAudioRecordManager getCurrentTimeString];
    [[NSFileManager defaultManager] createFileAtPath:[[[SCAudioRecordManager getCacheDirectory] stringByAppendingPathComponent:combinedWavStr] stringByAppendingPathExtension:@"wav"] contents:finalData attributes:nil];
    
//    [self showInfoWithFilePath:[VoiceRecorderBaseVC getPathByFileName:combinedWavStr ofType:@"wav"] fileName:combinedWavStr convertTime:-1];
    
    
    [self removeRecordedFile:^{
        SCDLog(@"合并完成，删除合并前的所有文件成功，接下来重新赋值文件名字");
        self.wavFileStr = combinedWavStr;
        self.amrFileStr = [_wavFileStr stringByAppendingString:@"wavToAmr"];
        self.preWavFileStr = _wavFileStr;
        self.preAmrFileStr = _amrFileStr;
    } toDeletePreFile:YES];
}

#pragma mark - AVAudioRecorder Delegate Methods
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    SCDLog(@"录音完成回调____________");
    
    [self stopTimer];
    curCount = 0;
    
    if (!_wavFileStr || _wavFileStr.length <= 0) {
        SCDLog(@"取消此次录音了");
        return;
    }
    [self showInfoWithFilePath:[SCAudioRecordManager getPathByFileName:_wavFileStr ofType:@"wav"] fileName:_wavFileStr convertTime:0];
    
    //开始转换并合并
    [self combineRecorders];
    isFinalConvertedDone = YES;
    
    if (_recordedDuration <= 1.5) {
        self.recordedDuration = 0;
        [SVProgressHUD showErrorWithStatus:@"录音时间太短了"];
        SCDLog(@"录音时间太短了");
        [self removeRecordedFile:nil];
        
    } else {
        if ([_delegate respondsToSelector:@selector(SCAudioRecordManager:beforeConvertToAmr:recordDuration:)]) {
            [_delegate SCAudioRecordManager:self beforeConvertToAmr:[SCAudioRecordManager getPathByFileName:_wavFileStr ofType:@"wav"] recordDuration:_recordedDuration];
        }
        [self convertWavToAmr:_wavFileStr];
    }
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    SCDLog(@"录音开始中断");
    [self stopTimer];
    curCount = 0;
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags{
    SCDLog(@"录音结束中断");
    [self stopTimer];
    curCount = 0;
}

#pragma mark - static method(s)
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
            SCDLog(@"创建audio目录失败T_T");
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
    NSString* fileDirectory = [[[SCAudioRecordManager getCacheDirectory] stringByAppendingPathComponent:_fileName] stringByAppendingPathExtension:_type];
    return fileDirectory;
}

/**
 *  生成文件路径
 *
 *  @param _fileName 文件名
 *  @param _type 文件类型
 *  @return 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)_fileName{
    NSString* fileDirectory = [[SCAudioRecordManager getCacheDirectory]stringByAppendingPathComponent:_fileName];
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
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
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
 *  打印录音文件信息
 *
 *  @param filePath    文件路径
 *  @param fileName    文件名字
 *  @param convertTime 转换时间
 */
- (void)showInfoWithFilePath:(NSString*)filePath fileName:(NSString*)fileName convertTime:(NSTimeInterval)convertTime {
    
    NSInteger size = [self getFileSize:filePath] / 1024;
    
    if (convertTime == -1) {
        SCDLog(@"合并音频后_____________");
    }
    
    SCDLog(@"path:%@, 大小:%dkb", filePath, size);
    
    NSRange range = [filePath rangeOfString:@"wav"];
    if (range.length > 0) {
        AVAudioPlayer *play = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
        SCDLog(@"时长:%f", play.duration);
        
        self.recordedDuration = play.duration;

        
//        if (isFinalConvertedDone) {
//            if (_recordedDuration <= 0 && play.duration <= 1.5) {
//                self.recordedDuration = 0;
//                [SVProgressHUD showErrorWithStatus:@"录音时间太短了"];
//                SCDLog(@"录音时间太短了");
//                [self removeRecordedFile:nil];
//            } else {
//                self.recordedDuration = play.duration;
//            }
//            if (_didGetRecordedDurationBlock) {
//                _didGetRecordedDurationBlock(_recordedDuration);
//            }
//            isFinalConvertedDone = NO;
//        }
    }
    
    if (convertTime > 0) {
        SCDLog(@"转换时间:%f", convertTime);
    }
}

/**
 *  录音完成后，得到录音时间的回调
 *
 *  @param block 回调内容
 */
- (void)buildDidFinishConvertToAmrBlock:(DidFinishConvertToAmrBlock)block {
    if (block) {
        self.didFinishConvertToAmrBlock = block;
    }
}

/**
 *  获取文件大小
 *
 *  @param path 文件路径
 *
 *  @return 返回文件大小，-1表示文件不存在或其他未知情况
 */
- (NSInteger)getFileSize:(NSString*)path{
    NSFileManager *filemanager = [[NSFileManager alloc] init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    } else {
        return -1;
    }
}


/**
 *  合并音频后，删除录音文件
 *
 *  @param block           删除成功后的回调
 *  @param toDeletePreFile 成功合并多个音频为一个文件后，是否删除合并前的几个音频文件
 */
- (void)removeRecordedFile:(DidDeleteAudioFileBlock)block toDeletePreFile:(BOOL)toDeletePreFile{
    for (int i = 0; i < (_preWavFileStr && _preWavFileStr.length > 0 ? 2 : 1); i++) {
        NSString *wavStr = (i == 0 ? _wavFileStr : _preWavFileStr);
        if (wavStr.length <= 0) {
            return;
        }
        [SCAudioRecordManager removeRecordedFile:wavStr type:@"wav"];
        
        NSString *convertedWavFile = [wavStr stringByAppendingString:@"amrToWav"];
        [SCAudioRecordManager removeRecordedFile:convertedWavFile type:@"wav"];
        
        NSString *amrWavFile = [wavStr stringByAppendingString:@"wavToAmr"];
        [SCAudioRecordManager removeRecordedFile:amrWavFile type:@"amr"];
    }
    
    [self restoreData:toDeletePreFile];
    
    [self isAudioDeleted];
    if (block) {
        block();
    }
}

/**
 *  删除已录音文件
 *
 *  @param block 删除成功后的回调
 */
- (void)removeRecordedFile:(DidDeleteAudioFileBlock)block {
    [self removeRecordedFile:block toDeletePreFile:NO];
}

/**
 *  删除某个文件
 *
 *  @param fileName 文件名字（不包含后缀）
 *  @param type     文件后缀
 */
+ (void)removeRecordedFile:(NSString*)fileName type:(NSString*)type {
    
    NSString *path = [SCAudioRecordManager getPathByFileName:fileName ofType:type];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *error;
    if ([fileMgr fileExistsAtPath:path]) {
        if ([fileMgr removeItemAtPath:path error:&error] != YES) {
            SCDLog(@"unable to delete:%@  %@", path, [error localizedDescription]);
        }
    }
}

/**
 *  重置数据
 *
 *  @param toDeletePreFile 是否在删除数据前
 */
- (void)restoreData:(BOOL)toDeletePreFile {
    if (toDeletePreFile) {
        return;
    }
    self.wavFileStr = nil;
    self.amrFileStr = nil;
    self.recordedDuration = 0;
}




@end
