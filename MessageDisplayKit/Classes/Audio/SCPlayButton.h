//
//  SCPlayButton.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-24.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPlayBtnMakeVisible    @"kPlayBtnMakeVisible"   //1个全局的按钮   1为不停止/显示  0为停止/隐藏
//#define kPlayBtnAmrFileName @"kPlayBtnAmrFileName"
//#define kPlayBtnAmrFileUrl  @"kPlayBtnAmrFileUrl"
#define kNotiChangeGlobalPlayBtn        @"kNotiChangeGlobalPlayBtn"

typedef void(^DidUpdatePlayProgress)(float progress);
typedef void(^DownloadFileBlock)();
typedef BOOL(^WillPressPlayBtnBlock)();

typedef enum {
    SCPlayButtonStateDownload   =   0,
    SCPlayButtonStatePlay       =   1
} SCPlayButtonState;

@interface SCPlayButton : UIButton

@property (nonatomic, assign) float progress;
@property (nonatomic, assign) BOOL isFinishDownload;//已下载完毕
@property (nonatomic, strong) UIColor *progressColor;

//@property (nonatomic, copy) NSString *amrFileName;
@property (nonatomic, copy) NSString *amrFile;

@property (nonatomic, copy) DidUpdatePlayProgress didUpdatePlayProgressBlock;
@property (nonatomic, copy) DownloadFileBlock downloadFileBlock;
@property (nonatomic, copy) WillPressPlayBtnBlock willPressPlayBtnBlock;

@property (nonatomic, assign) BOOL toDrawCircle;

@property (nonatomic, assign) BOOL shouldStop;
//- (void)setProgress:(float)progress animated:(BOOL)animated;

//滤镜页面的进度条
- (void)buildDidUpdatePlayProgressBlock:(DidUpdatePlayProgress)block;

//根据url下载文件（如果不想引进AFNetworking(SCHttpClient封装好了)，可以自己用此block去用）
- (void)buildDownloadFileBlock:(DownloadFileBlock)block;

//将要按下按钮时的回调（动态列表要用到，重新赋一些值，不然button在表现上可能会重用了，如不同cell进度条一样）
- (void)buildWillPressPlayBtnBlock:(WillPressPlayBtnBlock)block;

//去掉http://xxx 等，并去掉后缀
+ (NSString*)getFileNameStr:(NSString*)originStr;
@end
