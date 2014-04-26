//
//  XHMessageTableViewCell.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageTableViewCell.h"

static const CGFloat kXHLabelPadding = 5.0f;
static const CGFloat kXHTimeStampLabelHeight = 15.0f;

CGFloat const kXHAvatarImageSize = 40.0f;

@interface XHMessageTableViewCell () {
    
}

@property (nonatomic, weak, readwrite) UIButton *avatorButton;
@property (nonatomic, weak, readwrite) XHMessageBubbleView *messageBubbleView;

@end

@implementation XHMessageTableViewCell

#pragma mark - Copying

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copyed:) || action == @selector(transpond:) || action == @selector(favorites:) || action == @selector(more:));
}

- (void)copyed:(id)sender {
    [[UIPasteboard generalPasteboard] setString:@"曾宪华，Jack"];
    [self resignFirstResponder];
    DLog(@"Cell was copy");
    
}
- (void)transpond:(id)sender {
    DLog(@"Cell was transpond");
}

- (void)favorites:(id)sender {
    DLog(@"Cell was favorites");
}

- (void)more:(id)sender {
    DLog(@"Cell was more");
}

#pragma mark - Gestures

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;
    
    UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"copy", @"MessageDisplayKitString", @"复制文本消息") action:@selector(copyed:)];
    UIMenuItem *transpond = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"transpond", @"MessageDisplayKitString", @"转发") action:@selector(transpond:)];
    UIMenuItem *favorites = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"favorites", @"MessageDisplayKitString", @"收藏") action:@selector(favorites:)];
    UIMenuItem *more = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"more", @"MessageDisplayKitString", @"更多") action:@selector(more:)];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:[NSArray arrayWithObjects:copy, transpond, favorites, more, nil]];
    
    
    CGRect targetRect = [self convertRect:self.messageBubbleView.frame
                                 fromView:self.messageBubbleView];
    
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

#pragma mark - Life cycle

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleLongPressGesture:)];
    [recognizer setMinimumPressDuration:0.4f];
    [self addGestureRecognizer:recognizer];
    
    
    UITapGestureRecognizer *tabpGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHandle:)];
    [self addGestureRecognizer:tabpGestureRecognizer];
}

- (instancetype)initWithBubbleMessageType:(XHBubbleMessageType)type
                        displaysTimestamp:(BOOL)displayTimestamp
                          reuseIdentifier:(NSString *)cellIdentifier {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if (self) {
        // 如果初始化成功，那就根据Message类型进行初始化控件，比如配置头像，配置发送和接收的样式
        
        // avator
        CGRect avatorButtonFrame;
        switch (type) {
            case XHBubbleMessageTypeReceiving:
                avatorButtonFrame = CGRectMake(8, 15, kXHAvatarImageSize, kXHAvatarImageSize);
                break;
            case XHBubbleMessageTypeSending:
                avatorButtonFrame = CGRectMake(CGRectGetWidth(self.bounds) - kXHAvatarImageSize - 8, 15, kXHAvatarImageSize, kXHAvatarImageSize);
                break;
                
            default:
                break;
        }
        
        UIButton *avatorButton = [[UIButton alloc] initWithFrame:avatorButtonFrame];
        [avatorButton setImage:[XHMessageAvatorFactory avatarImageNamed:[UIImage imageNamed:@"meIcon"] messageAvatorType:XHMessageAvatorCircle] forState:UIControlStateNormal];
        [self.contentView addSubview:avatorButton];
        self.avatorButton = avatorButton;
        
        // bubble container
        XHMessageBubbleView *messageBubbleView = [[XHMessageBubbleView alloc] initWithFrame:CGRectMake(55, 10, CGRectGetWidth([[UIScreen mainScreen] bounds]) - 110, 280) bubbleType:type];
        [self.contentView addSubview:messageBubbleView];
        self.messageBubbleView = messageBubbleView;
    }
    return self;
}

- (void)setMessage:(id <XHMessageModel>)message {
    
}

+ (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message
                        BubbleMessageType:(XHBubbleMessageType)type
                        displaysTimestamp:(BOOL)displayTimestamp {
    
    CGFloat timestampHeight = displayTimestamp ? kXHTimeStampLabelHeight : 0.0f;
    CGFloat avatarHeight = kXHAvatarImageSize;
    
    CGFloat subviewHeights = timestampHeight + kXHLabelPadding;
    
    CGFloat bubbleHeight = [XHMessageBubbleView calculateCellHeightWithMessage:message];
    
    return subviewHeights + MAX(avatarHeight, bubbleHeight);

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)dealloc {
    _avatorButton = nil;
    _messageBubbleView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableViewCell

- (void)prepareForReuse {
    // 这里做清除工作
    
    [super prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
