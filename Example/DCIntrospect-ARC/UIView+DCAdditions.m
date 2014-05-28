//
//  UIView+DCAdditions.m
//
//  Created by Paddy O'Brien on 2013-10-22.
//
//

#import "UIView+DCAdditions.h"

#import <objc/runtime.h>

@implementation UIView (DCAdditions)
- (UIColor *)dc_originalBackgroundColor
{
	UIColor *originalBackgroundColor = objc_getAssociatedObject(self, @selector(dc_originalBackgroundColor));
	
	// If we dont have an original background color assume the current is the original
	if (!originalBackgroundColor) {
		originalBackgroundColor = self.backgroundColor;

		if (!originalBackgroundColor)
			originalBackgroundColor = (UIColor *)[NSNull null];
		
		objc_setAssociatedObject(self, @selector(dc_originalBackgroundColor), originalBackgroundColor, OBJC_ASSOCIATION_RETAIN);
	}
	
	// We use NSNull as a sentinel value for if the original background color is nil
	if (originalBackgroundColor && [originalBackgroundColor isKindOfClass:[NSNull class]]) return nil;
	
	return originalBackgroundColor;
}
@end
