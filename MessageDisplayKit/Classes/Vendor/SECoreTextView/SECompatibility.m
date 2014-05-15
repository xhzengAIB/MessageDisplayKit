//
//  SECompatibility.m
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/21.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "SECompatibility.h"

#if TARGET_OS_IPHONE
NSString * const NSLinkAttributeName = @"NSLink";
NSString * const NSStrikethroughStyleAttributeName = @"NSStrikethrough";
#else
@implementation NSColor (Compatibility)

- (CGColorRef)createCGColor
{
    const NSInteger numberOfComponents = [self numberOfComponents];
    CGFloat components[numberOfComponents];
    CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];
    
    [self getComponents:(CGFloat *)&components];
    
    return CGColorCreate(colorSpace, components);
}

@end
#endif

@implementation SECompatibility

@end
