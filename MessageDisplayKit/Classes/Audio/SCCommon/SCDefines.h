//
//  SCDefines.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-25.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#ifndef SCCaptureCameraDemo_SCDefines_h
#define SCCaptureCameraDemo_SCDefines_h


/**
 *  音频：所需Framewokds：AudioToolBox、AVFoundation、CoreAudio
 *  编辑调试断点All Exception（有的话），将All改为Objective-C。不然有个C++的东西会报停。
 */


// Debug Logging
#if 1 // Set to 1 to enable debug logging
#define SCDLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define SCDLog(x, ...)
#endif


//weakself
#define WEAKSELF_SC __weak __typeof(&*self)weakSelf_SC = self;


//color
#define rgba(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//frame and size
#define SC_DEVICE_BOUNDS    [[UIScreen mainScreen] bounds]
#define SC_DEVICE_SIZE      [[UIScreen mainScreen] bounds].size

#define SC_APP_FRAME        [[UIScreen mainScreen] applicationFrame]
#define SC_APP_SIZE         [[UIScreen mainScreen] applicationFrame].size


// 是否iPad
#define isPad_SC (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)//设备类型改为Universal才能生效
#define isPad_AllTargetMode_SC ([[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound)//设备类型为任何类型都能生效

//是否iPhone5及以上设备
#define isHigherThaniPhone4_SC ((isPad_AllTargetMode_SC && [[UIScreen mainScreen] applicationFrame].size.height <= 960 ? NO : ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height > 960 ? YES : NO) : NO)))


#if __IPHONE_6_0 // iOS6 and later

#   define kTextAlignmentCenter_SC    NSTextAlignmentCenter
#   define kTextAlignmentLeft_SC      NSTextAlignmentLeft
#   define kTextAlignmentRight_SC     NSTextAlignmentRight

#   define kTextLineBreakByWordWrapping_SC      NSLineBreakByWordWrapping
#   define kTextLineBreakByCharWrapping_SC      NSLineBreakByCharWrapping
#   define kTextLineBreakByClipping_SC          NSLineBreakByClipping
#   define kTextLineBreakByTruncatingHead_SC    NSLineBreakByTruncatingHead
#   define kTextLineBreakByTruncatingTail_SC    NSLineBreakByTruncatingTail
#   define kTextLineBreakByTruncatingMiddle_SC  NSLineBreakByTruncatingMiddle

#else // older versions

#   define kTextAlignmentCenter_SC    UITextAlignmentCenter
#   define kTextAlignmentLeft_SC      UITextAlignmentLeft
#   define kTextAlignmentRight_SC     UITextAlignmentRight

#   define kTextLineBreakByWordWrapping_SC       UILineBreakModeWordWrap
#   define kTextLineBreakByCharWrapping_SC       UILineBreakModeCharacterWrap
#   define kTextLineBreakByClipping_SC           UILineBreakModeClip
#   define kTextLineBreakByTruncatingHead_SC     UILineBreakModeHeadTruncation
#   define kTextLineBreakByTruncatingTail_SC     UILineBreakModeTailTruncation
#   define kTextLineBreakByTruncatingMiddle_SC   UILineBreakModeMiddleTruncation

#endif


#endif
