//
//  SETextInput.m
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/09/22.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#if TARGET_OS_IPHONE
#import "SETextInput.h"

@implementation SETextRange

+ (SETextRange *)rangeWithNSRange:(NSRange)theRange
{
    if (theRange.location == NSNotFound) {
        return nil;
    }
    
    SETextRange *range = [[SETextRange alloc] init];
    range.range = theRange;
    return range;
}

- (UITextPosition *)start
{
    return [SETextPosition positionWithIndex:self.range.location];
}

- (UITextPosition *)end
{
    return [SETextPosition positionWithIndex:self.range.location + self.range.length];
}

- (BOOL)isEmpty
{
    return self.range.length == 0;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@)", [super description], NSStringFromRange(self.range)];
}

@end

@implementation SETextPosition

+ (SETextPosition *)positionWithIndex:(NSUInteger)index
{
    SETextPosition *position = [[SETextPosition alloc] init];
    position.index = index;
    return position;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%lu)", [super description], (unsigned long)self.index];
}

@end
#endif
