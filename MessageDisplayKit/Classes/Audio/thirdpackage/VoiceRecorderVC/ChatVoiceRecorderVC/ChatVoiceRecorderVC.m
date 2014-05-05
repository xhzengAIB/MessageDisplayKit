//
//  ChatVoiceRecorderVC.m
//  Jeans
//
//  Created by Jeans on 3/23/13.
//  Copyright (c) 2013 Jeans. All rights reserved.
//

#import "ChatVoiceRecorderVC.h"
#import "SCDefines.h"

@interface ChatVoiceRecorderVC ()<AVAudioRecorderDelegate>{
    CGFloat                 curCount;           //当前计数,初始为0
    BOOL                    canNotSend;         //不能发送
    NSTimer                 *timer;
    dispatch_source_t       gcdTimer;//gcd的timer
}

@property (retain, nonatomic)   AVAudioRecorder     *recorder;

@end

@implementation ChatVoiceRecorderVC
@synthesize recorder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        maxRecordTime = kDefaultMaxRecordTime;
//        if (!_timerQueue) {
//            self.timerQueue = dispatch_queue_create("timerQueue", 0);
//        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
//    [recorder release];
//    [super dealloc];
//    dispatch_release(_timerQueue);
}

#pragma mark - 开始录音
- (void)beginRecordByFileName:(NSString*)_fileName;{
    
    //设置文件名和录音路径
    self.recordFileName = _fileName;
    self.recordFilePath = [VoiceRecorderBaseVC getPathByFileName:recordFileName ofType:@"wav"];
    
    //初始化录音
//    self.recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:recordFilePath]
//                                                settings:[VoiceRecorderBaseVC getAudioRecorderSettingDict]
//                                                  error:nil];
    self.recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:recordFilePath]
                                               settings:[VoiceRecorderBaseVC getAudioRecorderSettingDict]
                                                  error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
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
    
    
    [recorder record];
    
    //启动计时器
    [self startTimer];
}



#pragma mark - 录音结束
- (void)endRecord{

    if (recorder.isRecording)
        [recorder stop];
    
//    //回调录音文件路径
//    if ([self.vrbDelegate respondsToSelector:@selector(VoiceRecorderBaseVCRecordFinish:fileName:)]) {
//        [self.vrbDelegate VoiceRecorderBaseVCRecordFinish:recordFilePath fileName:recordFileName];
//    }
}

#pragma mark - 录音暂停
- (void)pauseRecord {
    if (recorder.isRecording) {
        [recorder pause];
    }
}

#pragma mark - 暂停后继续录音
- (void)resumeRecord {
    if (!recorder.isRecording) {
        [recorder record];
    }
}


#pragma mark -------------音频峰值----------
- (void)buildUpdateMetersBlock:(UpdateMetersBlock)block {
    if (block) {
        self.updateMetersBlock = block;
    }
}

//启动定时器
- (void)startTimer{
//    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    
//    NSLog(@"主线程:%@" , [NSThread currentThread]);
    //间隔时间
    uint64_t interval = 0.1f * NSEC_PER_SEC;
    //创建一个专门执行timer回调的GCD队列
//    if (!_timerQueue) {
//        self.timerQueue = dispatch_queue_create("timerQueue", 0);
//    }
    //创建Timer
    gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    //使用dispatch_source_set_timer函数设置timer参数
    dispatch_source_set_timer(gcdTimer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    //设置回调
    dispatch_source_set_event_handler(gcdTimer, ^() {
//        NSLog(@"Timer:%@" , [NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateMeters];
        });
    });
    //dispatch_source默认是Suspended状态，通过dispatch_resume函数开始它
    dispatch_resume(gcdTimer);
}

//停止定时器
- (void)stopTimer{
    if (timer && timer.isValid){
        [timer invalidate];
        timer = nil;
    }
    if (gcdTimer) {
        dispatch_suspend(gcdTimer);
    }
}

//更新音频峰值
- (void)updateMeters {
    if (recorder.isRecording){
        
        //更新峰值
        [recorder updateMeters];
        if (_updateMetersBlock) {
            _updateMetersBlock([recorder averagePowerForChannel:0]);
        }
//        NSLog(@"峰值:%f",[recorder averagePowerForChannel:0]);
        
        //倒计时
        if (curCount >= maxRecordTime - 10 && curCount < maxRecordTime) {
            //剩下10秒
            SCDLog(@"录音剩下:%d秒", (int)(maxRecordTime - curCount));
        } else if (curCount >= maxRecordTime){
            //时间到
            SCDLog(@"录音到T_T");
        }
        curCount += 0.1f;
    }
}

- (void)isAudioDeleted {
    SCDLog(@"录音文件被删除了");
    [self stopTimer];
    curCount = 0;
}

#pragma mark - AVAudioRecorder Delegate Methods
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    SCDLog(@"录音停止");
    [self stopTimer];
    curCount = 0;
    
    if ([self.vrbDelegate respondsToSelector:@selector(recorderDidFinishRecording:fileName:successfully:)]) {
        [self.vrbDelegate recorderDidFinishRecording:self.recorder fileName:self.recordFileName successfully:flag];
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

@end
