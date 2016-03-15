//
//  XHDisplayTextViewController.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-6.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHDisplayTextViewController.h"

@interface XHDisplayTextViewController ()

@property (nonatomic, weak) UITextView *displayTextView;

@end

@implementation XHDisplayTextViewController

- (UITextView *)displayTextView {
    if (!_displayTextView) {
        UITextView *displayTextView = [[UITextView alloc] initWithFrame:self.view.frame];
        displayTextView.font = [UIFont systemFontOfSize:16.0f];
        displayTextView.textColor = [UIColor blackColor];
        displayTextView.userInteractionEnabled = YES;
        displayTextView.editable = NO;
        displayTextView.backgroundColor = [UIColor clearColor];
        displayTextView.dataDetectorTypes = UIDataDetectorTypeAll;
        [self.view addSubview:displayTextView];
        _displayTextView = displayTextView;
    }
    return _displayTextView;
}

- (void)setMessage:(id<XHMessageModel>)message {
    _message = message;
    self.displayTextView.text = [message text];
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"TextDetail", @"MessageDisplayKitString", @"文本消息");
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.displayTextView = nil;
}

@end
