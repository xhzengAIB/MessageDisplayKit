//
//  XHEmotionCollectionViewCell.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHEmotionCollectionViewCell.h"

@interface XHEmotionCollectionViewCell ()

/**
 *  显示表情封面的控件
 */
@property (nonatomic, weak) UIImageView *emotionImageView;

/**
 *  配置默认控件和参数
 */
- (void)setup;
@end

@implementation XHEmotionCollectionViewCell

#pragma setter method

- (void)setEmotion:(XHEmotion *)emotion {
    _emotion = emotion;
    
    // TODO:
    self.emotionImageView.image = emotion.emotionConverPhoto;
}

#pragma mark - Life cycle

- (void)setup {
    if (!_emotionImageView) {
        UIImageView *emotionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kXHEmotionImageViewSize, kXHEmotionImageViewSize)];
        emotionImageView.backgroundColor = [UIColor colorWithRed:0.000 green:0.251 blue:0.502 alpha:1.000];
        [self.contentView addSubview:emotionImageView];
        self.emotionImageView = emotionImageView;
    }
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.emotion = nil;
}

@end
