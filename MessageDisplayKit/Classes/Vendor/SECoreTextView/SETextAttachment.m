//
//  SETextAttachment.m
//  SECoreTextView-iOS
//
//  Created by kishikawa katsumi on 2013/04/26.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "SETextAttachment.h"
#import "SECompatibility.h"

static void RunDelegateDeallocateCallback(void *refCon)
{
    
}

static CGFloat RunDelegateGetAscentCallback(void *refCon)
{
    SETextAttachment *object = (__bridge SETextAttachment *)refCon;
    return object.size.height;
}

static CGFloat RunDelegateGetDescentCallback(void *refCon)
{
    return 0.0f;
}

static CGFloat RunDelegateGetWidthCallback(void *refCon)
{
    SETextAttachment *object = (__bridge SETextAttachment *)refCon;
    return object.size.width;
}

@implementation SETextAttachment

- (id)initWithObject:(id)object size:(CGSize)size range:(NSRange)range
{
    self = [super init];
    if (self) {
        _object = object;
        _size = size;
        _range = range;
    }
    return self;
}

- (void)dealloc
{
    if ([_object isKindOfClass:[NSView class]]) {
        NSView *view = _object;
        if (view.superview) {
            [view removeFromSuperview];
        }
    }
}

- (CTRunDelegateCallbacks)callbacks
{
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = RunDelegateDeallocateCallback;
    callbacks.getAscent = RunDelegateGetAscentCallback;
    callbacks.getDescent = RunDelegateGetDescentCallback;
    callbacks.getWidth = RunDelegateGetWidthCallback;
    
    return callbacks;
}

- (void)setReplacedString:(NSString *)replacedString
{
    _replacedString = replacedString;
    _range = NSMakeRange(_range.location, replacedString.length);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, size: %@, range: %@", [super description], self.object, NSStringFromSize(self.size), NSStringFromRange(self.range)];
}

@end
