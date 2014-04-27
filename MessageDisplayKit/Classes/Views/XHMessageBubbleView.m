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

@interface XHMessageBubbleView ()

@property (nonatomic, weak, readwrite) UITextView *messageDisplayTextView;
@property (nonatomic, weak, readwrite) UIImageView *bubbleImageView;

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

+ (CGSize)neddedSizeForPhoto:(UIImage *)photo {
    // 这里需要缩放后的size
    CGSize photoSize = CGSizeMake(100, 100);
    return photoSize;
}

+ (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message {
    CGSize size;
    switch (message.messageMediaType) {
        case XHBubbleMessageText: {
            size = [XHMessageBubbleView neededSizeForText:message.text];
            break;
        }
        case XHBubbleMessagePhoto: {
            size = [XHMessageBubbleView neddedSizeForPhoto:message.photo];
            break;
        }
        case XHBubbleMessageVideo: {
            size = [XHMessageBubbleView neddedSizeForPhoto:message.videoConverPhoto];
            break;
        }
        case XHBubbleMessageVioce: {
            size = CGSizeMake(100, [XHMessageInputView textViewLineHeight]);
            break;
        }
        default:
            break;
    }
    return size.height + kMarginTop + kMarginBottom;
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
    CGSize bubbleSize;
    switch (self.message.messageMediaType) {
        case XHBubbleMessageText: {
            bubbleSize = [XHMessageBubbleView neededSizeForText:self.message.text];
            break;
        }
        case XHBubbleMessagePhoto: {
            bubbleSize = [XHMessageBubbleView neddedSizeForPhoto:self.message.photo];
            break;
        }
        case XHBubbleMessageVideo: {
            bubbleSize = [XHMessageBubbleView neddedSizeForPhoto:self.message.videoConverPhoto];
            break;
        }
        case XHBubbleMessageVioce: {
            bubbleSize = CGSizeMake(100, [XHMessageInputView textViewLineHeight]);
            break;
        }
        default:
            break;
    }
    
    return CGRectIntegral(CGRectMake((self.message.bubbleMessageType == XHBubbleMessageTypeSending ? CGRectGetWidth(self.bounds) - bubbleSize.width : 0.0f),
                                     kMarginTop,
                                     bubbleSize.width,
                                     bubbleSize.height + kMarginBottom));
}

#pragma mark - Life cycle

- (void)configureCellWithMessage:(id <XHMessageModel>)message {
    _message = message;
    
    [self configureBubbleImageView:message];
    
    [self configureMessageDisplayTextViewWithMessage:message];
}

- (void)configureBubbleImageView:(id <XHMessageModel>)message {
    if (message.bubbleMessageType == XHBubbleMessageText) {
        _bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:XHBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
    } else {
        _bubbleImageView.image = nil;
    }
}

- (void)configureMessageDisplayTextViewWithMessage:(id <XHMessageModel>)message {
    switch (message.messageMediaType) {
        case XHBubbleMessageText:
            _messageDisplayTextView.text = message.text;
            break;
        case XHBubbleMessagePhoto:
            _bubblePhotoImageView.messagePhoto = message.photo;
            break;
        case XHBubbleMessageVideo:
            break;
        case XHBubbleMessageVioce:
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
        
        if (!_bubbleImageView) {
            //bubble image
            UIImageView *bubbleImageView = [[UIImageView alloc] init];
            bubbleImageView.frame = self.bounds;
            [self addSubview:bubbleImageView];
            _bubbleImageView = bubbleImageView;
        }
        
        if (!_messageDisplayTextView) {
            UITextView *messageDisplayTextView = [[UITextView alloc] initWithFrame:CGRectZero];
            messageDisplayTextView.font = [UIFont systemFontOfSize:16.0f];
            messageDisplayTextView.textColor = [UIColor blackColor];
            messageDisplayTextView.editable = NO;
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
        
        if (!_bubblePhotoImageView) {
            XHBubblePhotoImageView *bubblePhotoImageView = [[XHBubblePhotoImageView alloc] initWithFrame:CGRectZero messagePhoto:nil rightArrow:(message.bubbleMessageType == XHBubbleMessageTypeSending ? YES : NO)];
            [self addSubview:bubblePhotoImageView];
            _bubblePhotoImageView = bubblePhotoImageView;
        }
    }
    return self;
}

- (void)dealloc {
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bubbleImageView.frame = [self bubbleFrame];
    
    CGFloat textX = self.bubbleImageView.frame.origin.x;
    
    if (self.message.bubbleMessageType == XHBubbleMessageTypeReceiving) {
        textX += (self.bubbleImageView.image.capInsets.left / 2.0f);
    }
    
    CGRect textFrame = CGRectMake(textX,
                                  self.bubbleImageView.frame.origin.y,
                                  self.bubbleImageView.frame.size.width - (self.bubbleImageView.image.capInsets.right / 2.0f),
                                  self.bubbleImageView.frame.size.height - kMarginTop);
    
    self.messageDisplayTextView.frame = CGRectIntegral(textFrame);
    
    self.bubblePhotoImageView.frame = CGRectMake([self bubbleFrame].origin.x - 2, 0, [self bubbleFrame].size.width, [self bubbleFrame].size.height);
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
