//
//  SETextMagnifierCaret.h
//  SECoreTextView-iOS
//
//  Created by kishikawa katsumi on 2013/04/23.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SETextMagnifierCaret : UIView

- (void)showInView:(UIView *)view atPoint:(CGPoint)point;
- (void)moveToPoint:(CGPoint)point;
- (void)hide;

@end
#endif
