//
//  XHQRCodeViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHQRCodeViewController.h"

#import "XHScanningView.h"

#import "UIButton+XHButtonTitlePosition.h"

#import "XHCaptureHelper.h"

#import "XHVideoOutputSampleBufferFactory.h"

#import "XHFoundationCommon.h"

#import "XHMacro.h"

#define kXHScanningButtonPadding 36

@interface XHQRCodeViewController ()

@property (nonatomic, strong) UIView *preview;

@property (nonatomic, strong) XHScanningView *scanningView;

@property (nonatomic, strong) UIView *buttonContainerView;
@property (nonatomic, strong) UIButton *scanQRCodeButton;
@property (nonatomic, strong) UIButton *scanBookButton;
@property (nonatomic, strong) UIButton *scanStreetButton;
@property (nonatomic, strong) UIButton *scanWordButton;

@property (nonatomic, strong) XHCaptureHelper *captureHelper;

@end

@implementation XHQRCodeViewController

#pragma mark - Action

- (void)scanButtonClicked:(UIButton *)sender {
    self.scanQRCodeButton.selected = (sender == self.scanQRCodeButton);
    self.scanBookButton.selected = (sender == self.scanBookButton);
    self.scanStreetButton.selected = (sender == self.scanStreetButton);
    self.scanWordButton.selected = (sender == self.scanWordButton);
    
    [self.scanningView transformScanningTypeWithStyle:sender.tag];
}

- (void)showPhotoLibray {
    
}

#pragma mark - Propertys

- (UIButton *)createButton {
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:self action:@selector(scanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIView *)preview {
    if (!_preview) {
        _preview = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _preview;
}

- (XHScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[XHScanningView alloc] initWithFrame:CGRectMake(0, (CURRENT_SYS_VERSION >= 7.0 ? 64 : 0), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - (CURRENT_SYS_VERSION >= 7.0 ? 64 : 44))];
    }
    return _scanningView;
}

- (UIView *)buttonContainerView {
    if (!_buttonContainerView) {
        _buttonContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 62 - [XHFoundationCommon getAdapterHeight], CGRectGetWidth(self.view.bounds), 62)];
        _buttonContainerView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
        
        [_buttonContainerView addSubview:self.scanQRCodeButton];
        [_buttonContainerView addSubview:self.scanBookButton];
        [_buttonContainerView addSubview:self.scanStreetButton];
        [_buttonContainerView addSubview:self.scanWordButton];
    }
    return _buttonContainerView;
}
- (UIButton *)scanQRCodeButton {
    if (!_scanQRCodeButton) {
        _scanQRCodeButton = [self createButton];
        _scanQRCodeButton.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - kXHScanningButtonPadding * 1.5 - 35 * 2, 8, 35, CGRectGetHeight(self.buttonContainerView.bounds) - 16);
        _scanQRCodeButton.tag = 0;
        [_scanQRCodeButton setImage:[UIImage imageNamed:@"ScanQRCode"] forState:UIControlStateNormal];
        [_scanQRCodeButton setImage:[UIImage imageNamed:@"ScanQRCode_HL"] forState:UIControlStateSelected];
        _scanQRCodeButton.selected = YES;
        [_scanQRCodeButton setTitle:@"扫码" forState:UIControlStateNormal];
        [_scanQRCodeButton setTitlePositionWithType:XHButtonTitlePostionTypeBottom];
    }
    return _scanQRCodeButton;
}
- (UIButton *)scanBookButton {
    if (!_scanBookButton) {
        _scanBookButton = [self createButton];
        CGRect scanBookButtonFrame = self.scanQRCodeButton.frame;
        scanBookButtonFrame.origin.x += kXHScanningButtonPadding + CGRectGetWidth(self.scanQRCodeButton.bounds);
        _scanBookButton.frame = scanBookButtonFrame;
        _scanBookButton.tag = 1;
        [_scanBookButton setImage:[UIImage imageNamed:@"ScanBook"] forState:UIControlStateNormal];
        [_scanBookButton setImage:[UIImage imageNamed:@"ScanBook_HL"] forState:UIControlStateSelected];
        [_scanBookButton setTitle:@"封面" forState:UIControlStateNormal];
        [_scanBookButton setTitlePositionWithType:XHButtonTitlePostionTypeBottom];
    }
    return _scanBookButton;
}
- (UIButton *)scanStreetButton {
    if (!_scanStreetButton) {
        _scanStreetButton = [self createButton];
        CGRect scanBookButtonFrame = self.scanBookButton.frame;
        scanBookButtonFrame.origin.x += kXHScanningButtonPadding + CGRectGetWidth(self.scanQRCodeButton.bounds);
        _scanStreetButton.frame = scanBookButtonFrame;
        _scanStreetButton.tag = 2;
        [_scanStreetButton setImage:[UIImage imageNamed:@"ScanStreet"] forState:UIControlStateNormal];
        [_scanStreetButton setImage:[UIImage imageNamed:@"ScanStreet_HL"] forState:UIControlStateSelected];
        [_scanStreetButton setTitle:@"街景" forState:UIControlStateNormal];
        [_scanStreetButton setTitlePositionWithType:XHButtonTitlePostionTypeBottom];
    }
    return _scanStreetButton;
}
- (UIButton *)scanWordButton {
    if (!_scanWordButton) {
        _scanWordButton = [self createButton];
        CGRect scanBookButtonFrame = self.scanStreetButton.frame;
        scanBookButtonFrame.origin.x += kXHScanningButtonPadding + CGRectGetWidth(self.scanQRCodeButton.bounds);
        _scanWordButton.frame = scanBookButtonFrame;
        _scanWordButton.tag = 3;
        [_scanWordButton setImage:[UIImage imageNamed:@"ScanWord"] forState:UIControlStateNormal];
        [_scanWordButton setImage:[UIImage imageNamed:@"ScanWord_HL"] forState:UIControlStateSelected];
        [_scanWordButton setTitle:@"翻译" forState:UIControlStateNormal];
        [_scanWordButton setTitlePositionWithType:XHButtonTitlePostionTypeBottom];
    }
    return _scanWordButton;
}

- (XHCaptureHelper *)captureHelper {
    if (!_captureHelper) {
        _captureHelper = [[XHCaptureHelper alloc] init];
        [_captureHelper setDidOutputSampleBufferHandle:^(CMSampleBufferRef sampleBuffer) {
            // 这里可以做子线程的QRCode识别
            DLog(@"image : %@", [XHVideoOutputSampleBufferFactory imageFromSampleBuffer:sampleBuffer]);
        }];
    }
    return _captureHelper;
}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.captureHelper showCaptureOnView:self.preview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedStringFromTable(@"Scanning", @"MessageDisplayKitString", @"扫一扫");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStyleBordered target:self action:@selector(showPhotoLibray)];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.preview];
    
    [self.view addSubview:self.scanningView];
    [self.view addSubview:self.buttonContainerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.captureHelper = nil;
    self.scanningView = nil;
}

@end
