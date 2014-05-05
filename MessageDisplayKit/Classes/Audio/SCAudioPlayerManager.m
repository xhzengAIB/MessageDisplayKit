//
//  SCAudioPlayerManager.m
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-22.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCAudioPlayerManager.h"
#import "VoiceConverter.h"

#import "SCAudioRecordManager.h"

@implementation SCAudioPlayerManager


+ (id)shareInstance {
    static SCAudioPlayerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SCAudioPlayerManager alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - public
/**
 *  得到当前的player
 *
 *  @return 当前player
 */
- (AVAudioPlayer*)player {
    return _player;
}

/**
 *  如果 delegate == nil，则停止播放
 *
 *  @param delegate delegate
 */
- (void)setDelegate:(id<SCAudioPlayerManagerDelegate>)delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
        
        if (_delegate == nil) {
            [self stopAudio];
        }
    }
}

/**
 *  是否正在播放音频
 *
 *  @return YES/NO
 */
- (BOOL)isPlaying {
    if (!_player) {
        return NO;
    }
    return _player.isPlaying;
}

/**
 *  播放/暂停音频
 *
 *  @param amrName amr文件的名字
 *  @param toPlay  YES时为播放，NO为暂停
 */
- (void)managerAudioWithFileName:(NSString*)amrName toPlay:(BOOL)toPlay {
    if (toPlay) {
        [self playAudioWithFileName:amrName];
    } else {
        [self pausePlayingAudio];
    }
}

/**
 *  停止播放
 */
- (void)stopAudio {
    [self setPlayingFileName:@""];
    if (_player && _player.isPlaying) {
        [_player stop];
    }
    if ([self.delegate respondsToSelector:@selector(didAudioPlayerStopPlay:)]) {
        [self.delegate didAudioPlayerStopPlay:_player];
    }
}

#pragma mark - private
/**
 *  播放转换后wav
 *
 *  @param amrName amr文件名字
 */
- (void)playAudioWithFileName:(NSString*)amrName {
    
    amrName =  [[amrName lastPathComponent] stringByDeletingPathExtension];
    
    if (amrName.length > 0) {
        
        //不随着静音键和屏幕关闭而静音。code by Aevit
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        if (_playingFileName && [amrName isEqualToString:_playingFileName]) {//上次播放的录音
            if (_player) {
                [_player play];
                if ([self.delegate respondsToSelector:@selector(didAudioPlayerBeginPlay:)]) {
                    [self.delegate didAudioPlayerBeginPlay:_player];
                }
            }
        } else {//不是上次播放的录音
            if (_player) {
                [_player stop];
                self.player = nil;
            }
            [self convertAmrToWav:amrName];
            NSString *wavName = [amrName stringByReplacingOccurrencesOfString:@"wavToAmr" withString:@"amrToWav"];
            AVAudioPlayer *pl = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[SCAudioRecordManager getPathByFileName:wavName ofType:@"wav"]] error:nil];
            pl.delegate = self;
            [pl play];
            self.player = pl;
            if ([self.delegate respondsToSelector:@selector(didAudioPlayerBeginPlay:)]) {
                [self.delegate didAudioPlayerBeginPlay:_player];
            }
        }
        self.playingFileName = amrName;
    }
}

/**
 *  暂停播放
 */
- (void)pausePlayingAudio {
    if (_player) {
        [_player pause];
        if ([self.delegate respondsToSelector:@selector(didAudioPlayerPausePlay:)]) {
            [self.delegate didAudioPlayerPausePlay:_player];
        }
    }
}

/**
 *  amr转wav后播放
 *
 *  @param amrName amr文件名字
 */
- (void)convertAmrToWav:(NSString*)amrName {
    if (amrName.length > 0){
        NSString *wavName = [amrName stringByReplacingOccurrencesOfString:@"wavToAmr" withString:@"amrToWav"];
        
        //转格式
        [VoiceConverter amrToWav:[SCAudioRecordManager getPathByFileName:amrName ofType:@"amr"] wavSavePath:[SCAudioRecordManager getPathByFileName:wavName ofType:@"wav"]];
        
    }
}

#pragma mark - audio delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self stopAudio];
}


@end
