//
//  XHMessageTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageTableViewController.h"

@interface XHMessageTableViewController ()

/**
 *  判断是否用户手指滚动
 */
@property (assign, nonatomic) BOOL isUserScrolling;

/**
 *  记录旧的textView contentSize Heigth
 */
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;


@property (nonatomic, strong, readwrite) XHMessageTableView *messageTableView;
@property (nonatomic, strong, readwrite) XHMessageInputView *messageInputView;

@end

@implementation XHMessageTableViewController

#pragma mark - Messages view controller

- (void)finishSendMessage {
    [self.messageInputView.inputTextView setText:nil];
    [self textViewDidChange:self.messageInputView.inputTextView];
    [self.messageTableView reloadData];
}

- (void)setBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
    _messageTableView.backgroundColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated {
	if (![self shouldAllowScroll])
        return;
	
    NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
    
    if (rows > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
			  atScrollPosition:(UITableViewScrollPosition)position
					  animated:(BOOL)animated {
	if (![self shouldAllowScroll])
        return;
	
	[self.messageTableView scrollToRowAtIndexPath:indexPath
						  atScrollPosition:position
								  animated:animated];
}

- (BOOL)shouldAllowScroll {
    if (self.isUserScrolling) {
        if ([self.delegate respondsToSelector:@selector(shouldPreventScrollToBottomWhileUserScrolling)]
            && [self.delegate shouldPreventScrollToBottomWhileUserScrolling]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Life cycle

- (void)setup {
    _allowsPanToDismissKeyboard = YES;
    _allowsSendVoice = YES;
    _allowsSendMultiMedia = YES;
    _allowsSendFace = YES;
    _inputViewStyle = XHMessageInputViewStyleFlat;
    
    self.delegate = self;
    self.dataSource = self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)initilzer {
    // 默认设置用户滚动为NO
    _isUserScrolling = NO;
    
    // 初始化message tableView
	XHMessageTableView *tableView = [[XHMessageTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.dataSource = self;
	tableView.delegate = self;
	[self.view addSubview:tableView];
	_messageTableView = tableView;
    
    // 设置Message TableView 的bottom edg
    CGFloat inputViewHeight = (self.inputViewStyle == XHMessageInputViewStyleFlat) ? 45.0f : 40.0f;
    [self setTableViewInsetsWithBottomValue:inputViewHeight];
    
    // 设置整体背景颜色
    [self setBackgroundColor:[UIColor whiteColor]];
    
    // 输入工具条的frame
    CGRect inputFrame = CGRectMake(0.0f,
                                   self.view.frame.size.height - inputViewHeight,
                                   self.view.frame.size.width,
                                   inputViewHeight);
    
    // 设置键盘通知或者手势控制键盘消失
    [self.messageTableView setupPanGestureControlKeyboardHide:self.allowsPanToDismissKeyboard];
    
    // block回调键盘通知
    WEAKSELF
    self.messageTableView.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration){
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:options
                         animations:^{
                             CGFloat keyboardY = [weakSelf.view convertRect:keyboardRect fromView:nil].origin.y;
                             
                             CGRect inputViewFrame = weakSelf.messageInputView.frame;
                             CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                             
                             // for ipad modal form presentations
                             CGFloat messageViewFrameBottom = weakSelf.view.frame.size.height - inputViewFrame.size.height;
                             if (inputViewFrameY > messageViewFrameBottom)
                                 inputViewFrameY = messageViewFrameBottom;
                             
                             weakSelf.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                          inputViewFrameY,
                                                                          inputViewFrame.size.width,
                                                                          inputViewFrame.size.height);
                             
                             [weakSelf setTableViewInsetsWithBottomValue:weakSelf.view.frame.size.height
                              - weakSelf.messageInputView.frame.origin.y];
                             [weakSelf scrollToBottomAnimated:NO];
                         }
                         completion:nil];
    };
    
    // 控制输入工具条的位置块
    void (^AnimationForMessageInputViewAtPoint)(CGPoint point) = ^(CGPoint point) {
        CGRect inputViewFrame = weakSelf.messageInputView.frame;
        CGPoint keyboardOrigin = [weakSelf.view convertPoint:point fromView:nil];
        inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
        weakSelf.messageInputView.frame = inputViewFrame;
    };
    
    self.messageTableView.keyboardDidScrollToPoint = ^(CGPoint point) {
        AnimationForMessageInputViewAtPoint(point);
    };
    
    self.messageTableView.keyboardWillSnapBackToPoint = ^(CGPoint point) {
        AnimationForMessageInputViewAtPoint(point);
    };
    
    self.messageTableView.keyboardWillBeDismissed = ^() {
        CGRect inputViewFrame = weakSelf.messageInputView.frame;
        inputViewFrame.origin.y = weakSelf.view.bounds.size.height - inputViewFrame.size.height;
        weakSelf.messageInputView.frame = inputViewFrame;
    };
    
    self.messageTableView.keyboardDidHide = ^() {
        [weakSelf.messageInputView.inputTextView resignFirstResponder];
    };
    
    // 初始化输入工具条
    XHMessageInputView *inputView = [[XHMessageInputView alloc] initWithFrame:inputFrame];
    inputView.allowsSendFace = self.allowsSendFace;
    inputView.allowsSendVoice = self.allowsSendVoice;
    inputView.allowsSendMultiMedia = self.allowsSendMultiMedia;
    [self.view addSubview:inputView];
    _messageInputView = inputView;
    _messageInputView.inputTextView.placeHolder = @"发送新消息";
    _messageInputView.inputTextView.delegate = self;
    
    // 设置手势滑动，默认添加一个bar的高度值
    self.messageTableView.messageInputBarHeight = CGRectGetHeight(_messageInputView.bounds);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // KVO 检查contentSize
    [self.messageInputView.inputTextView addObserver:self
                                     forKeyPath:@"contentSize"
                                        options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                        context:nil];
    // 滚动到底部
    [self scrollToBottomAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 取消输入框
    [self.messageInputView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    // remove键盘通知或者手势
    [self.messageTableView disSetupPanGestureControlKeyboardHide:self.allowsPanToDismissKeyboard];
    
    // remove KVO
    [self.messageInputView.inputTextView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"华捷微信";
    
    // 初始化消息页面布局
    [self initilzer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _delegate = nil;
    _dataSource = nil;
    _messageTableView.delegate = nil;
    _messageTableView.dataSource = nil;
    _messageTableView = nil;
    _messageInputView = nil;
}

#pragma mark - View rotation

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.messageTableView reloadData];
    [self.messageTableView setNeedsLayout];
}

#pragma mark - UITextView Helper method

- (CGFloat)getTextViewContentH:(UITextView*)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - Layout message input view

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
    CGFloat maxHeight = [XHMessageInputView maxHeight];
    
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < self.previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    
    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self setTableViewInsetsWithBottomValue:self.messageTableView.contentInset.bottom + changeInHeight];
                             
                             [self scrollToBottomAnimated:NO];
                             
                             if (isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageInputView.frame;
                             self.messageInputView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             if (!isShrinking) {
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.messageTableView.contentInset = insets;
    self.messageTableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = self.topLayoutGuide.length;
    }
    
    insets.bottom = bottom;
    
    return insets;
}

#pragma mark - XHMessageTableViewController delegate

- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if (!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = [self getTextViewContentH:textView];
}

- (void)textViewDidChange:(UITextView *)textView {
//    self.messageInputView.sendButton.enabled = ([[textView.text js_stringByTrimingWhitespace] length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self finishSendMessage];
        return NO;
    }
    return YES;
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	self.isUserScrolling = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isUserScrolling = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    XHMessageTableViewCell *messageTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!messageTableViewCell) {
        messageTableViewCell = [[XHMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        messageTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return messageTableViewCell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self finishSendMessage];
}

#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.messageInputView.inputTextView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}

@end
