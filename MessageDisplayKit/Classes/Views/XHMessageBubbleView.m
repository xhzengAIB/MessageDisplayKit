//
//  XHMessageBubbleView.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageBubbleView.h"

@interface XHMessageBubbleView ()

@property (nonatomic, weak, readwrite) UITextView *messageDisplayTextView;
@property (nonatomic, weak, readwrite) UIImageView *bubbleImageView;

@end

@implementation XHMessageBubbleView

+ (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message {
    return 44;
}

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
                   bubbleType:(XHBubbleMessageType)bubleType {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _bubleType = bubleType;
        
        //bubble image
        UIImageView *bubbleImageView = [XHMessageBubbleFactory bubbleImageViewForType:bubleType style:XHBubbleImageViewStyleWeChat meidaType:XHBubbleMessageText];
        bubbleImageView.frame = self.bounds;
        [self addSubview:bubbleImageView];
        _bubbleImageView = bubbleImageView;
        
        CGRect messageDisplayTextViewFrame;
        switch (bubleType) {
            case XHBubbleMessageTypeSending:
                messageDisplayTextViewFrame = CGRectMake(4, 0, CGRectGetWidth(self.bounds) - 10, CGRectGetHeight(self.bounds));
                break;
            case XHBubbleMessageTypeReceiving:
                messageDisplayTextViewFrame = CGRectMake(10, 0, CGRectGetWidth(self.bounds) - 9, CGRectGetHeight(self.bounds));
                break;
            default:
                break;
        }
        
        // demo label
        UITextView *messageDisplayTextView = [[UITextView alloc] initWithFrame:messageDisplayTextViewFrame];
        messageDisplayTextView.text = @"这是华捷微信，为什么模仿这个页面效果呢？希望微信团队能看到我们在努力，请微信团队给个机会，让我好好的努力靠近大神，希望自己也能发亮，好像有点过分的希望了，如果大家喜欢这个开源库，请大家帮帮忙支持这个开源库吧！我是Jack，叫华仔也行，曾宪华就是我啦！Call Me 15915895880";
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
        [self addSubview:messageDisplayTextView];
        [self bringSubviewToFront:messageDisplayTextView];
        _messageDisplayTextView = messageDisplayTextView;
        
        if ([_messageDisplayTextView respondsToSelector:@selector(textContainerInset)]) {
            _messageDisplayTextView.textContainerInset = UIEdgeInsetsMake(8.0f, 4.0f, 2.0f, 4.0f);
        }
    }
    return self;
}

- (void)dealloc {
    
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
