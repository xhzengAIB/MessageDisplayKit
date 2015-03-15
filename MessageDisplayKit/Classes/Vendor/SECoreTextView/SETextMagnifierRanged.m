//
//  SETextMagnifierRanged.m
//  SECoreTextView-iOS
//
//  Created by kishikawa katsumi on 2013/04/26.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
#import "SETextMagnifierRanged.h"

@interface SETextMagnifierRanged ()
{
    CGImageRef _maskRef;
}

@property (weak, nonatomic) UIView *magnifyToView;
@property (assign, nonatomic) CGPoint touchPoint;

@property (strong, nonatomic) UIImage *mask;
@property (strong, nonatomic) UIImage *loupe;
@property (strong, nonatomic) UIImage *loupeFrame;

@end

@implementation SETextMagnifierRanged

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *mask = [UIImage imageNamed:@"SECoreTextView.bundle/kb-magnifier-ranged-mask-flipped"];
        self.mask = mask;
        
        self.loupe = [UIImage imageNamed:@"SECoreTextView.bundle/kb-magnifier-ranged-hi"];
        self.loupeFrame = [UIImage imageNamed:@"SECoreTextView.bundle/kb-magnifier-ranged-lo"];
        
        CGImageRef maskImageRef = self.mask.CGImage;
        _maskRef = CGImageMaskCreate(CGImageGetWidth(maskImageRef),
                                     CGImageGetHeight(maskImageRef),
                                     CGImageGetBitsPerComponent(maskImageRef),
                                     CGImageGetBitsPerPixel(maskImageRef),
                                     CGImageGetBytesPerRow(maskImageRef),
                                     CGImageGetDataProvider(maskImageRef),
                                     NULL,
                                     true);
    }
    
    return self;
}

- (void)dealloc
{
    CGImageRelease(_maskRef);
}

- (void)setTouchPoint:(CGPoint)point
{
    _touchPoint = point;
    CGFloat x = point.x;
    CGFloat y = point.y;
    if (y - CGRectGetHeight(self.bounds) < CGRectGetMinY(self.magnifyToView.frame)) {
        y = CGRectGetMinY(self.magnifyToView.frame) + CGRectGetHeight(self.bounds);
    } else {
        y -= CGRectGetHeight(self.bounds);
    }
    self.center = CGPointMake(x, y);
}

- (void)showInView:(UIView *)view atPoint:(CGPoint)point
{
    self.frame = CGRectMake(0.0f, 0.0f, self.mask.size.width, self.mask.size.height);
    
    self.magnifyToView = view;
    self.touchPoint = point;
    
    [view addSubview:self];
    
    CGRect frame = self.frame;
    CGPoint center = self.center;
    
    CGRect startFrame = self.frame;
    startFrame.size = CGSizeZero;
    self.frame = startFrame;
    
    CGPoint startPosition = self.center;
    startPosition.x += frame.size.width / 2;
    startPosition.y += frame.size.height;
    self.center = startPosition;
    
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:kNilOptions
                     animations:^
     {
         self.frame = frame;
         self.center = center;
     }
                     completion:NULL];
}

- (void)moveToPoint:(CGPoint)point
{
    self.touchPoint = point;
    [self setNeedsDisplay];
}

- (void)hide
{
    CGRect bounds = self.bounds;
    bounds.size = CGSizeZero;
    
    CGPoint position = self.touchPoint;
    
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:kNilOptions
                     animations:^
     {
         self.bounds = bounds;
         self.center = position;
     }
                     completion:^(BOOL finished)
     {
         self.magnifyToView = nil;
         [self removeFromSuperview];
     }];
}

- (void)drawRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(self.magnifyToView.bounds.size);
    [self.magnifyToView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *captureImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef captureImageRef = captureImage.CGImage;
    
    CGFloat scale = 1.2f;
    CGRect box = CGRectMake(ceilf(self.touchPoint.x - self.mask.size.width / scale / 2),
                            ceilf(self.touchPoint.y - self.mask.size.height / scale / 2),
                            ceilf(self.mask.size.width / scale),
                            ceilf(self.mask.size.height / scale));
    
    CGImageRef subImage = CGImageCreateWithImageInRect(captureImageRef, box);
    CGImageRef maskedImage = CGImageCreateWithMask(subImage, _maskRef);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGAffineTransform xform = CGAffineTransformMake(1.0,  0.0,
                                                    0.0, -1.0,
                                                    0.0,  0.0);
    CGContextConcatCTM(context, xform);
    
    CGRect area = CGRectMake(0, 0, self.mask.size.width, -self.mask.size.height);
    
    CGContextDrawImage(context, area, self.loupeFrame.CGImage);
    CGContextDrawImage(context, area, maskedImage);
    CGContextDrawImage(context, area, self.loupe.CGImage);
    
    CGImageRelease(subImage);
    CGImageRelease(maskedImage);
}

@end
#endif
