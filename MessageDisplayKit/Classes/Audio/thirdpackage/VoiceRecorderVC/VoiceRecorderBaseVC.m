//
//  VoiceRecorderBaseVC.m
//  Jeans
//
//  Created by Jeans on 3/23/13.
//  Copyright (c) 2013 Jeans. All rights reserved.
//

#import "VoiceRecorderBaseVC.h"

@interface VoiceRecorderBaseVC ()
@end

@implementation VoiceRecorderBaseVC
@synthesize vrbDelegate,maxRecordTime,recordFileName,recordFilePath;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        maxRecordTime = kDefaultMaxRecordTime;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.recordFilePath = nil;
    self.recordFileName = nil;
//    [super dealloc];
}

/**
	生成当前时间字符串
	@returns 当前时间字符串
 */
+ (NSString*)getCurrentTimeString {
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [dateformat stringFromDate:[NSDate date]];
    dateStr = [dateStr stringByAppendingString:AUDIO_LOCAL_FILE];
    return dateStr;
}


/**
	获取缓存路径
	@returns 缓存路径
 */
+ (NSString*)getCacheDirectory
{
    //1、存在/documents/Audio
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *audioDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Audio"];
    BOOL isDir = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:audioDir isDirectory:&isDir] == NO) {
        BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:audioDir withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isSuccess) {
            NSLog(@"创建audio目录失败了，为毛T_T");
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
	判断文件是否存在
	@param _path 文件路径
	@returns 存在返回yes
 */
+ (BOOL)fileExistsAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:_path];
}

/**
	删除文件
	@param _path 文件路径
	@returns 成功返回yes
 */
+ (BOOL)deleteFileAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
}
    
/**
	生成文件路径
	@param _fileName 文件名
	@param _type 文件类型
	@returns 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type
{
    NSString* fileDirectory = [[[VoiceRecorderBaseVC getCacheDirectory]stringByAppendingPathComponent:_fileName]stringByAppendingPathExtension:_type];
    return fileDirectory;
}

/**
 生成文件路径
 @param _fileName 文件名
 @returns 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)_fileName{
    NSString* fileDirectory = [[VoiceRecorderBaseVC getCacheDirectory]stringByAppendingPathComponent:_fileName];
    return fileDirectory;
}

/**
	获取录音设置
	@returns 录音设置
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
//    return [recordSetting autorelease];
}



@end
