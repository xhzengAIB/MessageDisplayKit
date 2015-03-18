//
//  XHSendMessageView.m
//  MessageDisplayKitWeChatExample
//
//  Created by Jack_iMac on 15/2/28.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import "XHSendMessageView.h"

@interface XHSendMessageView () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIView *customInputAccessoryView;
@property (nonatomic, strong) UITextField *inputTextField;

@end

@implementation XHSendMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textField];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardDidShow:(NSNotification *)nitification {
    [self becomeFirstResponderForInputTextField];
}

#pragma mark - 公开方法

- (void)becomeFirstResponderForTextField {
    if (!self.textField.isFirstResponder) {
        [self.textField becomeFirstResponder];
    }
}

- (void)becomeFirstResponderForInputTextField {
    if (!self.inputTextField.isFirstResponder) {
        [self.inputTextField becomeFirstResponder];
    }
}

- (void)resignFirstResponderForInputTextFields {
    if ([self.inputTextField isFirstResponder]) {
        [self.inputTextField resignFirstResponder];
    }
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

- (void)finishSendMessage {
    self.inputTextField.text = nil;
    [self resignFirstResponderForInputTextFields];
}

#pragma mark - Propertys

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.returnKeyType = UIReturnKeySend;
        _textField.inputAccessoryView = self.customInputAccessoryView;
    }
    return _textField;
}

- (UIView *)customInputAccessoryView {
    if (!_customInputAccessoryView) {
        _customInputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 44)];
        _customInputAccessoryView.backgroundColor = [UIColor colorWithWhite:0.910 alpha:1.000];
        [_customInputAccessoryView addSubview:self.inputTextField];
    }
    return _customInputAccessoryView;
}
- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(_customInputAccessoryView.bounds) - 20, CGRectGetHeight(_customInputAccessoryView.bounds) - 20)];
        _inputTextField.delegate = self;
        _inputTextField.returnKeyType = UIReturnKeySend;
        _inputTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _inputTextField;
}

#pragma mark - UITextField Delgate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 发送文字
    if ([self.sendMessageDelegate respondsToSelector:@selector(didSendMessage:albumInputView:)]) {
        [self.sendMessageDelegate didSendMessage:textField.text albumInputView:self];
    }
    return YES;
}

@end
