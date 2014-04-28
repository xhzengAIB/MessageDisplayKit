//
//  XHMessageBubbleView.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageBubbleView.h"

#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kPaddingTop 4.0f
#define kPaddingBottom 8.0f
#define kBubblePaddingRight 35.0f

#define kVoiceMargin 20.0f

@interface XHMessageBubbleView ()

@property (nonatomic, weak, readwrite) XHMessageDisplayTextView *messageDisplayTextView;

@property (nonatomic, weak, readwrite) UIImageView *bubbleImageView;

@property (nonatomic, weak, readwrite) UIImageView *animationVoiceImageView;

@property (nonatomic, weak, readwrite) XHBubblePhotoImageView *bubblePhotoImageView;

@property (nonatomic, strong, readwrite) id <XHMessageModel> message;

@end

@implementation XHMessageBubbleView

#pragma mark - Bubble view

+ (CGSize)textSizeForText:(NSString *)txt {
    CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : 0.55);
    CGFloat maxHeight = MAX([XHMessageTextView numberOfLinesForMessage:txt],
                            kXHMessageBubbleDisplayMaxLine) * [XHMessageInputView textViewLineHeight];
    maxHeight += kXHAvatarImageSize;
    
    CGSize stringSize;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_0) {
        CGRect stringRect = [txt boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{ NSFontAttributeName : [[XHMessageBubbleView appearance] font] }
                                              context:nil];
        
        stringSize = CGRectIntegral(stringRect).size;
    }
    else {
        stringSize = [txt sizeWithFont:[[XHMessageBubbleView appearance] font]
                     constrainedToSize:CGSizeMake(maxWidth, maxHeight)];
    }
    
    return CGSizeMake(roundf(stringSize.width), roundf(stringSize.height));
}

+ (CGSize)neededSizeForText:(NSString *)text {
    CGSize textSize = [XHMessageBubbleView textSizeForText:text];
    
	return CGSizeMake(textSize.width + kBubblePaddingRight,
                      textSize.height + kPaddingTop + kPaddingBottom);
}

+ (CGSize)neededSizeForPhoto:(UIImage *)photo {
    // 这里需要缩放后的size
    CGSize photoSize = CGSizeMake(100, 100);
    return photoSize;
}

+ (CGSize)neededSizeForVoicePath:(NSString *)voicePath {
    // 这里的100只是暂时固定，到时候会根据一个函数来计算
    CGSize voiceSize = CGSizeMake(100, [XHMessageInputView textViewLineHeight]);
    return voiceSize;
}

+ (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message {
    CGSize size = [XHMessageBubbleView getBubbleFrameWithMessage:message];
    return size.height + kMarginTop + kMarginBottom;
}

+ (CGSize)getBubbleFrameWithMessage:(id <XHMessageModel>)message {
    CGSize bubbleSize;
    switch (message.messageMediaType) {
        case XHBubbleMessageText: {
            bubbleSize = [XHMessageBubbleView neededSizeForText:message.text];
            break;
        }
        case XHBubbleMessagePhoto: {
            bubbleSize = [XHMessageBubbleView neededSizeForPhoto:message.photo];
            break;
        }
        case XHBubbleMessageVideo: {
            bubbleSize = [XHMessageBubbleView neededSizeForPhoto:message.videoConverPhoto];
            break;
        }
        case XHBubbleMessagevoice: {
            bubbleSize = CGSizeMake(100, [XHMessageInputView textViewLineHeight]);
            break;
        }
        default:
            break;
    }
    return bubbleSize;
}

#pragma mark - UIAppearance Getters

- (UIFont *)font {
    if (_font == nil) {
        _font = [[[self class] appearance] font];
    }
    
    if (_font != nil) {
        return _font;
    }
    
    return [UIFont systemFontOfSize:16.0f];
}

#pragma mark - Getters

- (CGRect)bubbleFrame {
    CGSize bubbleSize = [XHMessageBubbleView getBubbleFrameWithMessage:self.message];
    
    return CGRectIntegral(CGRectMake((self.message.bubbleMessageType == XHBubbleMessageTypeSending ? CGRectGetWidth(self.bounds) - bubbleSize.width : 0.0f),
                                     kMarginTop,
                                     bubbleSize.width,
                                     bubbleSize.height + kMarginBottom));
}

#pragma mark - Life cycle

- (void)configureCellWithMessage:(id <XHMessageModel>)message {
    _message = message;
    
    [self configureBubbleImageView:message];
    
    [self configureMessageDisplayMediaWithMessage:message];
}

- (void)configureBubbleImageView:(id <XHMessageModel>)message {
    XHBubbleMessageMediaType currentType = message.messageMediaType;
    if (currentType == XHBubbleMessageText || currentType == XHBubbleMessagevoice) {
        _bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:XHBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
        _bubbleImageView.hidden = NO;
        
        _bubblePhotoImageView.hidden = YES;
        
        if (currentType == XHBubbleMessageText) {
            _messageDisplayTextView.hidden = NO;
            _animationVoiceImageView.hidden = YES;
        } else {
            _messageDisplayTextView.hidden = YES;
            [_animationVoiceImageView removeFromSuperview];
            _animationVoiceImageView = nil;
            
            UIImageView *animationVoiceImageView = [XHMessageVoiceFactory messageVoiceAnimationImageViewWithBubbleMessageType:message.bubbleMessageType];
            [self addSubview:animationVoiceImageView];
            _animationVoiceImageView = animationVoiceImageView;
            _animationVoiceImageView.hidden = NO;
        }
    } else {
        _bubblePhotoImageView.hidden = NO;
        _messageDisplayTextView.hidden = YES;
        _bubbleImageView.hidden = YES;
    }
}

- (void)configureMessageDisplayMediaWithMessage:(id <XHMessageModel>)message {
    switch (message.messageMediaType) {
        case XHBubbleMessageText:
            _messageDisplayTextView.text = message.text;
            break;
        case XHBubbleMessagePhoto:
            [_bubblePhotoImageView configureMessagePhoto:message.photo onBubbleMessageType:self.message.bubbleMessageType];
            break;
        case XHBubbleMessageVideo:
            _bubblePhotoImageView.messagePhoto = message.videoConverPhoto;
            break;
        case XHBubbleMessagevoice:
            break;
        default:
            break;
    }
    
    [self setNeedsLayout];
}

- (instancetype)initWithFrame:(CGRect)frame
                      message:(id <XHMessageModel>)message {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _message = message;
        
        // 1、初始化气泡的背景
        if (!_bubbleImageView) {
            //bubble image
            UIImageView *bubbleImageView = [[UIImageView alloc] init];
            bubbleImageView.frame = self.bounds;
            bubbleImageView.userInteractionEnabled = YES;
            [self addSubview:bubbleImageView];
            _bubbleImageView = bubbleImageView;
        }
        
        // 2、初始化显示文本消息的TextView
        if (!_messageDisplayTextView) {
            XHMessageDisplayTextView *messageDisplayTextView = [[XHMessageDisplayTextView alloc] initWithFrame:CGRectZero];
            messageDisplayTextView.font = [UIFont systemFontOfSize:16.0f];
            messageDisplayTextView.textColor = [UIColor blackColor];
            messageDisplayTextView.editable = NO;
            if ([messageDisplayTextView respondsToSelector:@selector(setSelectable:)])
                messageDisplayTextView.selectable = NO;
            messageDisplayTextView.userInteractionEnabled = YES;
            messageDisplayTextView.showsHorizontalScrollIndicator = NO;
            messageDisplayTextView.showsVerticalScrollIndicator = NO;
            messageDisplayTextView.scrollEnabled = NO;
            messageDisplayTextView.backgroundColor = [UIColor clearColor];
            messageDisplayTextView.contentInset = UIEdgeInsetsZero;
            messageDisplayTextView.scrollIndicatorInsets = UIEdgeInsetsZero;
            messageDisplayTextView.contentOffset = CGPointZero;
            messageDisplayTextView.dataDetectorTypes = UIDataDetectorTypeAll;
            [self addSubview:messageDisplayTextView];
            _messageDisplayTextView = messageDisplayTextView;
            
            if ([_messageDisplayTextView respondsToSelector:@selector(textContainerInset)]) {
                _messageDisplayTextView.textContainerInset = UIEdgeInsetsMake(8.0f, 4.0f, 2.0f, 4.0f);
            }
        }
        
        // 3、初始化显示图片的控件
        if (!_bubblePhotoImageView) {
            XHBubblePhotoImageView *bubblePhotoImageView = [[XHBubblePhotoImageView alloc] initWithFrame:CGRectZero];
            [self addSubview:bubblePhotoImageView];
            _bubblePhotoImageView = bubblePhotoImageView;
        }
    }
    return self;
}

- (void)dealloc {
    _bubbleImageView = nil;
    _bubblePhotoImageView = nil;
    _animationVoiceImageView = nil;
    _font = nil;
    _message = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    XHBubbleMessageMediaType currentType = self.message.messageMediaType;
    CGRect bubbleFrame = [self bubbleFrame];
    
    switch (currentType) {
        case XHBubbleMessageText:
        case XHBubbleMessagevoice: {
            self.bubbleImageView.frame = bubbleFrame;
            
            CGFloat textX = self.bubbleImageView.frame.origin.x;
            
            if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
                textX += (self.bubbleImageView.image.capInsets.left / 2.0f);
            }
            
            CGRect textFrame = CGRectMake(textX,
                                          bubbleFrame.origin.y,
                                          bubbleFrame.size.width - (self.bubbleImageView.image.capInsets.right / 2.0f),
                                          bubbleFrame.size.height - kMarginTop);
            
            self.messageDisplayTextView.frame = CGRectIntegral(textFrame);
            
            CGRect animationVoiceImageViewFrame = self.animationVoiceImageView.frame;
            animationVoiceImageViewFrame.origin = CGPointMake((self.message.bubbleMessageType == XHBubbleMessageTypeReceiving ? (bubbleFrame.origin.x + kVoiceMargin) : (bubbleFrame.origin.x + CGRectGetWidth(bubbleFrame) - kVoiceMargin - CGRectGetWidth(animationVoiceImageViewFrame))), 17);
            self.animationVoiceImageView.frame = animationVoiceImageViewFrame;
            break;
        }
        case XHBubbleMessagePhoto:
        case XHBubbleMessageVideo: {
            CGRect photoImageViewFrame = CGRectMake(bubbleFrame.origin.x - 2, 0, bubbleFrame.size.width, bubbleFrame.size.height);
            self.bubblePhotoImageView.frame = photoImageViewFrame;
            break;
        }
        default:
            break;
    }
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
