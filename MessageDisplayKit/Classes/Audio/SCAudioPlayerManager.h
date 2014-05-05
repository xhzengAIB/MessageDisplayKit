//
//  SCAudioPlayerManager.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-22.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioToolbox/AudioToolbox.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>


@protocol SCAudioPlayerManagerDelegate <NSObject>

@optional
- (void)didAudioPlayerBeginPlay:(AVAudioPlayer*)audioPlayer;
- (void)didAudioPlayerStopPlay:(AVAudioPlayer*)audioPlayer;
- (void)didAudioPlayerPausePlay:(AVAudioPlayer*)audioPlayer;

@end

@interface SCAudioPlayerManager : NSObject <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, copy) NSString *playingFileName;

@property (nonatomic, assign) id <SCAudioPlayerManagerDelegate> delegate;


/**
 *  单例
 *
 *  @return SCAudioPlayerManager
 */
+ (id)shareInstance;

/**
 *  得到当前的player
 *
 *  @return 当前player
 */
- (AVAudioPlayer*)player;

/**
 *  播放/暂停音频
 *
 *  @param amrName amr文件的名字
 *  @param toPlay  YES时为播放，NO为暂停
 */
- (void)managerAudioWithFileName:(NSString*)amrName toPlay:(BOOL)toPlay;

/**
 *  停止播放音频
 */
- (void)stopAudio;

/**
 *  是否正在播放音频
 *
 *  @return YES/NO
 */
- (BOOL)isPlaying;

@end


