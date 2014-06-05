//
//  XHScanningView.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-25.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHScanningView.h"

#define kXHQRCodeTipString @"将二维码/条码放入框内，即可自动扫描"
#define kXHBookTipString @"将书、CD、电影海报放入框内，即可自动扫描"
#define kXHStreetTipString @"扫一下周围环境，讯在附近街景"
#define kXHWordTipString @"将英文单词放入框内"

#define kXHQRCodeRectPaddingX 55

typedef void(^TransformScanningAnimationBlock)(void);

@interface XHScanningView ()

@property (nonatomic, assign, readwrite) XHScanningStyle scanningStyle;

@property (nonatomic, strong) UIImageView *scanningImageView;

@property (nonatomic, assign) CGRect clearRect;

@property (nonatomic, strong) UILabel *QRCodeTipLabel;

@property (nonatomic, strong) UIButton *myQRCodeButton;

@end

@implementation XHScanningView

- (void)scanning {
    CGRect animationRect = self.scanningImageView.frame;
    animationRect.origin.y += CGRectGetWidth(self.bounds) - CGRectGetMinX(animationRect) * 2 - CGRectGetHeight(animationRect);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:1.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatCount:FLT_MAX];
    [UIView setAnimationRepeatAutoreverses:NO];
    
    self.scanningImageView.hidden = NO;
    self.scanningImageView.frame = animationRect;
    [UIView commitAnimations];
}

#pragma mark - Propertys

- (UIImageView *)scanningImageView {
    if (!_scanningImageView) {
        _scanningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 30, CGRectGetWidth(self.bounds) - 110, 3)];
        _scanningImageView.backgroundColor = [UIColor greenColor];
    }
    return _scanningImageView;
}

- (UILabel *)QRCodeTipLabel {
    if (!_QRCodeTipLabel) {
        _QRCodeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.clearRect) + 30, CGRectGetWidth(self.bounds) - 20, 20)];
        _QRCodeTipLabel.text = kXHQRCodeTipString;
        _QRCodeTipLabel.numberOfLines = 0;
        _QRCodeTipLabel.textColor = [UIColor whiteColor];
        _QRCodeTipLabel.backgroundColor = [UIColor clearColor];
        _QRCodeTipLabel.textAlignment = NSTextAlignmentCenter;
        _QRCodeTipLabel.font = [UIFont systemFontOfSize:12];
    }
    return _QRCodeTipLabel;
}

- (UIButton *)myQRCodeButton {
    if (!_myQRCodeButton) {
        _myQRCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_QRCodeTipLabel.frame) + 30, 80, 20)];
        _myQRCodeButton.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, _myQRCodeButton.center.y);
        [_myQRCodeButton setTitle:@"我的二维码" forState:UIControlStateNormal];
        [_myQRCodeButton setTitleColor:[UIColor colorWithRed:0.275 green:0.491 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
        _myQRCodeButton.backgroundColor = [UIColor clearColor];
        _myQRCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _myQRCodeButton;
}

#pragma mark - Public Api

- (void)transformScanningTypeWithStyle:(XHScanningStyle)style {
    self.scanningStyle = style;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setNeedsDisplay];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        
        self.clearRect = CGRectMake(kXHQRCodeRectPaddingX, 30, CGRectGetWidth(frame) - kXHQRCodeRectPaddingX * 2, CGRectGetWidth(frame) - kXHQRCodeRectPaddingX * 2);
        
        [self addSubview:self.scanningImageView];
        [self addSubview:self.QRCodeTipLabel];
        [self addSubview:self.myQRCodeButton];
        
        [self scanning];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    CGRect clearRect;
    CGFloat paddingX;
    
    CGFloat tipLabelPadding;
    
    self.scanningImageView.hidden = YES;
    self.myQRCodeButton.hidden = YES;
    switch (self.scanningStyle) {
        case XHScanningStyleQRCode: {
            tipLabelPadding = 30;
            self.QRCodeTipLabel.text = kXHQRCodeTipString;
            
            self.myQRCodeButton.hidden = NO;
            self.scanningImageView .hidden = NO;
            paddingX = kXHQRCodeRectPaddingX;
            clearRect = CGRectMake(paddingX, 30, CGRectGetWidth(rect) - paddingX * 2, CGRectGetWidth(rect) - paddingX * 2);
            break;
        }
        case XHScanningStyleStreet:
        case XHScanningStyleBook:
            tipLabelPadding = 20;
            if (self.scanningStyle == XHScanningStyleStreet) {
                self.QRCodeTipLabel.text = kXHStreetTipString;
            } else {
                self.QRCodeTipLabel.text = kXHBookTipString;
            }
            
            paddingX = 20;
            clearRect = CGRectMake(paddingX, 20, CGRectGetWidth(rect) - paddingX * 2, CGRectGetWidth(rect) - paddingX * 2);
            break;
        case XHScanningStyleWord:
            tipLabelPadding = 25;
            self.QRCodeTipLabel.text = kXHWordTipString;
            
            paddingX = 50;
            clearRect = CGRectMake(paddingX, 100, CGRectGetWidth(rect) - paddingX * 2, 50);
            break;
        default:
            break;
    }
    
    self.clearRect = clearRect;
    
    CGRect QRCodeTipLabelFrame = self.QRCodeTipLabel.frame;
    QRCodeTipLabelFrame.origin.y = CGRectGetMaxY(self.clearRect) + tipLabelPadding;
    self.QRCodeTipLabel.frame = QRCodeTipLabelFrame;
    
    CGContextClearRect(context, clearRect);
    
    CGContextSaveGState(context);
    
    
    UIImage *topLeftImage = [UIImage imageNamed:@"ScanQR1"];
    UIImage *topRightImage = [UIImage imageNamed:@"ScanQR2"];
    UIImage *bottomLeftImage = [UIImage imageNamed:@"ScanQR3"];
    UIImage *bottomRightImage = [UIImage imageNamed:@"ScanQR4"];
    
    [topLeftImage drawInRect:CGRectMake(clearRect.origin.x, clearRect.origin.y, topLeftImage.size.width, topLeftImage.size.height)];
    
    [topRightImage drawInRect:CGRectMake(CGRectGetMaxX(clearRect) - topRightImage.size.width, clearRect.origin.y, topRightImage.size.width, topRightImage.size.height)];
    
    [bottomLeftImage drawInRect:CGRectMake(clearRect.origin.x, CGRectGetMaxY(clearRect) - bottomLeftImage.size.height, bottomLeftImage.size.width, bottomLeftImage.size.height)];
    
    [bottomRightImage drawInRect:CGRectMake(CGRectGetMaxX(clearRect) - bottomRightImage.size.width, CGRectGetMaxY(clearRect) - bottomRightImage.size.height, bottomRightImage.size.width, bottomRightImage.size.height)];
    
    CGFloat padding = 0.5;
    CGContextMoveToPoint(context, CGRectGetMinX(clearRect) - padding, CGRectGetMinY(clearRect) - padding);
    CGContextAddLineToPoint(context, CGRectGetMaxX(clearRect) + padding, CGRectGetMinY(clearRect) + padding);
    CGContextAddLineToPoint(context, CGRectGetMaxX(clearRect) + padding, CGRectGetMaxY(clearRect) + padding);
    CGContextAddLineToPoint(context, CGRectGetMinX(clearRect) - padding, CGRectGetMaxY(clearRect) + padding);
    CGContextAddLineToPoint(context, CGRectGetMinX(clearRect) - padding, CGRectGetMinY(clearRect) - padding);
    CGContextSetLineWidth(context, padding);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokePath(context);
}

@end
