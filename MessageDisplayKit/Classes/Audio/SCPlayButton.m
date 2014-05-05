//
//  SCPlayButton.m
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-24.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCPlayButton.h"
#import "SCAudioPlayerManager.h"
#import "SCDefines.h"

#import "SCAudioRecordManager.h"

//#import "SCHttpClient.h"



#define DARK_GREEN_COLOR        [UIColor colorWithRed:10/255.0f green:107/255.0f blue:42/255.0f alpha:1.f]    //深绿色
#define LIGHT_GREEN_COLOR       [UIColor colorWithRed:143/255.0f green:191/255.0f blue:62/255.0f alpha:1.f]    //浅绿色

//#define NORMAL_IMAGE        [UIImage imageNamed:@"play_audio.png"]
#define NORMAL_IMAGE        [UIImage imageNamed:@"play_audio_v20.png"]
#define SELECTED_IMAGE      [UIImage imageNamed:@"pause_audio.png"]



@interface SCPlayButtonCirCle : UIView

@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL isFinishDownload;

@end

@implementation SCPlayButtonCirCle

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextSetStrokeColorWithColor(context, _progressColor.CGColor);
    //    CGContextSetLineWidth(context, 1.f);
    CGContextSetLineWidth(context, 3.f);
    //    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);//填充颜色
    CGFloat startAngle = (_isFinishDownload ? 0 : _progress * M_PI * 2);
    CGFloat endAngle = (_isFinishDownload ? _progress * M_PI * 2 : M_PI * 2 - _progress * M_PI * 2);
    CGFloat radius = NORMAL_IMAGE.size.width / 2 - 3;//NORMAL_IMAGE.size.width / 2;
    CGContextAddArc(context, self.frame.size.width / 2, self.frame.size.height / 2, radius, startAngle, endAngle, 0);
    CGContextDrawPath(context, kCGPathStroke);//kCGPathFillStroke
}

@end







@interface SCPlayButton() <SCAudioPlayerManagerDelegate> {
    NSTimer *timer;
    BOOL downloadDone;
}

@property (nonatomic, strong) UITapGestureRecognizer *tapGes;

@property (nonatomic, strong) SCPlayButtonCirCle *circle;

@end

@implementation SCPlayButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.progressColor = LIGHT_GREEN_COLOR;
        self.isFinishDownload = YES;
        self.toDrawCircle = YES;
        
        [self addTarget:self action:@selector(playBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self setBackgroundImage:NORMAL_IMAGE forState:UIControlStateNormal];
        [self setBackgroundImage:SELECTED_IMAGE forState:UIControlStateSelected];
//    [self setImage:NORMAL_IMAGE forState:UIControlStateNormal];
//    [self setImage:SELECTED_IMAGE forState:UIControlStateSelected];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) {
            if (!_tapGes) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playBtnPressed:)];
                self.tapGes = tap;
                [self addGestureRecognizer:tap];
            }
        }
    }
    return self;
}

- (void)dealloc {
    [[SCAudioPlayerManager shareInstance] setDelegate:nil];
    self.tapGes = nil;
}

//- (void)didMoveToSuperview {
//    [super didMoveToSuperview];
//    [[SCAudioPlayerManager shareInstance] setDelegate:self];
//}

- (void)playBtnPressed:(id)sender {
    
    if (_willPressPlayBtnBlock) {
        BOOL shouldStop = _willPressPlayBtnBlock();
        if (shouldStop == YES) {
            [[SCAudioPlayerManager shareInstance] stopAudio];
            return;
        }
    }
    
    if ([self isEmpty:_amrFile] == NO) {
        [[SCAudioPlayerManager shareInstance] setDelegate:self];
        
        NSString *fileName = [[_amrFile lastPathComponent] stringByDeletingPathExtension];
        
        //先去目录里查找有没有名为：fileName 这个文件，有的话直接播放，没的话才需要下载
        BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:[SCAudioRecordManager getPathByFileName:fileName ofType:@"amr"]];
        if (isFileExist) {
            [self playLocalFile];
            return;
        }
        //下面两种二选一
        if (_downloadFileBlock) {
            _downloadFileBlock();
        } else {
            [self downLoadWithSCHttpClientWithAmrName:fileName];
        }
    }
//    else if ([self isEmpty:fileName] == NO) {
//        [self playLocalFile];
//    }
    
//    if ([self isEmpty:_amrFileUrl] == NO) {
//        [[SCAudioPlayerManager shareInstance] setDelegate:self];
//        
//        self.amrFileName = [[_amrFileUrl lastPathComponent] stringByDeletingPathExtension];
//        
//        //先去目录里查找有没有名为：_amrFileName这个文件，有的话直接播放，没的话才需要下载
//        BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:[VoiceRecorderBaseVC getPathByFileName:_amrFileName ofType:@"amr"]];
//        if (isFileExist) {
//            [self playLocalFile];
//            return;
//        }
//        //下面两种二选一
//        if (_downloadFileBlock) {
//            _downloadFileBlock();
//        } else {
//            [self downLoadWithSCHttpClientWithAmrName:_amrFileName];
//        }
//        
//    } else if ([self isEmpty:_amrFileName] == NO) {
//        [self playLocalFile];
//    }
}

+ (NSString*)getFileNameStr:(NSString*)originStr {
    return [[originStr lastPathComponent] stringByDeletingPathExtension];
}

- (void)playLocalFile {
    [[SCAudioPlayerManager shareInstance] setDelegate:self];
    
    self.selected = !self.selected;
    [[SCAudioPlayerManager shareInstance] managerAudioWithFileName:[SCPlayButton getFileNameStr:_amrFile] toPlay:self.selected];
//    [[SCAudioPlayerManager shareInstance] managerAudioWithFileName:_amrFileName toPlay:self.selected];
}

- (BOOL)isEmpty:(NSString*)string {
    return (!string || [string isEqual:[NSNull null]] || string.length <= 0 ? YES : NO);
}

- (void)startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

- (void)updateProgress {
    AVAudioPlayer *player = [[SCAudioPlayerManager shareInstance] player];
    if (player && player.isPlaying) {
        self.progress = (float)player.currentTime / (float)player.duration;
    }
}

//停止定时器
- (void)stopTimer {
    self.selected = NO;
    
//    AVAudioPlayer *player = [[SCAudioPlayerManager shareInstance] player];
//    if (player) {
//        player.currentTime = 0;
//    }
    
    if (timer && timer.isValid) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)setProgress:(float)progress {
//    if (_progress != progress) {
        _progress = progress;
        
//        if (_progress >= 0.999) {
//            _progress = 1;
//        }
        if (_didUpdatePlayProgressBlock) {
            _didUpdatePlayProgressBlock(_progress);
        }
        
        if (_toDrawCircle && _progress >= 0) {
            [self setNeedsDisplay];
        }
    if (_progress == 1) {
        [self stopTimer];
    }
//    }
}

- (void)buildDidUpdatePlayProgressBlock:(DidUpdatePlayProgress)block {
    if (block) {
        self.didUpdatePlayProgressBlock = block;
    }
}

//根据url下载文件（如果不想引进AFNetworking(SCHttpClient封装好了)，可以自己用此block去用）
- (void)buildDownloadFileBlock:(DownloadFileBlock)block {
    if (block) {
        self.downloadFileBlock = block;
    }
}

- (void)buildWillPressPlayBtnBlock:(WillPressPlayBtnBlock)block {
    if (block) {
        self.willPressPlayBtnBlock = block;
    }
}

- (void)downLoadWithSCHttpClientWithAmrName:(NSString*)amrName {
    
    /*
    WEAKSELF_SC
    [[SCHttpClient sharedInstance] httpDownloadWithUrl:_amrFile filePath:[VoiceRecorderBaseVC getCacheDirectory] fileName:amrName extName:@"amr" downloadingBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (totalBytesRead == totalBytesExpectedToRead) {
            SCDLog(@"download amr done in feed:%lldB", totalBytesExpectedToRead);
        }
    } apiDataErrorBlock:^(NSDictionary *dict) {
        ;
    } successBlock:^(NSDictionary *dict) {
        [weakSelf_SC playLocalFile];
    } failureBlock:^(NSError *error) {
        ;
    }];
     */
}

#pragma mark - audio player manager delegate
- (void)didAudioPlayerBeginPlay:(AVAudioPlayer *)audioPlayer {
    [self startTimer];
}

- (void)didAudioPlayerPausePlay:(AVAudioPlayer *)audioPlayer {
    if (audioPlayer) {
        self.progress = (float)audioPlayer.currentTime / (float)audioPlayer.duration;
    }
    [self stopTimer];
}

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiChangeGlobalPlayBtn object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kPlayBtnMakeVisible, nil]];//将页面里一个全局的playBtn隐藏掉
    if (audioPlayer) {
        audioPlayer.currentTime = 0;
    }
    [self stopTimer];
    self.progress = 1;
    double delayInSeconds = 0.3f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.progress = 0;
//        [self stopTimer];
    });
}


#pragma mark -drawRect
- (void)drawRect:(CGRect)rect {
    
//#warning 画的圆不圆，暂时取消掉
//    return;
    
    
    if (!_toDrawCircle || _progress <= 0) {// || !self.selected) {
        if (_circle) {
            _circle.progress = _progress;
            _circle.isFinishDownload = _isFinishDownload;
            [_circle setNeedsDisplay];
        }
        return;
    }
    
    if (!_circle) {
        SCPlayButtonCirCle *tmp = [[SCPlayButtonCirCle alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        tmp.backgroundColor = [UIColor clearColor];
        tmp.userInteractionEnabled = NO;
        tmp.progressColor = _progressColor;
        [self addSubview:tmp];
        self.circle = tmp;
    }
    _circle.progress = _progress;
    _circle.isFinishDownload = _isFinishDownload;
    [_circle setNeedsDisplay];
    
//    return;
    
    
    /* 下面的是将进度的圆圈画在外面
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    CGContextSetStrokeColorWithColor(context, _progressColor.CGColor);
    CGContextSetLineWidth(context, 1.f);
//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);//填充颜色
    CGFloat startAngle = (_isFinishDownload ? 0 : _progress * M_PI * 2);
    CGFloat endAngle = (_isFinishDownload ? _progress * M_PI * 2 : M_PI * 2 - _progress * M_PI * 2);
    CGFloat radius = NORMAL_IMAGE.size.width / 2;
    CGContextAddArc(context, self.frame.size.width / 2, self.frame.size.height / 2, radius, startAngle, endAngle, 0);
    CGContextDrawPath(context, kCGPathStroke);//kCGPathFillStroke
    */
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end


