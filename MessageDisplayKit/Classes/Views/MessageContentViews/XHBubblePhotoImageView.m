//
//  XHBubblePhotoImageView.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-28.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHBubblePhotoImageView.h"
#import "XHMacro.h"

@interface XHBubblePhotoImageView ()

@property (nonatomic, assign) XHBubbleMessageType bubbleMessageType;

@end

@implementation XHBubblePhotoImageView

- (NSOperationQueue *)bubbleNetworkQueue {
    static NSOperationQueue *currentQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentQueue = [[NSOperationQueue alloc] init];
        currentQueue.maxConcurrentOperationCount = 1;
    });
    return currentQueue;
}

- (XHBubbleMessageType)getBubbleMessageType {
    return self.bubbleMessageType;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidesWhenStopped = YES;
    }
    return _activityIndicatorView;
}

- (void)setMessagePhoto:(UIImage *)messagePhoto {
    _messagePhoto = messagePhoto;
    [self setNeedsDisplay];
}

- (void)configureMessagePhoto:(UIImage *)messagePhoto thumbnailUrl:(NSString *)thumbnailUrl originPhotoUrl:(NSString *)originPhotoUrl onBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    self.bubbleMessageType = bubbleMessageType;
    self.messagePhoto = messagePhoto;
    
    if (thumbnailUrl) {
        WEAKSELF
        [self addSubview:self.activityIndicatorView];
        [self.activityIndicatorView startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:thumbnailUrl]];
        [NSURLConnection sendAsynchronousRequest:request queue:[self bubbleNetworkQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (!connectionError) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    weakSelf.messagePhoto = image;
                    [weakSelf.activityIndicatorView stopAnimating];
                }
            }
        }];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)dealloc {
    _messagePhoto = nil;
    [self.activityIndicatorView stopAnimating];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    rect.origin = CGPointZero;
    [self.messagePhoto drawInRect:rect];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height+1;//莫名其妙会出现绘制底部有残留 +1像素遮盖
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    CGFloat radius = 6;
    CGFloat margin = 8;//留出上下左右的边距
    
    CGFloat triangleSize = 8;//三角形的边长
    CGFloat triangleMarginTop = 8;//三角形距离圆角的距离
    
    CGFloat borderOffset = 3;//阴影偏移量
    UIColor *borderColor = [UIColor blackColor];//阴影的颜色
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,0,0,0,1);//画笔颜色
    CGContextSetLineWidth(context, 1);//画笔宽度
    // 移动到初始点
    CGContextMoveToPoint(context, radius + margin, margin);
    // 绘制第1条线和第1个1/4圆弧
    CGContextAddLineToPoint(context, width - radius - margin, margin);
    CGContextAddArc(context, width - radius-margin, radius+margin, radius, -0.5 * M_PI, 0.0, 0);
    CGContextAddLineToPoint(context, width, margin + radius);
    CGContextAddLineToPoint(context, width, 0);
    CGContextAddLineToPoint(context, radius + margin,0);
    // 闭合路径
    CGContextClosePath(context);
    // 绘制第2条线和第2个1/4圆弧
    CGContextMoveToPoint(context, width-margin, margin+radius);
    CGContextAddLineToPoint(context, width, margin+radius);
    CGContextAddLineToPoint(context, width, height-margin-radius);
    CGContextAddLineToPoint(context, width-margin, height-margin-radius);
    if (self.bubbleMessageType == XHBubbleMessageTypeSending) {
        //绘制右边三角形
        CGContextAddLineToPoint(context,width-margin , margin+radius+triangleMarginTop+triangleSize);
        CGContextAddLineToPoint(context,width , margin+radius+triangleMarginTop+triangleSize*0.5);
        CGContextAddLineToPoint(context,width-margin , margin+radius+triangleMarginTop);
    }
    
    
    CGContextMoveToPoint(context, width - margin, height - radius - margin);
    CGContextAddArc(context, width - radius - margin, height - radius - margin, radius, 0.0, 0.5 * M_PI, 0);
    CGContextAddLineToPoint(context, width - margin - radius, height);
    CGContextAddLineToPoint(context, width, height);
    CGContextAddLineToPoint(context, width, height - radius - margin);
    
    
    // 绘制第3条线和第3个1/4圆弧
    CGContextMoveToPoint(context, width - margin - radius, height - margin);
    CGContextAddLineToPoint(context, width - margin - radius, height);
    CGContextAddLineToPoint(context, margin, height);
    CGContextAddLineToPoint(context, margin, height - margin);
    
    
    CGContextMoveToPoint(context, margin, height-margin);
    CGContextAddArc(context, radius+margin, height - radius - margin, radius, 0.5 * M_PI, M_PI, 0);
    CGContextAddLineToPoint(context, 0, height - margin - radius);
    CGContextAddLineToPoint(context, 0, height);
    CGContextAddLineToPoint(context, margin, height);
    
    
    // 绘制第4条线和第4个1/4圆弧
    CGContextMoveToPoint(context, margin, height - margin - radius);
    CGContextAddLineToPoint(context, 0, height - margin - radius);
    CGContextAddLineToPoint(context, 0, radius + margin);
    CGContextAddLineToPoint(context, margin, radius + margin);
    
    if (!self.bubbleMessageType == XHBubbleMessageTypeSending) {
        //绘制左边三角形
        CGContextAddLineToPoint(context, margin , margin + radius + triangleMarginTop);
        CGContextAddLineToPoint(context,0 , margin + radius + triangleMarginTop + triangleSize * 0.5);
        CGContextAddLineToPoint(context, margin , margin + radius + triangleMarginTop + triangleSize);
    }
    CGContextMoveToPoint(context, margin, radius + margin);
    CGContextAddArc(context, radius + margin, margin + radius, radius, M_PI, 1.5 * M_PI, 0);
    CGContextAddLineToPoint(context, margin + radius, 0);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, radius + margin);
    
    
    //
    
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), borderOffset, borderColor.CGColor);//阴影
    CGContextSetBlendMode(context, kCGBlendModeClear);
    
    
    CGContextDrawPath(context, kCGPathFill);
}

@end
