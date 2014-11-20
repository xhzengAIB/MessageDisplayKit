//
//  XHVoiceRecordHelper.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-13.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^XHPrepareRecorderCompletion)();
typedef void(^XHStartRecorderCompletion)();
typedef void(^XHStopRecorderCompletion)();
typedef void(^XHPauseRecorderCompletion)();
typedef void(^XHResumeRecorderCompletion)();
typedef void(^XHCancellRecorderDeleteFileCompletion)();
typedef void(^XHRecordProgress)(float progress);
typedef void(^XHPeakPowerForChannel)(float peakPowerForChannel);


@interface XHVoiceRecordHelper : NSObject

@property (nonatomic, copy) XHStopRecorderCompletion maxTimeStopRecorderCompletion;
@property (nonatomic, copy) XHRecordProgress recordProgress;
@property (nonatomic, copy) XHPeakPowerForChannel peakPowerForChannel;
@property (nonatomic, copy, readonly) NSString *recordPath;
@property (nonatomic, copy) NSString *recordDuration;
@property (nonatomic) float maxRecordTime; // 默认 60秒为最大
@property (nonatomic, readonly) NSTimeInterval currentTimeInterval;

- (void)prepareRecordingWithPath:(NSString *)path prepareRecorderCompletion:(XHPrepareRecorderCompletion)prepareRecorderCompletion;
- (void)startRecordingWithStartRecorderCompletion:(XHStartRecorderCompletion)startRecorderCompletion;
- (void)pauseRecordingWithPauseRecorderCompletion:(XHPauseRecorderCompletion)pauseRecorderCompletion;
- (void)resumeRecordingWithResumeRecorderCompletion:(XHResumeRecorderCompletion)resumeRecorderCompletion;
- (void)stopRecordingWithStopRecorderCompletion:(XHStopRecorderCompletion)stopRecorderCompletion;
- (void)cancelledDeleteWithCompletion:(XHCancellRecorderDeleteFileCompletion)cancelledDeleteCompletion;

@end
