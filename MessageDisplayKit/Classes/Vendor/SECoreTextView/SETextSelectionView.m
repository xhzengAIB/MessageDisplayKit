//
//  SETextSelectionView.m
//  SECoreTextView-iOS
//
//  Created by kishikawa katsumi on 2013/09/23.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
#import "SETextSelectionView.h"
#import "SETextView.h"
#import "SESelectionGrabber.h"
#import "SETextLayout.h"
#import "SELineLayout.h"
#import "SETextSelection.h"

static const CGFloat SESelectionGrabberWidth = 32.0f;

@interface SETextView (Private)

@property (nonatomic) SETextLayout *textLayout;

- (void)selectionGestureStateChanged:(UILongPressGestureRecognizer *)gestureRecognizer;
- (void)grabberMoved:(UIPanGestureRecognizer *)gestureRecognizer;

@end

@interface SETextSelectionView ()

@end

@implementation SETextSelectionView

- (instancetype)initWithFrame:(CGRect)frame textView:(SETextView *)textView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.textView = textView;
        
        self.selectionGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self.textView action:@selector(selectionGestureStateChanged:)];
        [self addGestureRecognizer:self.selectionGestureRecognizer];
        
        self.startGrabber = [[SESelectionGrabber alloc] init];
        self.startGrabber.dotMetric = SESelectionGrabberDotMetricTop;
        [self addSubview:self.startGrabber];
        
        self.endGrabber = [[SESelectionGrabber alloc] init];
        self.endGrabber.dotMetric = SESelectionGrabberDotMetricBottom;
        [self addSubview:self.endGrabber];
        
        self.startGrabberGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.textView action:@selector(grabberMoved:)];
        [self.startGrabber addGestureRecognizer:self.startGrabberGestureRecognizer];
        
        self.endGrabberGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.textView action:@selector(grabberMoved:)];
        [self.endGrabber addGestureRecognizer:self.endGrabberGestureRecognizer];
    }
    
    return self;
}

#pragma mark -

- (void)update
{
    CGRect startFrame = self.startFrame;
    startFrame.origin.x = CGRectGetMinX(self.startFrame) - SESelectionGrabberWidth / 2;
    startFrame.size.width = SESelectionGrabberWidth;
    
    CGRect endFrame = self.endFrame;
    endFrame.origin.x = CGRectGetMaxX(self.endFrame) - SESelectionGrabberWidth / 2;
    endFrame.size.width = SESelectionGrabberWidth;
    
    self.startGrabber.frame = startFrame;
    self.endGrabber.frame = endFrame;
}

- (void)showControls
{
    self.startGrabber.hidden = NO;
    self.endGrabber.hidden = NO;
}

- (void)hideControls
{
    self.startGrabber.hidden = YES;
    self.endGrabber.hidden = YES;
}

#pragma mark -

-  (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return [self.textView canPerformAction:action withSender:sender];
}

- (void)copy:(id)sender
{
    [self.textView copy:sender];
}

- (void)select:(id)sender
{
    [self.textView select:sender];
}

- (void)selectAll:(id)sender
{
    [self.textView selectAll:sender];
}

@end
#endif
