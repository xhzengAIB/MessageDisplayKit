//
//  SETextSelection.m
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/20.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "SETextSelection.h"

@interface SETextSelection ()

@property (assign, nonatomic) NSInteger initialIndex;

@end

@implementation SETextSelection

- (id)initWithIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        _initialIndex = index;
    }
    
    return self;
}

- (void)setSelectionEndAtIndex:(NSInteger)index
{
    if (self.initialIndex <= index) {
        CFIndex start = self.initialIndex;
        CFIndex end = index;
        _selectedRange = NSMakeRange(start, end - start);
    } else {
        CFIndex start = index;
        CFIndex end = self.initialIndex;
        _selectedRange = NSMakeRange(start, end - start);
    }
}

- (NSString *)description
{
    return NSStringFromRange(self.selectedRange);
}

@end
