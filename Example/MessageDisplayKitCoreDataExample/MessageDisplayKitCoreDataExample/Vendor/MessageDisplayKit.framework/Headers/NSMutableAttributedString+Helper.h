//
//  NSMutableAttributedString+Helper.h
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/28.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "SECompatibility.h"

@interface NSMutableAttributedString(Helper)

- (void)addFontAttribute:(NSFont *)font range:(NSRange)range;

@end
