//
//  UIView+Convenience.m
//
//  Created by Molon on 13/11/12.
//  Copyright (c) 2013 Molon. All rights reserved.
//

#import "UIView+convenience.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Convenience)

- (BOOL)containsSubView:(UIView *)subView
{
    for (UIView *view in [self subviews]) {
        if ([view isEqual:subView]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsSubViewOfClassType:(Class)class {
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:class]) {
            return YES;
        }
    }
    return NO;
}

- (void)removeAllSubViews {
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
}

- (CGPoint)frameOrigin {
	return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin {
	self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize {
	return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							newSize.width, newSize.height);
}

- (CGFloat)frameX {
	return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)newX {
	self.frame = CGRectMake(newX, self.frame.origin.y,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY {
	return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)newY {
	self.frame = CGRectMake(self.frame.origin.x, newY,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameRight {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)newRight {
	self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameBottom {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)newBottom {
	self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameWidth {
	return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)newWidth {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							newWidth, self.frame.size.height);
}

- (CGFloat)frameHeight {
	return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)newHeight {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							self.frame.size.width, newHeight);
}

@end
