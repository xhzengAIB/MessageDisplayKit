//
//  XHMessageInputView.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHMessageTextView.h"

typedef NS_ENUM(NSInteger, XHMessageInputViewStyle) {
    // 分两种,一种是iOS6样式的，一种是iOS7样式的
    XHMessageInputViewStyleQuasiphysical,
    XHMessageInputViewStyleFlat
};

@interface XHMessageInputView : UIImageView

/**
 *  用于输入文本消息的输入框
 */
@property (nonatomic, strong, readonly) XHMessageTextView *inputTextView;

/**
 *  当前输入工具条的样式
 */
@property (assign, nonatomic) XHMessageInputViewStyle messageInputViewStyle;  // default is XHMessageInputViewStyleFlat

/**
 *  是否允许发送语音
 */
@property (nonatomic, assign) BOOL allowsSendVoice; // default is YES

/**
 *  是否允许发送多媒体
 */
@property (nonatomic, assign) BOOL allowsSendMultiMedia; // default is YES

/**
 *  是否支持发送表情
 */
@property (nonatomic, assign) BOOL allowsSendFace; // default is YES


#pragma mark - Message input view

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;

/**
 *  获取输入框内容字体行高
 *
 *  @return 返回行高
 */
+ (CGFloat)textViewLineHeight;

/**
 *  获取最大行数
 *
 *  @return 返回最大行数
 */
+ (CGFloat)maxLines;

/**
 *  获取根据最大行数和每行高度计算出来的最大显示高度
 *
 *  @return 返回最大显示高度
 */
+ (CGFloat)maxHeight;


@end
