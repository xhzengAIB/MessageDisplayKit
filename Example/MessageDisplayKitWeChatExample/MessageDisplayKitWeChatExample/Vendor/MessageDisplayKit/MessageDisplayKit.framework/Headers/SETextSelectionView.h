//
//  SETextSelectionView.h
//  SECoreTextView-iOS
//
//  Created by kishikawa katsumi on 2013/09/23.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

@class SETextView, SESelectionGrabber, SETextLayout;

@interface SETextSelectionView : UIView

- (instancetype)initWithFrame:(CGRect)frame textView:(SETextView *)textView;

@property (nonatomic, weak) SETextView *textView;

@property (nonatomic) SESelectionGrabber *startGrabber;
@property (nonatomic) SESelectionGrabber *endGrabber;

@property (nonatomic) UILongPressGestureRecognizer *selectionGestureRecognizer;
@property (nonatomic) UIPanGestureRecognizer *startGrabberGestureRecognizer;
@property (nonatomic) UIPanGestureRecognizer *endGrabberGestureRecognizer;

@property (nonatomic) CGRect startFrame;
@property (nonatomic) CGRect endFrame;

- (void)update;

- (void)showControls;
- (void)hideControls;

@end
#endif
