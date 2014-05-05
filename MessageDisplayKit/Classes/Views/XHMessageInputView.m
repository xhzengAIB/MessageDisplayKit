//
//  XHMessageInputView.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageInputView.h"
#import "SCAudioRecordManager.h"

#import "NSString+MessageInputView.h"


#define TOUCH_TO_RECORD         @"按住 说话"
#define TOUCH_TO_FINISH         @"松开 结束"
#define TOUCH_TO_DELETE         @"松开 删除"
#define TOUCH_TO_CANCEL         @"松开手指 取消发送"

typedef enum {
    RecordBtnStateRecord        =   0,
    RecordBtnStateFinish        =   1,
    RecordBtnStateDelete        =   2,
    RecordBtnStateRecordTime    =   3,
    RecordBtnStateCancel        =   4
} RecordBtnStateType;

@interface XHMessageInputView () <UITextViewDelegate, SCAudioRecordManagerDelegate>


@property (nonatomic, weak, readwrite) XHMessageTextView *inputTextView;

@property (nonatomic, weak, readwrite) UIButton *voiceChangeButton;

@property (nonatomic, weak, readwrite) UIButton *multiMediaSendButton;

@property (nonatomic, weak, readwrite) UIButton *faceSendButton;

@property (nonatomic, weak, readwrite) UIButton *holdDownButton;

//录音
@property (nonatomic, assign) BOOL shouldBeginTouch;
@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) SCAudioRecordManager *recordManager;
@property (nonatomic, strong) SCRecordView *recordView;

//data
@property (nonatomic, copy) NSString *inputedText;

@end

@implementation XHMessageInputView

#pragma mark - Action

- (void)messageStyleButtonClicked:(UIButton *)sender {
    NSInteger index = sender.tag;
    if (self.inputTextView.alpha != 1) {
        self.inputTextView.alpha = 1;
    }
    switch (index) {
        case 0: {
            sender.selected = !sender.selected;
            if (sender.selected) {
                self.inputTextView.alpha = 0;
                self.inputedText = self.inputTextView.text;
                self.inputTextView.text = @"";
                [self.inputTextView resignFirstResponder];
            } else {
                self.inputTextView.text = self.inputedText;
                self.inputedText = nil;
                [self.inputTextView becomeFirstResponder];
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.holdDownButton.alpha = sender.selected;
            } completion:^(BOOL finished) {
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(didChangeSendVoiceMeesgae:)]) {
                [self.delegate didChangeSendVoiceMeesgae:sender.selected];
            }
            
            break;
        }
        case 1: {
            sender.selected = !sender.selected;
            self.voiceChangeButton.selected = !sender.selected;
            
            if (!sender.selected) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.holdDownButton.alpha = sender.selected;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
            if ([self.delegate respondsToSelector:@selector(didSendFaceMessage:)]) {
                [self.delegate didSendFaceMessage:sender.selected];
            }
            break;
        }
        case 2: {
            if ([self.delegate respondsToSelector:@selector(didSelectedMultipleMediaAction)]) {
                [self.delegate didSelectedMultipleMediaAction];
            }
            break;
        }
        default:
            break;
    }
}

- (void)holdDownButtonTouchDown {
    if ([self.delegate respondsToSelector:@selector(didStartRecordingVoice)]) {
        [self.delegate didStartRecordingVoice];
    }
}

- (void)holdDownButtonTouchUpOutside {
    if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoice)]) {
        [self.delegate didCancelRecordingVoice];
    }
}

- (void)holdDownButtonTouchUpInside {
    if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoice)]) {
        [self.delegate didFinishRecoingVoice];
    }
}

#pragma mark - layout subViews UI

- (UIButton *)createButtonWithImage:(UIImage *)image HLImage:(UIImage *)hlImage {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [XHMessageInputView textViewLineHeight], [XHMessageInputView textViewLineHeight])];
    if (image)
        [button setBackgroundImage:image forState:UIControlStateNormal];
    if (hlImage)
        [button setBackgroundImage:hlImage forState:UIControlStateHighlighted];
    
    return button;
}

- (void)setupMessageInputViewBarWithStyle:(XHMessageInputViewStyle)style {
    // 配置输入工具条的样式和布局
    
    // 需要显示按钮的总宽度，包括间隔在内
    CGFloat allButtonWidth = 0.0;
    
    // 水平间隔
    CGFloat horizontalPadding = 8;
    
    // 垂直间隔
    CGFloat verticalPadding = 5;
    
    // 输入框
    CGFloat textViewLeftMargin = ((style == XHMessageInputViewStyleFlat) ? 6.0 : 4.0);
    
    // 每个按钮统一使用的frame变量
    CGRect buttonFrame;
    
    // 按钮对象消息
    UIButton *button;
    
    // 允许发送语音
    if (self.allowsSendVoice) {
        button = [self createButtonWithImage:[UIImage imageNamed:@"voice"] HLImage:[UIImage imageNamed:@"voice_HL"]];
        [button addTarget:self action:@selector(messageStyleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 0;
        [button setImage:[UIImage imageNamed:@"keyborad"] forState:UIControlStateSelected];
        buttonFrame = button.frame;
        buttonFrame.origin = CGPointMake(horizontalPadding, verticalPadding);
        button.frame = buttonFrame;
        [self addSubview:button];
        allButtonWidth += CGRectGetMaxX(buttonFrame);
        textViewLeftMargin += CGRectGetMaxX(buttonFrame);
        
        self.voiceChangeButton = button;
    }
    
    // 允许发送多媒体消息，为什么不是先放表情按钮呢？因为布局的需要！
    if (self.allowsSendMultiMedia) {
        button = [self createButtonWithImage:[UIImage imageNamed:@"multiMedia"] HLImage:[UIImage imageNamed:@"multiMedia_HL"]];
        [button addTarget:self action:@selector(messageStyleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 2;
        buttonFrame = button.frame;
        buttonFrame.origin = CGPointMake(CGRectGetWidth(self.bounds) - horizontalPadding - CGRectGetWidth(buttonFrame), verticalPadding);
        button.frame = buttonFrame;
        [self addSubview:button];
        allButtonWidth += CGRectGetWidth(buttonFrame) + horizontalPadding * 2.5;
        
        self.multiMediaSendButton = button;
    }
    
    // 允许发送表情
    if (self.allowsSendFace) {
        button = [self createButtonWithImage:[UIImage imageNamed:@"face"] HLImage:[UIImage imageNamed:@"face_HL"]];
        [button setImage:[UIImage imageNamed:@"keyborad"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(messageStyleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1;
        buttonFrame = button.frame;
        if (self.allowsSendMultiMedia) {
            buttonFrame.origin = CGPointMake(CGRectGetMinX(self.multiMediaSendButton.frame) - CGRectGetWidth(buttonFrame) - horizontalPadding, verticalPadding);
            allButtonWidth += CGRectGetWidth(buttonFrame) + horizontalPadding * 1.5;
        } else {
            buttonFrame.origin = CGPointMake(CGRectGetWidth(self.bounds) - horizontalPadding - CGRectGetWidth(buttonFrame), verticalPadding);
            allButtonWidth += CGRectGetWidth(buttonFrame) + horizontalPadding * 2.5;
        }
        button.frame = buttonFrame;
        [self addSubview:button];
        
        self.faceSendButton = button;
    }
    
    // 输入框的高度和宽度
    CGFloat width = CGRectGetWidth(self.bounds) - allButtonWidth;
    CGFloat height = [XHMessageInputView textViewLineHeight];
    
    // 初始化输入框
    XHMessageTextView *textView = [[XHMessageTextView  alloc] initWithFrame:CGRectZero];
    
    // 这个是仿微信的一个细节体验
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    
    textView.placeHolder = @"发送新消息";
    textView.delegate = self;
    
    [self addSubview:textView];
	_inputTextView = textView;
    
    // 配置不同iOS SDK版本的样式
    switch (style) {
        case XHMessageInputViewStyleQuasiphysical: {
            _inputTextView.frame = CGRectMake(textViewLeftMargin, 3.0f, width, height);
            _inputTextView.backgroundColor = [UIColor whiteColor];
            
            self.image = [[UIImage imageNamed:@"input-bar-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0f, 3.0f, 19.0f, 3.0f)
                                                                                      resizingMode:UIImageResizingModeStretch];
            
            UIImageView *inputFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(_inputTextView.frame.origin.x - 1.0f,
                                                                                        0.0f,
                                                                                        _inputTextView.frame.size.width + 2.0f,
                                                                                        self.frame.size.height)];
            inputFieldBack.image = [[UIImage imageNamed:@"input-field-cover"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 12.0f, 18.0f, 18.0f)];
            inputFieldBack.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            inputFieldBack.backgroundColor = [UIColor clearColor];
            [self addSubview:inputFieldBack];
            break;
        }
        case XHMessageInputViewStyleFlat: {
            _inputTextView.frame = CGRectMake(textViewLeftMargin, 4.5f, width, height);
            _inputTextView.backgroundColor = [UIColor clearColor];
            _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
            _inputTextView.layer.borderWidth = 0.65f;
            _inputTextView.layer.cornerRadius = 6.0f;
            
            self.image = [[UIImage imageNamed:@"input-bar-flat"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f)
                                                                                resizingMode:UIImageResizingModeStretch];
            break;
        }
        default:
            break;
    }
    
    // 如果是可以发送语言的，那就需要一个按钮录音的按钮，事件可以在外部添加
    if (self.allowsSendVoice) {
        button = [self createButtonWithImage:nil HLImage:nil];
//        button = [self createButtonWithImage:[UIImage imageNamed:@"holdDownButton"] HLImage:nil];
        buttonFrame = _inputTextView.frame;
        button.frame = buttonFrame;
        button.alpha = self.voiceChangeButton.selected;
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        button.backgroundColor = rgba(230, 230, 230, 1.0000);
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [rgba(196, 196, 196, 1.0000) CGColor];
        button.userInteractionEnabled = NO;
        /*
        [button addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
         */
        [self addSubview:button];
        self.holdDownButton = button;
        
        [self setRecordBtnWithType:RecordBtnStateRecord];
    }
}

#pragma mark - Life cycle

- (void)setup {
    // 配置自适应
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    // 由于继承UIImageView，所以需要这个属性设置
    self.userInteractionEnabled = YES;
    
    // 默认设置
    _allowsSendVoice = YES;
    _allowsSendFace = YES;
    _allowsSendMultiMedia = YES;
    
    _messageInputViewStyle = XHMessageInputViewStyleFlat;
}

- (void)awakeFromNib {
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    _inputTextView.delegate = nil;
    _inputTextView = nil;
    
    _voiceChangeButton = nil;
    _multiMediaSendButton = nil;
    _faceSendButton = nil;
    _holdDownButton = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // 当别的地方需要add的时候，就会调用这里
    if (newSuperview) {
        [self setupMessageInputViewBarWithStyle:self.messageInputViewStyle];
    }
}

#pragma mark - Message input view

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight {
    // 动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.inputTextView.frame;
    
    NSUInteger numLines = MAX([self.inputTextView numberOfLinesOfText],
                              [self.inputTextView.text numberOfLines]);
    
    self.inputTextView.frame = CGRectMake(prevFrame.origin.x,
                                     prevFrame.origin.y,
                                     prevFrame.size.width,
                                     prevFrame.size.height + changeInHeight);
    
    
    self.inputTextView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f,
                                                  (numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f);
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    self.inputTextView.scrollEnabled = YES;
    
    if (numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.inputTextView.contentSize.height - self.inputTextView.bounds.size.height);
        [self.inputTextView setContentOffset:bottomOffset animated:YES];
        [self.inputTextView scrollRangeToVisible:NSMakeRange(self.inputTextView.text.length - 2, 1)];
    }
}

+ (CGFloat)textViewLineHeight {
    return 36.0f; // for fontSize 16.0f
}

+ (CGFloat)maxLines {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 3.0f : 8.0f;
}

+ (CGFloat)maxHeight {
    return ([XHMessageInputView maxLines] + 1.0f) * [XHMessageInputView textViewLineHeight];
}

#pragma mark - Text view delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendMessageWithText:)]) {
            [self.delegate didSendMessageWithText:textView.text];
        }
        return NO;
    }
    return YES;
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    SCDLog(@"began");
    CGPoint touchPoint = [[touches anyObject] locationInView:self.parentCon.view];
    touchPoint = [self.parentCon.view convertPoint:touchPoint toView:self.holdDownButton.superview];
    if (CGRectContainsPoint(self.holdDownButton.frame, touchPoint) == NO) {
        _shouldBeginTouch = NO;
        SCDLog(@"不是按到录音按钮");
        return;
    }
    
    [self handleBeginRecord:self.holdDownButton];
    
    _shouldBeginTouch = YES;
    if ([_audioDelegate respondsToSelector:@selector(XHMessageInputView:began:withEvent:)]) {
        [_audioDelegate XHMessageInputView:self began:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_shouldBeginTouch == NO) {
        return;
    }
    SCDLog(@"moved");
    
    
    if (self.holdDownButton.alpha == 0) {
        return;
    }
    if ([self isMoveUpToCancelRecord:touches]) {
        [self setRecordBtnWithType:RecordBtnStateCancel];
    } else {
        [self setRecordBtnWithType:RecordBtnStateFinish];
    }
    
    if ([_audioDelegate respondsToSelector:@selector(XHMessageInputView:changed:withEvent:)]) {
        [_audioDelegate XHMessageInputView:self changed:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_shouldBeginTouch == NO) {
        return;
    }
    SCDLog(@"ended");
    
    if (self.holdDownButton.alpha == 0) {
        return;
    }
    [self handleTouchEndOrCancle:touches];
    
    if ([_audioDelegate respondsToSelector:@selector(XHMessageInputView:ended:withEvent:)]) {
        [_audioDelegate XHMessageInputView:self ended:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_shouldBeginTouch == NO) {
        return;
    }
    SCDLog(@"cancelled");
    
    if (self.holdDownButton.alpha == 0) {
        return;
    }
    [self handleTouchEndOrCancle:touches];
    
    if ([_audioDelegate respondsToSelector:@selector(XHMessageInputView:cancelled:withEvent:)]) {
        [_audioDelegate XHMessageInputView:self cancelled:touches withEvent:event];
    }
}

#pragma mark ------------touch for record-------------
- (void)removeSthAboutRecord {
    if (_recordView) {
        [self.recordView removeFromSuperview];
        self.recordView = nil;
    }
    
    if (_recordManager) {
        [_recordManager endRecord];
        self.recordManager = nil;
    }
}

- (void)handleTouchEndOrCancle:(NSSet*)touches {
    if ([self isMoveUpToCancelRecord:touches]) {//取消本次录音
        [self handleCancelRecord:touches];
        
    } else {//录音完毕
        [self handleEndRecord:self.holdDownButton];//转码
    }
}

//是否向上移动了
- (BOOL)isMoveUpToCancelRecord:(NSSet*)touches {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.parentCon.view];
    touchPoint = [self.parentCon.view convertPoint:touchPoint toView:self.holdDownButton.superview];//menuView
    if (CGRectContainsPoint(self.holdDownButton.frame, touchPoint) == YES) {
        return NO;
    }
    return YES;
}

//0：按住说话    1：松手结束     2：松手删除      3：松手取消此次录音
- (void)setRecordBtnWithType:(RecordBtnStateType)type {
    if (type == RecordBtnStateRecord) {
        [self.holdDownButton setTitle:TOUCH_TO_RECORD forState:UIControlStateNormal];
        [self.holdDownButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    } else if (type == RecordBtnStateFinish) {
        [self.holdDownButton setTitle:TOUCH_TO_FINISH forState:UIControlStateNormal];
        [self.holdDownButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    } else if (type == RecordBtnStateDelete) {
        [self.holdDownButton setTitle:TOUCH_TO_DELETE forState:UIControlStateNormal];
        [self.holdDownButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } else if (type == RecordBtnStateRecordTime) {
        NSString *str = [NSString stringWithFormat:@"已录音 %.1f''", _recordManager.recordedDuration];
        [self.holdDownButton setTitle:str forState:UIControlStateNormal];
        [self.holdDownButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    } else if (type == RecordBtnStateCancel) {
        [self.holdDownButton setTitle:TOUCH_TO_CANCEL forState:UIControlStateNormal];
        [self.holdDownButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (void)handleBeginRecord:(UIButton*)sender {
    
    if (sender.selected == YES) {
        return;
    }
    sender.selected = YES;
    [self setRecordBtnWithType:RecordBtnStateFinish];
    
    [self removeSthAboutRecord];
    [self addRecordView];
    [_recordView show:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_recordManager beginRecord];
    });
}

- (void)handleEndRecord:(UIButton*)sender {
    
    if (sender.selected == NO) {
        return;
    }
    sender.selected = NO;
    if (_recordView) {
        [_recordView show:NO];
    }
    //延时0.5f，防止最后的声音录不进去
    double delayInSeconds = 0.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (_recordManager) {
            [_recordManager endRecord];
        }
    });
}

- (void)handleCancelRecord:(NSSet*)touches {
    
    if ([self isMoveUpToCancelRecord:touches] == NO) {
        return;
    }
    [SCAudioRecordManager removeRecordedFileWithOnlyName:_recordManager.wavFileStr block:nil];
    _recordManager.wavFileStr = @"";
    
    
    _holdDownButton.selected = NO;
    [self removeSthAboutRecord];
    
    [self setRecordBtnWithType:RecordBtnStateRecord];
    
    if ([_audioDelegate respondsToSelector:@selector(XHMessageInputView:willCancleRecordWithDict:)]) {
        [_audioDelegate XHMessageInputView:self willCancleRecordWithDict:nil];
    }
}

#pragma mark - recordView
//正在录音时的界面
- (void)addRecordView {
    //    WEAKSELF_SC
    if (!_recordManager) {
        SCAudioRecordManager *mgr = [[SCAudioRecordManager alloc] init];
        mgr.delegate = self;
        self.recordManager = mgr;
    }
    
    if (!_recordView) {
        SCRecordView *view = [[SCRecordView alloc] initWithFrame:CGRectMake(0, 0, self.parentCon.view.frame.size.width, self.parentCon.view.frame.size.height - 50) parentView:self.parentCon.view];
        [self.parentCon.view bringSubviewToFront:self];
        
        [view.trashBtn removeFromSuperview];
        view.trashBtn = nil;
        self.recordView = view;
    }
}

- (void)setRecordBtnTitleForDuration {
    if (_recordManager.recordedDuration > 0) {
        [self setRecordBtnWithType:RecordBtnStateRecordTime];
    } else {
        [self setRecordBtnWithType:RecordBtnStateRecord];
    }
}

#pragma mark - SCAudioRecordManagerDelegate
- (void)SCAudioRecordManager:(SCAudioRecordManager *)manager updateAudioMeters:(float)avgPower {
    
    [manager updateMetersByAvgPower:avgPower recordView:_recordView];
    
}

- (void)SCAudioRecordManager:(SCAudioRecordManager *)manager beforeConvertToAmr:(NSString *)filePath recordDuration:(float)duration {
    
    if ([self hasAudioFile:filePath soundTime:duration] == NO) {
        SCDLog(@"没有音频文件");
        return;
    }
    SCDLog(@"录音wav完成");
    [self removeSthAboutRecord];
}

- (void)SCAudioRecordManager:(SCAudioRecordManager *)manager didFinishConvertToAmr:(NSString *)filePath fileName:(NSString *)fileName recordDuration:(float)duration {
    
    if ([self hasAudioFile:filePath soundTime:duration] == NO) {
        SCDLog(@"没有音频文件");
        return;
    }
    
    //设置文字
    [self setRecordBtnTitleForDuration];
    
    //录音完成后的回调
    if ([_audioDelegate respondsToSelector:@selector(XHMessageInputView:didFinishRecordWithFilePath:fileName:soundTime:otherInfo:)]) {
        [_audioDelegate XHMessageInputView:self didFinishRecordWithFilePath:filePath fileName:fileName soundTime:duration otherInfo:nil];
    }
    [self removeSthAboutRecord];
    
    //上传成功后，得到音频id。可在此处调用上传成功的回调方法didUploadAudioWithSoundId，也可在外部上传
}

- (BOOL)hasAudioFile:(NSString*)amrFilePath soundTime:(float)recordedDuration {
    if (amrFilePath && ![amrFilePath isEqual:[NSNull null]] && amrFilePath.length > 0 && recordedDuration > 0 && [SCAudioRecordManager fileExistsAtPath:amrFilePath]) {
        return YES;
    }
    return NO;
}


@end
