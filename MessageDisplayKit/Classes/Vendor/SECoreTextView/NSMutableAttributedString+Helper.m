//
//  NSMutableAttributedString+Helper.m
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/28.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "NSMutableAttributedString+Helper.h"

@implementation NSMutableAttributedString(Helper)

- (void)addFontAttribute:(NSFont *)font range:(NSRange)range
{
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFloat fontSize = font.pointSize;
    CTFontRef ctfont = CTFontCreateWithName(fontName, fontSize, NULL);
    [self addAttributes:@{(id)kCTFontAttributeName: (__bridge id)ctfont} range:range];
    CFRelease(ctfont);
}

@end
