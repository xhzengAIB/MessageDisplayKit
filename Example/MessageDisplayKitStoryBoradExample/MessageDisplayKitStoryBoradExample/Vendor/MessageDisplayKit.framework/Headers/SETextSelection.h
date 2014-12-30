//
//  SETextSelection.h
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/20.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SETextSelection : NSObject

@property (nonatomic) NSRange selectedRange;

- (id)initWithIndex:(NSInteger)index;
- (void)setSelectionEndAtIndex:(NSInteger)index;

@end
