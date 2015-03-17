//
//  SESelectionGrabber.m
//  SECoreTextView-iOS
//
//  Created by kishikawa katsumi on 2013/04/23.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
#import "SESelectionGrabber.h"
#import "SEConstants.h"

@interface SESelectionGrabberDot : UIView

@property (nonatomic) UIBezierPath *path;

@end

@implementation SESelectionGrabberDot

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [[SEConstants selectionCaretColor] set];
    [self.path fill];
}

@end

@interface SESelectionGrabber ()

@property (nonatomic) UIView *caretView;
@property (nonatomic) UIView *dotView;

@end

@implementation SESelectionGrabber

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.caretView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 2.0f, 0.0f)];
        self.caretView.backgroundColor = [SEConstants selectionCaretColor];
        [self addSubview:self.caretView];
        
        self.dotView = [[SESelectionGrabberDot alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        [self addSubview:self.dotView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect caretFrame = self.caretView.frame;
    caretFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(caretFrame)) / 2;
    caretFrame.size.height = CGRectGetHeight(self.bounds);
    self.caretView.frame = caretFrame;
    
    CGRect dotFrame = self.dotView.frame;
    if (self.dotMetric == SESelectionGrabberDotMetricTop) {
        dotFrame.origin = CGPointMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(dotFrame)) / 2, -CGRectGetHeight(dotFrame));
    } else {
        dotFrame.origin = CGPointMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(dotFrame)) / 2, CGRectGetHeight(self.bounds));
    }
    self.dotView.frame = dotFrame;
}

@end
#endif
