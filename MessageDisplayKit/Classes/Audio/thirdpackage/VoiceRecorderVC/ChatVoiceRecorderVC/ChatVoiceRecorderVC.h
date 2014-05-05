//
//  ChatVoiceRecorderVC.h
//  Jeans
//
//  Created by Jeans on 3/23/13.
//  Copyright (c) 2013 Jeans. All rights reserved.
//

#import "VoiceRecorderBaseVC.h"
#import "VoiceConverter.h"

typedef void(^UpdateMetersBlock)(float avgPower);

#define kRecorderViewRect       CGRectMake(80, 120, 160, 160)
//#define kCancelOriginY          (kRecorderViewRect.origin.y + kRecorderViewRect.size.height + 180)
#define kCancelOriginY          ([[UIScreen mainScreen]bounds].size.height-70)

@interface ChatVoiceRecorderVC : VoiceRecorderBaseVC


@property (nonatomic, copy) UpdateMetersBlock updateMetersBlock;


//@property (nonatomic) dispatch_queue_t timerQueue;


- (void)beginRecordByFileName:(NSString*)_fileName;//开始录音
- (void)endRecord;//结束录音
- (void)pauseRecord;//暂停录音
- (void)resumeRecord;//暂停后继续录音

- (void)buildUpdateMetersBlock:(UpdateMetersBlock)block;

- (void)isAudioDeleted;


@end
