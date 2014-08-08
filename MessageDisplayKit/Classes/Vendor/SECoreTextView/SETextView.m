//
//  SETextView.m
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/20.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "SETextView.h"
#import "SETextInput.h"
#import "SETextLayout.h"
#import "SELineLayout.h"
#import "SETextAttachment.h"
#import "SETextSelection.h"
#import "SETextSelectionView.h"
#import "SETextEditingCaret.h"
#import "SETextMagnifierCaret.h"
#import "SETextMagnifierRanged.h"
#import "SESelectionGrabber.h"
#import "SELinkText.h"
#import "SETextGeometry.h"
#import "SEConstants.h"

typedef NS_ENUM (NSUInteger, SETouchPhase) {
    SETouchPhaseNone       = 0,
    SETouchPhaseBegan      = 1 << 0,
    SETouchPhaseMoved      = 1 << 1,
    SETouchPhaseStationary = 1 << 2,
    SETouchPhaseEnded      = SETouchPhaseNone,
    SETouchPhaseCancelled  = SETouchPhaseNone,
    SETouchPhaseTouching   = SETouchPhaseBegan | SETouchPhaseMoved | SETouchPhaseStationary,
    SETouchPhaseAny        = NSUIntegerMax
};

static NSString * const OBJECT_REPLACEMENT_CHARACTER = @" ";
static NSString * const ZERO_WIDTH_SPACE = @"\u200B";
static NSString * const LINE_SEPARATOR = @"\u2028";
static NSString * const PARAGRAPH_SEPARATOR = @"\u2029";

@interface SETextView ()

@property (nonatomic) SETextLayout *textLayout;

@property (nonatomic) NSMutableSet *attachments;

@property (nonatomic) SETouchPhase touchPhase;
@property (nonatomic) CGPoint clickPoint;
@property (nonatomic) CGPoint mouseLocation;

@property (nonatomic, readonly) NSMutableAttributedString *editingAttributedText;
@property (nonatomic, copy) NSAttributedString *originalAttributedTextWhenHighlighting;

@property (nonatomic, weak) NSTimer *longPressTimer;
@property (nonatomic, getter = isLongPressing) BOOL longPressing;

@property (nonatomic, readwrite) BOOL editing;

#if TARGET_OS_IPHONE
@property (nonatomic) UITextInputStringTokenizer *tokenizer;

@property (nonatomic) SETextMagnifierCaret *magnifierCaret;
@property (nonatomic) SETextMagnifierRanged *magnifierRanged;

@property (nonatomic) SETextSelectionView *textSelectionView;
@property (nonatomic) SETextEditingCaret *caretView;

@property (nonatomic, copy) NSAttributedString *storedAttributedText;
#endif

@end

@implementation SETextView

#if TARGET_OS_IPHONE
@synthesize inputDelegate;
@synthesize markedTextStyle;
#endif

- (void)commonInit
{
    self.textLayout = [[SETextLayout alloc] init];
    self.textLayout.bounds = self.bounds;
    
    self.attachments = [[NSMutableSet alloc] init];
    
    self.highlightedTextColor = [NSColor whiteColor];
    self.selectedTextBackgroundColor = [SEConstants selectedTextBackgroundColor];
    self.linkHighlightColor = [SEConstants selectedTextBackgroundColor];
    self.linkRolloverEffectColor = [SEConstants linkColor];
    
    self.minimumLongPressDuration = 0.5;
    
#if TARGET_OS_IPHONE
    self.showsEditingMenuAutomatically = YES;
    
    self.magnifierCaret = [[SETextMagnifierCaret alloc] init];
    self.magnifierRanged = [[SETextMagnifierRanged alloc] init];
    
    [self setupTextSelectionControls];
    [self setupTextEditingControls];
    
    self.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.autocorrectionType = UITextAutocorrectionTypeDefault;
    self.spellCheckingType = UITextSpellCheckingTypeDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.returnKeyType = UIReturnKeyDefault;
    self.enablesReturnKeyAutomatically = NO;
    self.secureTextEntry = NO;
#endif
}

#if TARGET_OS_IPHONE
- (void)setupTextSelectionControls
{
    CGRect frame = self.bounds;
    self.textSelectionView = [[SETextSelectionView alloc] initWithFrame:frame textView:self];
    self.textSelectionView.userInteractionEnabled = NO;
    self.textSelectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.textSelectionView];
}

- (void)setupTextEditingControls
{
    self.caretView = [[SETextEditingCaret alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 2.0f, 0.0f)];
    [self addSubview:self.caretView];
}
#endif

- (void)awakeFromNib
{
    [self commonInit];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)dealloc
{
#if TARGET_OS_IPHONE
    [self.caretView stopBlink];
#endif
}

#pragma mark -

+ (CGRect)frameRectWithAttributtedString:(NSAttributedString *)attributedString
                          constraintSize:(CGSize)constraintSize
{
    return [self frameRectWithAttributtedString:attributedString
                                 constraintSize:constraintSize
                                    lineSpacing:0.0f];
}

+ (CGRect)frameRectWithAttributtedString:(NSAttributedString *)attributedString
                          constraintSize:(CGSize)constraintSize
                             lineSpacing:(CGFloat)lineSpacing
{
    return [self frameRectWithAttributtedString:attributedString
                                 constraintSize:constraintSize
                                    lineSpacing:lineSpacing
                                           font:nil];
}

+ (CGRect)frameRectWithAttributtedString:(NSAttributedString *)attributedString
                          constraintSize:(CGSize)constraintSize
                             lineSpacing:(CGFloat)lineSpacing
                                    font:(NSFont *)font
{
    return [self frameRectWithAttributtedString:attributedString
                                 constraintSize:constraintSize
                                    lineSpacing:lineSpacing
                               paragraphSpacing:0.0f
                                           font:font];
}

+ (CGRect)frameRectWithAttributtedString:(NSAttributedString *)attributedString
                          constraintSize:(CGSize)constraintSize
                             lineSpacing:(CGFloat)lineSpacing
                        paragraphSpacing:(CGFloat)paragraphSpacing
                                    font:(NSFont *)font
{
    NSInteger length = attributedString.length;
    NSMutableAttributedString *mutableAttributedString = attributedString.mutableCopy;
    
    CTTextAlignment textAlignment = kCTTextAlignmentNatural;
    lineSpacing = roundf(lineSpacing);
    CGFloat lineHeight = 0.0f;
    paragraphSpacing = roundf(paragraphSpacing);
    
    CTParagraphStyleSetting setting[] = {
        { kCTParagraphStyleSpecifierAlignment, sizeof(textAlignment), &textAlignment},
        { kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(lineHeight), &lineHeight },
        { kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(lineHeight), &lineHeight },
        { kCTParagraphStyleSpecifierLineSpacing, sizeof(lineSpacing), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(lineSpacing), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(lineSpacing), &lineSpacing },
        { kCTParagraphStyleSpecifierParagraphSpacing, sizeof(paragraphSpacing), &paragraphSpacing }
    };
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(setting, sizeof(setting) / sizeof(CTParagraphStyleSetting));
    [mutableAttributedString addAttributes:@{(id)kCTParagraphStyleAttributeName: (__bridge id)paragraphStyle} range:NSMakeRange(0, length)];
    CFRelease(paragraphStyle);
    
    attributedString = mutableAttributedString;
    
    if (font) {
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFloat fontSize = font.pointSize;
        CTFontRef ctfont = CTFontCreateWithName(fontName, fontSize, NULL);
        [mutableAttributedString addAttributes:@{(id)kCTFontAttributeName: (__bridge id)ctfont} range:NSMakeRange(0, length)];
        CFRelease(ctfont);
        
        attributedString = mutableAttributedString;
    }
    
    return [SETextLayout frameRectWithAttributtedString:attributedString
                                         constraintSize:constraintSize];
}

#pragma mark -

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplayInRect:self.bounds];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self setNeedsDisplayInRect:self.bounds];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    [self setAdditionalAttributes];
    
    CGRect frameRect = [self.class frameRectWithAttributtedString:self.attributedText
                                                   constraintSize:size
                                                      lineSpacing:self.lineSpacing
                                                             font:self.font];
    return frameRect.size;
}

- (void)sizeToFit
{
    CGSize size = [self sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX)];
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark -

- (void)setSelectable:(BOOL)selectable
{
    _selectable = selectable;
#if TARGET_OS_IPHONE
    self.textSelectionView.userInteractionEnabled = self.isSelectable;
#endif
}

- (void)setEditable:(BOOL)editable
{
    _editable = editable;
    if (self.isEditable) {
        self.selectable = YES;
    }
}

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    self.textLayout.editing = editing;
    
#if TARGET_OS_IPHONE
    if (!editing) {
        self.caretView.hidden = YES;
    }
#endif
}

- (void)setText:(NSString *)text
{
    _text = text;
    if (self.text) {
        self.attributedText = [[NSAttributedString alloc] initWithString:text];
    } else {
        self.attributedText = nil;
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedText = attributedText.copy;
    _text = _attributedText.string;
    
    [self setNeedsDisplayInRect:self.bounds];
}

- (CGRect)layoutFrame
{
    return self.textLayout.frameRect;
}

- (NSRange)selectedRange
{
    return self.textLayout.textSelection.selectedRange;
}

#if TARGET_OS_IPHONE
- (void)setSelectedRange:(NSRange)selectedRange
{
    self.selectedTextRange = [SETextRange rangeWithNSRange:selectedRange];
}
#endif

- (NSString *)selectedText
{
    return [self.text substringWithRange:self.selectedRange];
}

- (NSAttributedString *)selectedAttributedText
{
    return [self.attributedText attributedSubstringFromRange:self.selectedRange];
}

- (NSMutableString *)editingText
{
    return self.text ? self.text.mutableCopy : [[NSMutableString alloc] init];
}

- (NSMutableAttributedString *)editingAttributedText
{
    return self.attributedText ? self.attributedText.mutableCopy : [[NSMutableAttributedString alloc] init];
}

- (CGRect)caretRect
{
#if TARGET_OS_IPHONE
    return self.caretView.frame;
#else
    return CGRectNull;
#endif
}

#pragma mark -

- (void)addObject:(id)object size:(CGSize)size atIndex:(NSInteger)index
{
    [self addObject:object size:size replaceRange:NSMakeRange(index, 0)];
}

- (void)addObject:(id)object size:(CGSize)size replaceRange:(NSRange)range
{
    SETextAttachment *attachment = [[SETextAttachment alloc] initWithObject:object size:size range:range];
    [self.attachments addObject:attachment];
}

- (void)setAdditionalAttributes
{
    [self setFontAttributes];
    [self setTextColorAttributes];
    [self setTextAttachmentAttributes];
    [self setParagraphStyle];
}

- (void)setFontAttributes
{
    if (!self.font) {
        return;
    }
    
    CFStringRef fontName = (__bridge CFStringRef)self.font.fontName;
    CGFloat fontSize = self.font.pointSize;
    CTFontRef ctfont = CTFontCreateWithName(fontName, fontSize, NULL);
    [self setAttributes:@{(id)kCTFontAttributeName: (__bridge id)ctfont}];
    CFRelease(ctfont);
}

- (void)setTextColorAttributes
{
    if (!self.textColor) {
        return;
    }
    
#if TARGET_OS_IPHONE
    CGColorRef color = self.textColor.CGColor;
    [self setAttributes:@{(id)kCTForegroundColorAttributeName: (__bridge id)color}];
#else
    NSDictionary *attributes = nil;
    
    CGColorRef color = NULL;
    if ([self.textColor respondsToSelector:@selector(CGColor)]) {
        color = self.textColor.CGColor;
        attributes = @{(id)kCTForegroundColorAttributeName: (__bridge id)color};
    } else {
        color = [self.textColor createCGColor];
        attributes = @{(id)kCTForegroundColorAttributeName: (__bridge id)color};
        CGColorRelease(color);
    }
    [self setAttributes:attributes];
#endif
}

- (void)setTextAttachmentAttributes
{
    NSString *replacementString = OBJECT_REPLACEMENT_CHARACTER;
    
    NSArray *attachments = [self.attachments.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SETextAttachment *attachment1 = obj1;
        SETextAttachment *attachment2 = obj2;
        NSRange range1 = attachment1.range;
        NSRange range2 = attachment2.range;
        NSUInteger maxRange1 = NSMaxRange(range1);
        NSUInteger maxRange2 = NSMaxRange(range2);
        if (maxRange1 < maxRange2) {
            return NSOrderedDescending;
        } else if (maxRange1 > maxRange2) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    for (SETextAttachment *attachment in attachments) {
        NSMutableAttributedString *editingAttributedText = self.editingAttributedText;
        if (!attachment.replacedString) {
            if (attachment.range.length > 0) {
                NSAttributedString *originalAttributedString = [editingAttributedText attributedSubstringFromRange:attachment.range];
                attachment.originalAttributedString = originalAttributedString;
                
                [editingAttributedText replaceCharactersInRange:attachment.range withString:replacementString];
                attachment.replacedString = replacementString;
            } else {
                [editingAttributedText insertAttributedString:[[NSAttributedString alloc] initWithString:replacementString] atIndex:attachment.range.location];
                attachment.replacedString = replacementString;
            }
            
            CTRunDelegateCallbacks callbacks = attachment.callbacks;
            CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callbacks, (__bridge void *)attachment);
            [editingAttributedText addAttributes:@{(id)kCTRunDelegateAttributeName: (__bridge id)runDelegate} range:attachment.range];
            CFRelease(runDelegate);
            
            self.attributedText = editingAttributedText;
        }
    }
}

- (void)setParagraphStyle
{
#if TARGET_OS_IPHONE
    CTTextAlignment textAlignment;
    if (self.textAlignment == NSTextAlignmentRight) {
        textAlignment = kCTTextAlignmentRight;
    } else if (self.textAlignment == NSTextAlignmentCenter) {
        textAlignment = kCTTextAlignmentCenter;
    } else {
        textAlignment = (CTTextAlignment)self.textAlignment;
    }
#else
    CTTextAlignment textAlignment = self.textAlignment;
#endif
    CTLineBreakMode lineBreakMode = (CTLineBreakMode)self.lineBreakMode;
    if (lineBreakMode == kCTLineBreakByTruncatingTail) {
        lineBreakMode = kCTLineBreakByWordWrapping;
    }
    
    CGFloat lineSpacing = roundf(self.lineSpacing);
    CGFloat lineHeight = roundf(self.lineHeight);
    CGFloat paragraphSpacing = roundf(self.paragraphSpacing);
    
    CTParagraphStyleSetting setting[] = {
        { kCTParagraphStyleSpecifierAlignment, sizeof(textAlignment), &textAlignment},
        { kCTParagraphStyleSpecifierLineBreakMode, sizeof(lineBreakMode), &lineBreakMode},
        { kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(lineHeight), &lineHeight },
        { kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(lineHeight), &lineHeight },
        { kCTParagraphStyleSpecifierLineSpacing, sizeof(lineSpacing), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(lineSpacing), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(lineSpacing), &lineSpacing },
        { kCTParagraphStyleSpecifierParagraphSpacing, sizeof(paragraphSpacing), &paragraphSpacing }
    };
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(setting, sizeof(setting) / sizeof(CTParagraphStyleSetting));
    [self setAttributes:@{(id)kCTParagraphStyleAttributeName: (__bridge id)paragraphStyle}];
    CFRelease(paragraphStyle);
    
    self.textLayout.textAlignment = textAlignment;
}

- (void)setAttributes:(NSDictionary *)attributes
{
    NSInteger length = self.attributedText.length;
    NSMutableAttributedString *attributedString = self.attributedText.mutableCopy;
    
    if (attributes) {
        [attributedString addAttributes:attributes range:NSMakeRange(0, length)];
    }
    
    self.attributedText = attributedString;
}

+ (CTLineBreakMode)lineBreakModeFromUILineBreakMode:(NSLineBreakMode)lineBreakMode {
    switch (lineBreakMode) {
        case NSLineBreakByWordWrapping: return kCTLineBreakByWordWrapping;
        case NSLineBreakByCharWrapping: return kCTLineBreakByCharWrapping;
        case NSLineBreakByClipping: return kCTLineBreakByClipping;
        case NSLineBreakByTruncatingHead: return kCTLineBreakByTruncatingHead;
        case NSLineBreakByTruncatingTail: return kCTLineBreakByWordWrapping; // We handle truncation ourself.
        case NSLineBreakByTruncatingMiddle: return kCTLineBreakByTruncatingMiddle;
        default: return 0;
    }
}

- (void)updateLayout
{
    [self setAdditionalAttributes];
    
    self.textLayout.bounds = self.bounds;
    self.textLayout.attributedString = self.attributedText;
    self.textLayout.lineBreakMode = [self.class lineBreakModeFromUILineBreakMode:self.lineBreakMode];
    
    [self.textLayout update];
}

#pragma mark -

- (void)clearSelection
{
    self.textLayout.textSelection = nil;
}

- (void)finishSelecting
{
#if TARGET_OS_IPHONE
    if (!self.editing) {
        if (self.showsEditingMenuAutomatically) {
            [self hideEditingMenu];
            [self showEditingMenu];
        }
    }
#endif
    
    if ([self respondsToSelector:@selector(textViewDidEndSelecting:)]) {
        [self.delegate textViewDidEndSelecting:self];
    }
}

- (void)selectionChanged
{
#if TARGET_OS_IPHONE
    [self updateCaretPosition];
#endif
    [self notifySelectionChanged];
    [self setNeedsDisplayInRect:self.bounds];
}

- (void)notifySelectionChanged
{
    if ([self.delegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.delegate textViewDidChangeSelection:self];
    }
}

- (void)textChanged
{
    [self notifyTextChanged];
}

- (void)notifyTextChanged
{
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}

- (void)clickedOnLink:(SELinkText *)link
{
    if ([self.delegate respondsToSelector:@selector(textView:clickedOnLink:atIndex:)]) {
        [self.delegate textView:self clickedOnLink:link atIndex:[self stringIndexAtPoint:self.mouseLocation]];
    }
}

- (void)longPressedOnLink:(SELinkText *)link
{
    if ([self.delegate respondsToSelector:@selector(textView:longPressedOnLink:atIndex:)]) {
        [self.delegate textView:self longPressedOnLink:link atIndex:[self stringIndexAtPoint:self.mouseLocation]];
    }
}

#pragma mark -

- (CFIndex)stringIndexAtPoint:(CGPoint)point
{
    return [self.textLayout stringIndexForPosition:point];
}

- (BOOL)containsPointInSelection:(CGPoint)point
{
    CFIndex index = [self stringIndexAtPoint:point];
    NSRange selectedRange = self.selectedRange;
    return NSLocationInRange(index, selectedRange);
}

- (BOOL)containsPointInTextFrame:(CGPoint)point
{
    return CGRectContainsPoint(self.textLayout.frameRect, point);
}

- (SELinkText *)linkAtPoint:(CGPoint)point
{
    for (SELineLayout *lineLayout in self.textLayout.lineLayouts) {
        SELinkText *link = [lineLayout linkAtPoint:point];
        if (link) {
            return link;
        }
    }
    
    return nil;
}

- (void)enumerateLinksUsingBlock:(void (^)(SELinkText *link, BOOL *stop))block
{
    for (SELineLayout *lineLayout in self.textLayout.lineLayouts) {
        for (SELinkText *link in lineLayout.links) {
            BOOL flag = NO;
            block(link, &flag);
            if (flag) {
                break;
            }
        }
    }
}

#if TARGET_OS_IPHONE
- (void)drawTextDecorations
{
    [self.attributedText enumerateAttribute:NSStrikethroughStyleAttributeName inRange:NSMakeRange(0, self.attributedText.length) options:kNilOptions usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (!value) {
            return;
        }
        
        for (SELineLayout *lineLayout in self.textLayout.lineLayouts) {
            CGRect strikeRect = [lineLayout rectOfStringWithRange:range];
            if (!CGRectIsEmpty(strikeRect)) {
                if (self.textColor) {
                    [self.textColor set];
                }
                else {
                    [[UIColor blackColor] set];
                }
                
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(CGRectGetMinX(strikeRect), CGRectGetMidY(strikeRect))];
                [path addLineToPoint:CGPointMake(CGRectGetMaxX(strikeRect), CGRectGetMidY(strikeRect))];
                [path stroke];
            }
        }
    }];
}
#endif

- (void)drawTextAttachmentsInContext:(CGContextRef)context
{
    NSMutableSet *attachmentsToLeave = [[NSMutableSet alloc] init];
    
    [self.attributedText enumerateAttribute:(id)kCTRunDelegateAttributeName inRange:NSMakeRange(0, self.text.length) options:kNilOptions usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (!value) {
            return;
        }
        
        CTRunDelegateRef runDelegate = (__bridge CTRunDelegateRef)value;
        SETextAttachment *attachment = (__bridge SETextAttachment *)CTRunDelegateGetRefCon(runDelegate);
        if (!attachment) {
            return;
        }
        
        [attachmentsToLeave addObject:attachment];
        
        for (SELineLayout *lineLayout in self.textLayout.lineLayouts) {
            CGRect lineRect = lineLayout.rect;
            CGRect rect = [lineLayout rectOfStringWithRange:range];
            if (!CGRectIsEmpty(rect) && CGRectGetMaxX(rect) <= (CGRectGetMaxX(lineRect) - lineLayout.truncationTokenWidth)) {
                id object = attachment.object;
                CGSize size = attachment.size;
                rect.origin.x += (CGRectGetWidth(rect) - size.width) / 2;
                rect.origin.y += CGRectGetHeight(rect) - size.height;
                rect.size = size;
                rect = CGRectIntegral(rect);
                if ([object isKindOfClass:[NSView class]]) {
                    UIView *view = object;
                    view.frame = rect;
                    if (!view.superview) {
                        [self addSubview:view];
                    }
                } else if ([object isKindOfClass:[NSImage class]]) {
                    NSImage *image = object;
#if TARGET_OS_IPHONE
                    [image drawInRect:rect];
#else
                    [image drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
#endif
                } else if ([object isKindOfClass:NSClassFromString(@"NSBlock")]) {
                    SETextAttachmentDrawingBlock draw = attachment.object;
                    CGContextSaveGState(context);
                    draw(rect, context);
                    CGContextRestoreGState(context);
                }
            }
        }
    }];
    
    self.attachments = attachmentsToLeave;
}

- (void)highlightSelection
{
    SETextSelection *textSelection = self.textLayout.textSelection;
    NSRange selectedRange = textSelection.selectedRange;
    if (!textSelection || selectedRange.location == NSNotFound) {
        return;
    }
    
    NSInteger lineNumber = 0;
#if TARGET_OS_IPHONE
    CGRect startRect = CGRectZero;
    CGRect endRect = CGRectZero;
#endif
    
    CGFloat lineSpacing = self.lineSpacing;
    CGFloat previousLineOffset = 0.0f;
    
    for (SELineLayout *lineLayout in self.textLayout.lineLayouts) {
        NSRange stringRange = lineLayout.stringRange;
        
        NSRange intersectionRange = NSIntersectionRange(selectedRange, stringRange);
        if (intersectionRange.location == NSNotFound) {
            continue;
        }
        
        CGRect selectionRect = [lineLayout rectOfStringWithRange:selectedRange];
        if (CGRectIsEmpty(selectionRect)) {
            continue;
        }
        
        [self.selectedTextBackgroundColor set];
        
        selectionRect.origin.y -= lineSpacing;
        selectionRect.size.height += lineSpacing;
        if (selectionRect.origin.y < 0.0f) {
            selectionRect.size.height += selectionRect.origin.y;
            selectionRect.origin.y = 0.0f;
        }
        
        if (NSMaxRange(selectedRange) != NSMaxRange(stringRange) && NSMaxRange(intersectionRange) == NSMaxRange(stringRange)) {
            selectionRect.size.width = CGRectGetWidth(self.bounds) - CGRectGetMinX(selectionRect);
        }
        
        if (previousLineOffset > 0.0f) {
#if TARGET_OS_IPHONE
            CGFloat delta = CGRectGetMinY(selectionRect) - previousLineOffset;
            selectionRect.origin.y -= delta;
            selectionRect.size.height += delta;
#else
            CGFloat delta = CGRectGetMaxY(selectionRect) - previousLineOffset;
            selectionRect.origin.y -= delta;
            selectionRect.size.height += delta;
#endif
        }
        
        selectionRect = CGRectIntegral(selectionRect);
        
        UIRectFill(selectionRect);
        
#if TARGET_OS_IPHONE
        if (lineNumber == 0) {
            startRect = selectionRect;
            endRect = selectionRect;
        } else {
            endRect = selectionRect;
        }
#endif
        
#if TARGET_OS_IPHONE
        previousLineOffset = CGRectGetMaxY(selectionRect);
#else
        previousLineOffset = CGRectGetMinY(selectionRect);
#endif
        
        lineNumber++;
    }
    
#if TARGET_OS_IPHONE
    self.textSelectionView.startFrame = startRect;
    self.textSelectionView.endFrame = endRect;
#endif
}

- (void)highlightMarkedText
{
    NSRange markedTextRange = self.textLayout.markedTextRange;
    if (markedTextRange.location != NSNotFound && markedTextRange.length > 0) {
        for (SELineLayout *lineLayout in self.textLayout.lineLayouts) {
            CGRect markedRect = [lineLayout rectOfStringWithRange:markedTextRange];
            if (!CGRectIsEmpty(markedRect)) {
                [self.selectedTextBackgroundColor set];
                
                CGFloat lineSpacing = self.lineSpacing;
                markedRect.origin.y -= lineSpacing;
                markedRect.size.height += lineSpacing;
                
                NSRectFill(markedRect);
            }
        }
    }
}

- (void)__highlightLinks
{
    [self enumerateLinksUsingBlock:^(SELinkText *link, BOOL *stop) {
        for (SETextGeometry *geometry in link.geometries) {
            [self.linkHighlightColor set];
            CGRect linkRect = geometry.rect;
            
            NSBezierPath *path = [self bezierPathWithRoundedRect:linkRect cornerRadius:3.0f];
            [path fill];
        }
    }];
}

- (void)highlightClickedLink
{
    if (self.touchPhase & SETouchPhaseBegan || self.touchPhase & SETouchPhaseStationary) {
        SELinkText *link = [self linkAtPoint:self.mouseLocation];
        for (SETextGeometry *geometry in link.geometries) {
            [self.linkHighlightColor set];
            CGRect linkRect = geometry.rect;
            
            NSBezierPath *path = [self bezierPathWithRoundedRect:linkRect cornerRadius:3.0f];
            [path fill];
        }
    }
}

#if !TARGET_OS_IPHONE
- (void)highlightRolloveredLink
{
    if (self.touchPhase == SETouchPhaseNone) {
        SELinkText *link = [self linkAtPoint:self.mouseLocation];
        for (SETextGeometry *geometry in link.geometries) {
            [self.linkRolloverEffectColor set];
            CGRect linkRect = geometry.rect;
            linkRect.size.height = 1.0f;
            
            NSRectFill(linkRect);
        }
    }
}

- (void)updateCursorRectsInLinks
{
    [self discardCursorRects];
    
    [self addCursorRect:self.textLayout.frameRect cursor:[NSCursor IBeamCursor]];
    
    [self enumerateLinksUsingBlock:^(SELinkText *link, BOOL *stop) {
        for (SETextGeometry *geometry in link.geometries) {
            [self addCursorRect:geometry.rect cursor:[NSCursor pointingHandCursor]];
        }
    }];
}

- (void)updateTrackingAreasInLinks
{
    NSArray *trackingAreas = self.trackingAreas;
    for (NSTrackingArea *trackingArea in trackingAreas) {
        [self removeTrackingArea:trackingArea];
    }
    
    [self enumerateLinksUsingBlock:^(SELinkText *link, BOOL *stop) {
        for (SETextGeometry *geometry in link.geometries) {
            NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:geometry.rect
                                                                        options:NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow
                                                                          owner:self
                                                                       userInfo:nil];
            [self addTrackingArea:trackingArea];
        }
    }];
}
#endif

- (NSBezierPath *)bezierPathWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)radius
{
#if TARGET_OS_IPHONE
    return [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
#else
    return [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];
#endif
}

#pragma mark -

- (void)drawRect:(CGRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
#if TARGET_OS_IPHONE
    CGContextRef context = UIGraphicsGetCurrentContext();
#else
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
#endif
    [self updateLayout];
    
    [self highlightSelection];
    
    if (self.isEditing) {
        [self highlightMarkedText];
    }
    
    [self highlightClickedLink];
    
#if TARGET_OS_IPHONE
    [self drawTextDecorations];
#endif
    
    [self drawTextAttachmentsInContext:context];
    
#if TARGET_OS_IPHONE
    [self resetSelectionGrabber];
#else
    [self highlightRolloveredLink];
    
    [self updateCursorRectsInLinks];
    [self updateTrackingAreasInLinks];
#endif
    
    [self.textLayout drawInContext:context];
}

#pragma mark - Touch and Hold on Link

- (void)startLongPressTimer
{
    [self stopLongPressTimer];
    
    NSTimer *holdTimer = [NSTimer scheduledTimerWithTimeInterval:self.minimumLongPressDuration
                                                          target:self
                                                        selector:@selector(handleLongPress:)
                                                        userInfo:nil
                                                         repeats:NO];
    self.longPressTimer = holdTimer;
}

- (void)stopLongPressTimer
{
    if (self.longPressTimer && [self.longPressTimer isValid]) {
        [self.longPressTimer invalidate];
    }
    
    self.longPressTimer = nil;
}

- (void)handleLongPress:(NSTimer *)timer
{
    [self stopLongPressTimer];
    
    if ([self containsPointInTextFrame:self.mouseLocation]) {
        SELinkText *link = [self linkAtPoint:self.mouseLocation];
        if (link) {
            [self longPressedOnLink:link];
            
#if TARGET_OS_IPHONE
            [self clearSelection];
            [self hideEditingMenu];
#endif
            
            self.longPressing = YES;
        }
    }
}

#pragma mark - iOS touch events
#if TARGET_OS_IPHONE

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.isHidden || self.userInteractionEnabled == NO || self.alpha < 0.01f) {
        return [super hitTest:point withEvent:event];
    }
    
    if (self.selectable || self.editable) {
        return [super hitTest:point withEvent:event];
    }
    
    SELinkText *link = [self linkAtPoint:point];
    if (link) {
        return [super hitTest:point withEvent:event];
    }
    
    return nil;
}

- (void)moveMagnifierCaretToPoint:(CGPoint)point
{
    if (!self.magnifierCaret.superview) {
        [self.magnifierCaret showInView:self.window atPoint:[self convertPoint:point toView:nil]];
    }
    [self.magnifierCaret moveToPoint:[self convertPoint:point toView:nil]];
}

- (void)hideMagnifierCaret
{
    [self.magnifierCaret hide];
}

- (void)moveMagnifierRangedToPoint:(CGPoint)point
{
    if (!self.magnifierRanged.superview) {
        [self.magnifierRanged showInView:self.window atPoint:[self convertPoint:point toView:nil]];
    }
    [self.magnifierRanged moveToPoint:[self convertPoint:point toView:nil]];
}

- (void)hideMagnifierRanged
{
    [self.magnifierRanged hide];
}

- (void)resetSelectionGrabber
{
    if (!self.selectable) {
        [self hideTextSelectionView];
        return;
    }
    
    if (self.touchPhase & SETouchPhaseTouching) {
        [self hideTextSelectionView];
        return;
    }
    
    SETextLayout *textLayout = self.textLayout;
    SETextSelection *textSelection = textLayout.textSelection;
    if (!textSelection || textSelection.selectedRange.length == 0) {
        [self hideTextSelectionView];
        return;
    }
    
    [self.textSelectionView update];
    
    [self showTextSelectionView];
}

- (void)showTextSelectionView
{
    [self.textSelectionView showControls];
}

- (void)hideTextSelectionView
{
    [self.textSelectionView hideControls];
}

- (void)selectionGestureStateChanged:(UILongPressGestureRecognizer *)gestureRecognizer
{
    self.mouseLocation = [gestureRecognizer locationInView:self];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan ||
        gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.touchPhase = SETouchPhaseMoved;
        
        [self moveMagnifierCaretToPoint:self.mouseLocation];
        
        if (self.isEditable) {
            if (self.isEditing) {
                [self updateCaretPositionToPoint:self.mouseLocation];
            } else {
                [self beginEditing];
            }
            
            return;
        } else {
            [self.textLayout setSelectionWithPoint:self.mouseLocation];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
          gestureRecognizer.state == UIGestureRecognizerStateCancelled ||
          gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        self.touchPhase = SETouchPhaseNone;
        
        [self hideMagnifierCaret];
        
        [self finishSelecting];
        
        if (self.isEditing && self.textLayout.markedTextRange.location == NSNotFound) {
            [self showEditingMenu];
        }
    }
    
    if (self.isEditing) {
        [self updateCaretPositionToPoint:self.mouseLocation];
        return;
    }
    
    [self selectionChanged];
}

- (void)grabberMoved:(UIPanGestureRecognizer *)gestureRecognizer
{
    [self.inputDelegate selectionWillChange:self];
    
    SETextSelection *textSelection = self.textLayout.textSelection;
    if (!self.selectable || !textSelection) {
        return;
    }
    
    self.touchPhase = SETouchPhaseNone;
    self.mouseLocation = [gestureRecognizer locationInView:self];
    
    SESelectionGrabber *startGrabber = self.textSelectionView.startGrabber;
    SESelectionGrabber *endGrabber = self.textSelectionView.endGrabber;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan ||
        gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (gestureRecognizer == self.textSelectionView.startGrabberGestureRecognizer) {
            self.textSelectionView.startGrabber.dragging = YES;
            
            [self.textLayout setSelectionStartWithFirstPoint:self.mouseLocation];
            [self moveMagnifierRangedToPoint:startGrabber.center];
        } else {
            [self.textLayout setSelectionEndWithPoint:self.mouseLocation];
            [self moveMagnifierRangedToPoint:endGrabber.center];
        }
        
        [self hideEditingMenu];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
               gestureRecognizer.state == UIGestureRecognizerStateCancelled ||
               gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        if (gestureRecognizer == self.textSelectionView.startGrabberGestureRecognizer) {
            startGrabber.dragging = NO;
        } else {
            endGrabber.dragging = NO;
        }
        
        [self hideMagnifierRanged];
        
        if (self.textLayout.textSelection) {
            [self finishSelecting];
        }
        
        if (self.isEditing && self.selectedRange.length > 0) {
            [self showEditingMenu];
        }
    }
    
    [self selectionChanged];
    
    [self.inputDelegate selectionDidChange:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self startLongPressTimer];
    
    UITouch *touch = touches.anyObject;
    self.mouseLocation = [touch locationInView:self];
    self.touchPhase = SETouchPhaseBegan;
    
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self stopLongPressTimer];
    
    if (self.textSelectionView.selectionGestureRecognizer.state == UIGestureRecognizerStateBegan ||
        self.textSelectionView.selectionGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.touchPhase = SETouchPhaseMoved;
    } else {
        self.touchPhase = SETouchPhaseCancelled;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self stopLongPressTimer];
    
    UITouch *touch = touches.anyObject;
    self.mouseLocation = [touch locationInView:self];
    
    self.touchPhase = SETouchPhaseEnded;
    self.clickPoint = CGPointZero;
    
    if (self.longPressing) {
        self.longPressing = NO;
    } else {
        if (self.isEditable) {
            if (self.isEditing) {
                if ([self containsPointInSelection:self.mouseLocation]) {
                    [self hideEditingMenu];
                    [self showEditingMenu];
                } else {
                    [self hideEditingMenu];
                    [self updateCaretPositionToPoint:self.mouseLocation];
                }
            } else {
                if ([self containsPointInTextFrame:self.mouseLocation]) {
                    SELinkText *link = [self linkAtPoint:self.mouseLocation];
                    if (link) {
                        [self clickedOnLink:link];
                        
                        [self clearSelection];
                        [self hideEditingMenu];
                        
                        [self setNeedsDisplay];
                        return;
                    }
                }
                
                [self beginEditing];
            }
            
            [self setNeedsDisplay];
            return;
        }
        
        if ([self containsPointInSelection:self.mouseLocation]) {
            [self hideEditingMenu];
            [self showEditingMenu];
        } else {
            [self clearSelection];
            [self hideEditingMenu];
        }
        
        if ([self containsPointInTextFrame:self.mouseLocation]) {
            SELinkText *link = [self linkAtPoint:self.mouseLocation];
            if (link) {
                [self clickedOnLink:link];
                
                [self clearSelection];
                [self hideEditingMenu];
            }
        }
        
    }
    
    [self setNeedsDisplay];
}

#pragma mark -

- (void)beginEditing
{
    if (!self.isEditing && !self.isFirstResponder) {
        BOOL shouldBeginEditing = YES;
        if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
            shouldBeginEditing = [self.delegate textViewShouldBeginEditing:self];
        }
        if (self.isEditable && shouldBeginEditing) {
            self.editing = YES;
            
            if ([self becomeFirstResponder]) {
                [self updateCaretPositionToPoint:self.mouseLocation];
                
                if ([self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
                    [self.delegate textViewDidBeginEditing:self];
                }
            }
        }
    }
}

- (void)updateCaretPosition
{
    SETextLayout *textLayout = self.textLayout;
    SETextSelection *textSelection = textLayout.textSelection;
    if (self.isEditing && (!textSelection || textSelection.selectedRange.length == 0)) {
        self.caretView.hidden = NO;
        [self.caretView delayBlink];
    } else {
        self.caretView.hidden = YES;
    }
    
    NSRange selectedRange = textSelection.selectedRange;
    self.caretView.frame = [self caretRectForPosition:[SETextPosition positionWithIndex:NSMaxRange(selectedRange)]];
}

- (void)updateCaretPositionToPoint:(CGPoint)point
{
    if (!self.textLayout.textSelection) {
        self.textLayout.textSelection = [[SETextSelection alloc] init];
    }
    
    SETextPosition *position = (SETextPosition *)[self closestPositionToPoint:point];
    NSUInteger index = position.index;
    if (index == NSNotFound) {
        index = self.text.length;
    }
    if (self.text.length == 0) {
        index = 0;
    }
    
    self.caretView.frame = [self caretRectForPosition:[SETextPosition positionWithIndex:index]];
    
    [self.inputDelegate selectionWillChange:self];
    
    self.textLayout.markedTextRange = NSMakeRange(NSNotFound, 0);
    self.textLayout.textSelection.selectedRange = NSMakeRange(index, 0);
    [self selectionChanged];
    
    [self.inputDelegate selectionDidChange:self];
}

- (void)showEditingMenu
{
    if (!self.isFirstResponder && !self.textSelectionView.isFirstResponder) {
        [self.textSelectionView becomeFirstResponder];
    }
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    menuController.arrowDirection = UIMenuControllerArrowDefault;
    
    CGRect targetRect;
    if (self.selectedRange.length == 0) {
        targetRect = [self caretRectForPosition:[SETextPosition positionWithIndex:self.selectedRange.location]];
    } else {
        targetRect = [self editingMenuRectForSelection];
    }
    
    UIView *firstResponderView = self.isFirstResponder ? self : self.textSelectionView;
    
    [menuController setTargetRect:targetRect inView:firstResponderView];
    [menuController setMenuVisible:YES animated:YES];
}

- (void)hideEditingMenu
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuVisible:NO animated:YES];
}

- (CGRect)editingMenuRectForSelection
{
    SETextSelection *textSelection = self.textLayout.textSelection;
    CGRect topRect = CGRectNull;
    CGFloat minX = CGFLOAT_MAX;
    CGFloat maxX = CGFLOAT_MIN;
    
    for (SELineLayout *lineLayout in self.textLayout.lineLayouts) {
        CGRect selectionRect = [lineLayout rectOfStringWithRange:textSelection.selectedRange];
        if (!CGRectIsEmpty(selectionRect)) {
            CGFloat lineSpacing = self.lineSpacing;
            selectionRect.origin.y -= lineSpacing;
            selectionRect.size.height += lineSpacing;
            
            if (CGRectIsNull(topRect)) {
                topRect = selectionRect;
            }
            
            minX = MIN(CGRectGetMinX(selectionRect), minX);
            maxX = MAX(CGRectGetMaxX(selectionRect), maxX);
            
            topRect.origin.x = minX;
            topRect.size.width = maxX - minX;
        }
    }
    
    return topRect;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(cut:) && self.selectedText.length > 0 && self.editable) {
        return YES;
    }
    if (action == @selector(copy:) && self.selectedText.length > 0) {
        return YES;
    }
    if (action == @selector(paste:) && self.isEditing && [[UIPasteboard generalPasteboard] string]) {
        return YES;
    }
    if (action == @selector(select:) && self.text.length > 0 && self.selectedText.length == 0) {
        return YES;
    }
    if (action == @selector(selectAll:) && self.text.length > 0 && self.selectedText.length < self.text.length) {
        return YES;
    }
    
    return NO;
}

- (BOOL)canBecomeFirstResponder
{
    return self.isEditable && self.isEditing;
}

- (BOOL)becomeFirstResponder
{
    if (!self.isFirstResponder) {
        if (self.isEditable) {
            [self beginEditing];
        }
    }
    
    return [super becomeFirstResponder];
}

#else
#pragma mark - OS X mouse events

- (CGPoint)mouseLocationOnEvent:(NSEvent *)theEvent
{
    CGPoint locationInWindow = [theEvent locationInWindow];
    CGPoint location = [self convertPoint:locationInWindow fromView:nil];
    
    return location;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [self startLongPressTimer];
    
    self.mouseLocation = [self mouseLocationOnEvent:theEvent];
    
    if (theEvent.clickCount == 2) {
        self.touchPhase = SETouchPhaseMoved;
        [self.textLayout setSelectionWithPoint:self.mouseLocation];
    } else if ([self containsPointInTextFrame:self.mouseLocation]) {
        self.touchPhase = SETouchPhaseBegan;
        [self.textLayout setSelectionStartWithPoint:self.mouseLocation];
    }
    
    [self selectionChanged];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    self.mouseLocation = [self mouseLocationOnEvent:theEvent];
    
    self.touchPhase = SETouchPhaseMoved;
    
    [self.textLayout setSelectionEndWithClosestPoint:self.mouseLocation];
    
    [self selectionChanged];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [self stopLongPressTimer];
    
    self.mouseLocation = [self mouseLocationOnEvent:theEvent];
    self.clickPoint = CGPointZero;
    
    self.touchPhase = SETouchPhaseEnded;
    
    if (self.longPressing) {
        self.longPressing = NO;
    } else {
        if ([self containsPointInTextFrame:self.mouseLocation]) {
            SELinkText *link = [self linkAtPoint:self.mouseLocation];
            if (link) {
                [self clickedOnLink:link];
            }
        }
    }
    
    [self setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    self.mouseLocation = [self mouseLocationOnEvent:theEvent];
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    self.mouseLocation = [self mouseLocationOnEvent:theEvent];
    [self setNeedsDisplay:YES];
}

- (NSMenu *)menuForEvent:(NSEvent *)event
{
    if (self.textLayout.textSelection) {
        NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
        [menu addItemWithTitle:NSLocalizedString(@"Cut", nil) action:@selector(cut:) keyEquivalent:@""];
        [menu addItemWithTitle:NSLocalizedString(@"Copy", nil) action:@selector(copy:) keyEquivalent:@""];
        [menu addItemWithTitle:NSLocalizedString(@"Paste", nil) action:@selector(paste:) keyEquivalent:@""];
        [menu addItem:[NSMenuItem separatorItem]];
        [menu addItemWithTitle:NSLocalizedString(@"Select All", nil) action:@selector(selectAll:) keyEquivalent:@""];
        
        return [[[NSTextView alloc] init] menuForEvent:event];
    }
    
    return nil;
}

- (void)quickLookWithEvent:(NSEvent *)event
{
    if (!self.textLayout.textSelection) {
        self.mouseLocation = [self mouseLocationOnEvent:event];
        [self.textLayout setSelectionWithPoint:self.mouseLocation];
    }
    
    CGRect rect = [self rectOfFirstLineInSelectionRect];
    [self showDefinitionForAttributedString:self.selectedAttributedText atPoint:rect.origin];
}

- (CGRect)rectOfFirstLineInSelectionRect
{
    SETextSelection *textSelection = self.textLayout.textSelection;
    if (!textSelection) {
        return CGRectZero;
    }
    
    for (SELineLayout *lineLayout in self.textLayout.lineLayouts) {
        CGRect selectionRect = [lineLayout rectOfStringWithRange:textSelection.selectedRange];
        if (!CGRectIsEmpty(selectionRect)) {
            return selectionRect;
        }
    }
    
    return CGRectZero;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    if (menuItem.action == @selector(copy:)) {
        return self.selectedRange.length > 0;
    }
    if (menuItem.action == @selector(cut:) ||
        menuItem.action == @selector(paste:) ||
        menuItem.action == @selector(delete:)) {
        return NO;
    }
    
    return YES;
}

- (BOOL)performKeyEquivalent:(NSEvent *)theEvent
{
    if (self.textLayout.textSelection) {
        if ((theEvent.modifierFlags & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask) {
            if ([theEvent.characters isEqualToString:@"c"]) {
                [self copy:nil];
                return YES;
            }
            if ([theEvent.characters isEqualToString:@"a"]) {
                [self selectAll:nil];
                return YES;
            }
        }
    }
    
    return [super performKeyEquivalent:theEvent];
}

#endif
#pragma mark - Common

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    if (!self.originalAttributedTextWhenHighlighting) {
        self.originalAttributedTextWhenHighlighting = self.attributedText;
    }
    
    if (self.highlighted) {
        CGColorRef color = self.highlighted ? self.highlightedTextColor.CGColor : self.textColor.CGColor;
        [self setAttributes:@{(id)kCTForegroundColorAttributeName: (__bridge id)color}];
    } else {
        self.attributedText = self.originalAttributedTextWhenHighlighting;
        self.originalAttributedTextWhenHighlighting = nil;
    }
}

- (void)cut:(id)sender
{
#if TARGET_OS_IPHONE
    if (self.selectedText.length > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.selectedText;
        self.storedAttributedText = self.selectedAttributedText;
        [self insertText:@""];
    }
#else
    [self copy:nil];
#endif
}

- (void)copy:(id)sender
{
#if TARGET_OS_IPHONE
    if (self.selectedText.length > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.selectedText;
        self.storedAttributedText = self.selectedAttributedText;
    }
#else
    if (self.selectedAttributedText.length > 0) {
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        [pasteboard clearContents];
        [pasteboard writeObjects:@[self.selectedText]];
    }
#endif
}

- (void)paste:(id)sender
{
#if TARGET_OS_IPHONE
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSAttributedString *storedAttributedText = self.storedAttributedText;
    if (storedAttributedText && [pasteboard.string isEqualToString:[storedAttributedText string]]) {
        [self insertAttributedText:storedAttributedText];
    }
    else {
        [self insertText:pasteboard.string];
    }
#endif
}

- (void)select:(id)sender
{
    [self.textLayout setSelectionWithPoint:self.mouseLocation];
    
    [self selectionChanged];
    [self finishSelecting];
    
#if TARGET_OS_IPHONE
    if (self.isEditing) {
        [self showEditingMenu];
    }
#endif
    
    [self setNeedsDisplayInRect:self.bounds];
}

- (void)selectAll:(id)sender
{
    [self.textLayout selectAll];
    
    [self selectionChanged];
    [self finishSelecting];
    
#if TARGET_OS_IPHONE
    if (self.isEditing) {
        [self showEditingMenu];
    }
#endif
    
    [self setNeedsDisplayInRect:self.bounds];
}

- (BOOL)canResignFirstResponder
{
    BOOL shouldEndEditing = YES;
    if ([self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        shouldEndEditing = [self.delegate textViewShouldEndEditing:self];
    }
    
    return shouldEndEditing;
}

- (BOOL)resignFirstResponder
{
    if (self.isEditing) {
        self.editing = NO;
        
        SETextSelection *textSelection = self.textLayout.textSelection;
        NSRange selectedRange = textSelection.selectedRange;
        textSelection.selectedRange = NSMakeRange(NSMaxRange(selectedRange), 0);
        
        if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
            [self.delegate textViewDidEndEditing:self];
        }
    } else {
#if TARGET_OS_IPHONE
        if (self.isFirstResponder) {
#else
        if (self == self.window.firstResponder) {
#endif
            [self clearSelection];
        }
    }
    
    [self setNeedsDisplayInRect:self.bounds];
    
    return [super resignFirstResponder];
}

#if TARGET_OS_IPHONE
#pragma mark UITextInput methods

- (NSString *)textInRange:(UITextRange *)range
{
    SETextRange *r = (SETextRange *)range;
    if (r.range.location == NSNotFound) {
        return nil;
    }
    if (self.text.length < NSMaxRange(r.range)) {
        return nil;
    }
    
    NSString *text = [self.text substringWithRange:r.range];
    
    return text;
}

- (void)replaceRange:(UITextRange *)range withText:(NSString *)text
{
    SETextRange *r = (SETextRange *)range;
    
    NSRange selectedRange = self.selectedRange;
    if (r.range.location + r.range.length <= selectedRange.location) {
        selectedRange.location -= r.range.length - text.length;
    } else {
        // Need to also deal with overlapping ranges.
    }
    
    NSMutableAttributedString *editingAttributedText = self.editingAttributedText;
    [editingAttributedText replaceCharactersInRange:r.range withString:text];
    
    self.attributedText = editingAttributedText;
    self.textLayout.textSelection.selectedRange = selectedRange;
    
    [self selectionChanged];
}

- (UITextRange *)selectedTextRange
{
    SETextSelection *textSelection = self.textLayout.textSelection;
    if (!textSelection) {
        return nil;
    }
    
    SETextRange *textRange = [SETextRange rangeWithNSRange:textSelection.selectedRange];
    return textRange;
}

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange
{
    SETextRange *textRange = (SETextRange *)selectedTextRange;
    self.textLayout.textSelection.selectedRange = textRange.range;
    
    [self selectionChanged];
}

- (UITextRange *)markedTextRange
{
    if (self.textLayout.markedTextRange.location == NSNotFound) {
        return nil;
    }
    
    return [SETextRange rangeWithNSRange:self.textLayout.markedTextRange];
}

//- (void)setMarkedTextStyle:(NSDictionary *)markedTextStyle
//{
//    NSLog(@"%s", __func__);
//}
//
//- (NSDictionary *)markedTextStyle
//{
//    NSLog(@"%s", __func__);
//    return nil;
//}

- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange
{
//    if (markedText.length == 0 && NSMaxRange(selectedRange) == 0) {
//        return;
//    }
    if (selectedRange.location == NSNotFound) {
        return;
    }
    
    NSRange selectedNSRange = self.selectedRange;
    NSRange markedTextRange = self.textLayout.markedTextRange;
    
    NSMutableAttributedString *editingAttributedText = self.editingAttributedText;
    NSRange replaceRange;
    
    if (markedTextRange.location != NSNotFound) {
        if (!markedText) {
            markedText = @"";
        }
        
        replaceRange = markedTextRange;
        
        markedTextRange.length = markedText.length;
    } else if (selectedNSRange.length > 0) {
        replaceRange = selectedNSRange;
        
        markedTextRange.location = selectedNSRange.location;
        markedTextRange.length = markedText.length;
    } else {
        replaceRange = selectedNSRange;
        
        markedTextRange.location = selectedNSRange.location;
        markedTextRange.length = markedText.length;
    }
    
    [self replaceCharactersInRange:replaceRange withString:markedText forAttributedString:editingAttributedText];
    
    selectedNSRange = NSMakeRange(markedTextRange.location + selectedRange.location, selectedRange.length);
    
    if (markedTextRange.length == 0) {
        markedTextRange.location = NSNotFound;
    }
    
    self.attributedText = editingAttributedText;
    self.textLayout.markedTextRange = markedTextRange;
    self.textLayout.textSelection.selectedRange = selectedNSRange;
    
    [self updateLayout];
    
    [self selectionChanged];
    [self textChanged];
}

- (void)unmarkText
{
    NSRange markedTextRange = self.textLayout.markedTextRange;
    
    if (markedTextRange.location == NSNotFound) {
        return;
    }
    
    markedTextRange.location = NSNotFound;
    self.textLayout.markedTextRange = markedTextRange;
    
    [self updateLayout];
    [self selectionChanged];
}

- (UITextPosition *)beginningOfDocument
{
    SETextPosition *position = [SETextPosition positionWithIndex:0];
    return position;
}

- (UITextPosition *)endOfDocument
{
    SETextPosition *position = [SETextPosition positionWithIndex:self.text.length];
    return position;
}

- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition
{
    SETextPosition *from = (SETextPosition *)fromPosition;
    SETextPosition *to = (SETextPosition *)toPosition;
    if (to.index < from.index) {
        SETextPosition *temp = from;
        from = to;
        to = temp;
    }
    
    NSUInteger location = MIN(from.index, to.index);
    NSUInteger length = ABS(to.index - from.index);
    
    return [SETextRange rangeWithNSRange:NSMakeRange(location, length)];
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset
{
    SETextPosition *pos = (SETextPosition *)position;
    NSInteger end = pos.index + offset;
    if (end > self.text.length || end < 0) {
        return nil;
    }
    
    return [SETextPosition positionWithIndex:end];
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset
{
    SETextPosition *pos = (SETextPosition *)position;
    NSInteger newPos = pos.index;
    
    switch (direction) {
        case UITextLayoutDirectionRight:
            newPos += offset;
            break;
        case UITextLayoutDirectionLeft:
            newPos -= offset;
            break;
        case UITextLayoutDirectionUp:
        case UITextLayoutDirectionDown:
            break;
    }
    
    if (newPos < 0) {
        newPos = 0;
    }
    
    if (newPos > _text.length) {
        newPos = _text.length;
    }
    
    return [SETextPosition positionWithIndex:newPos];
}

- (NSComparisonResult)comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)other
{
    SETextPosition *pos = (SETextPosition *)position;
    SETextPosition *o = (SETextPosition *)other;
    
    if (pos.index == o.index) {
        return NSOrderedSame;
    } if (pos.index < o.index) {
        return NSOrderedAscending;
    } else {
        return NSOrderedDescending;
    }
}

- (NSInteger)offsetFromPosition:(UITextPosition *)from toPosition:(UITextPosition *)toPosition
{
    SETextPosition *f = (SETextPosition *)from;
    SETextPosition *t = (SETextPosition *)toPosition;
    return t.index - f.index;
}

- (id<UITextInputTokenizer>)tokenizer
{
    if (!_tokenizer) {
        _tokenizer = [[UITextInputStringTokenizer alloc] initWithTextInput:self];
    }
    
    return _tokenizer;
}

/* Layout questions. */
- (UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction
{
    SETextRange *r = (SETextRange *)range;
    NSInteger pos;
    
    switch (direction) {
        case UITextLayoutDirectionUp:
        case UITextLayoutDirectionLeft:
            pos = r.range.location;
            break;
        case UITextLayoutDirectionRight:
        case UITextLayoutDirectionDown:
            pos = r.range.location + r.range.length;
            break;
    }
    
    return [SETextPosition positionWithIndex:pos];
}

- (UITextRange *)characterRangeByExtendingPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction
{
    SETextPosition *pos = (SETextPosition *)position;
    NSRange result;
    
    switch (direction) {
        case UITextLayoutDirectionUp:
        case UITextLayoutDirectionLeft:
            result = NSMakeRange(pos.index - 1, 1);
            break;
        case UITextLayoutDirectionRight:
        case UITextLayoutDirectionDown:
            result = NSMakeRange(pos.index, 1);
            break;
    }
    
    return [SETextRange rangeWithNSRange:result];
}

/* Writing direction */
- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction
{
    return UITextWritingDirectionLeftToRight;
}

- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range
{
    // Not supported.
}

/* Geometry used to provide, for example, a correction rect. */
- (CGRect)firstRectForRange:(UITextRange *)range
{
    SETextRange *r = (SETextRange *)range;
    
    for (SELineLayout *lineLayout in self.textLayout.lineLayouts) {
        CGRect rect = [lineLayout rectOfStringWithRange:r.range];
        if (!CGRectIsEmpty(rect)) {
            CGFloat lineSpacing = self.lineSpacing;
            rect.origin.y -= lineSpacing;
            rect.size.height += lineSpacing;
            
            return rect;
        }
    }
    
    return CGRectNull;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    SETextPosition *pos = (SETextPosition *)position;
    NSUInteger index = pos.index;
    
    NSString *text = self.text;
    
    if (text.length == 0) {
        CGPoint origin = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds));
        UIFont *font = self.font ? self.font : [UIFont systemFontOfSize:[UIFont labelFontSize]];
        return CGRectMake(origin.x, origin.y, CGRectGetWidth(self.caretView.bounds), font.leading);
    }
    
    if (index >= text.length) {
        index = text.length;
    }
    
    NSString *lastCharacter = (index > 0) ? [text substringWithRange:NSMakeRange(index - 1, 1)] : @"";
    if (index == text.length && [lastCharacter isEqualToString:@"\n"]) {
        CGRect rect = [self.textLayout rectOfStringForLastLine];
        rect.origin.y = CGRectGetMaxY(rect);
        rect.size.width = CGRectGetWidth(self.caretView.bounds);
        return rect;
    }
    
    if (index < text.length) {
        unichar c = [text characterAtIndex:index];
        if (CFStringIsSurrogateLowCharacter(c)) {
            index++;
            if ((0xDDE6 <= c && c <= 0xDDFF) || c == 0x20E3) {
                index += 2;
            }
        }
    }
    
    CGRect rect;
    if (index > 0 && [lastCharacter isEqualToString:@"\n"]) {
        rect = [self.textLayout rectOfStringForIndex:index + 1];
    } else {
        rect = [self.textLayout rectOfStringForIndex:index];
        rect.origin.x += CGRectGetWidth(rect);
    }
    
    CGFloat lineSpacing = self.lineSpacing;
    rect.origin.x -= CGRectGetWidth(self.caretView.bounds);
    rect.origin.y -= lineSpacing;
    rect.size.width = CGRectGetWidth(self.caretView.bounds);
    rect.size.height += lineSpacing;
    
    if (CGRectGetMinX(rect) < 0.0f) {
        rect.origin.x = 0.0f;
    }
    
    return rect;
}

- (NSArray *)selectionRectsForRange:(UITextRange *)range
{
    // Not implemented yet.
    return nil;
}

/* Hit testing. */
- (UITextPosition *)closestPositionToPoint:(CGPoint)point
{
    CFIndex index = [self.textLayout stringIndexForClosestPosition:point];
    if (index == kCFNotFound) {
        return nil;
    }
    return [SETextPosition positionWithIndex:index];
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range
{
    CFIndex index = [self stringIndexAtPoint:point];
    if (index == kCFNotFound) {
        return nil;
    }
    
    SETextRange *r = (SETextRange *)range;
    if (index >= r.range.location && index <= r.range.location + r.range.length) {
        return [SETextPosition positionWithIndex:index];
    }
    
    return nil;
}

- (UITextRange *)characterRangeAtPoint:(CGPoint)point
{
    CFIndex index = [self stringIndexAtPoint:point];
    if (index == kCFNotFound) {
        return nil;
    }
    
    CFIndex length = 1;
    
    if (index < 0) {
        index = 0;
    }
    if (index > self.text.length) {
        index = self.text.length;
        length = 0;
    }
    
    return [SETextRange rangeWithNSRange:NSMakeRange(index, length)];
}

- (BOOL)shouldChangeTextInRange:(UITextRange *)range replacementText:(NSString *)text
{
    BOOL shouldChangeTextInRange = YES;
    SETextRange *r = (SETextRange *)range;
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        shouldChangeTextInRange = [self.delegate textView:self shouldChangeTextInRange:r.range replacementText:text];
    }
    
    return shouldChangeTextInRange;
}

//- (NSDictionary *)textStylingAtPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction
//{
//    SETextPosition *pos = (SETextPosition *)position;
//    return [self.attributedText attributesAtIndex:pos.index effectiveRange:NULL];
//}

//- (UITextPosition *)positionWithinRange:(UITextRange *)range atCharacterOffset:(NSInteger)offset
//{
//    // Not supported.
//    return nil;
//}
//
//- (NSInteger)characterOffsetOfPosition:(UITextPosition *)position withinRange:(UITextRange *)range
//{
//    // Not supported.
//    return 0;
//}

#pragma mark -
#pragma mark UIKeyInput methods

- (BOOL)hasText
{
    return self.text.length > 0;
}

- (void)insertText:(NSString *)text
{
    NSRange selectedNSRange = self.textLayout.textSelection.selectedRange;
    SETextRange *markedTextRange = (SETextRange *)self.markedTextRange;
    NSRange markedTextNSRange;
    if (markedTextRange) {
        markedTextNSRange = markedTextRange.range;
    } else {
        markedTextNSRange = NSMakeRange(NSNotFound, 0);
    }
    
    NSMutableAttributedString *editingAttributedText = self.editingAttributedText;
    NSRange replaceRange;
    
    if (markedTextRange && markedTextNSRange.location != NSNotFound) {
        replaceRange = markedTextNSRange;
        
        selectedNSRange.location = markedTextNSRange.location + text.length;
        selectedNSRange.length = 0;
        
        markedTextNSRange = NSMakeRange(NSNotFound, 0);
    } else if (selectedNSRange.length > 0) {
        replaceRange = selectedNSRange;
        
        selectedNSRange.length = 0;
        selectedNSRange.location += text.length;
    } else {
        replaceRange = selectedNSRange;
        selectedNSRange.location += text.length;
    }
    
    [self replaceCharactersInRange:replaceRange withString:text forAttributedString:editingAttributedText];
    
    self.attributedText = editingAttributedText.copy;
    self.textLayout.markedTextRange = markedTextNSRange;
    self.textLayout.textSelection.selectedRange = selectedNSRange;
    
    [self updateLayout];
    
    [self selectionChanged];
    [self textChanged];
    
    [self hideEditingMenu];
}

- (void)deleteBackward
{
    if (self.text.length > 0) {
        NSRange selectedNSRange = self.textLayout.textSelection.selectedRange;
        SETextRange *markedTextRange = (SETextRange *)self.markedTextRange;
        NSRange markedTextNSRange;
        if (markedTextRange) {
            markedTextNSRange = markedTextRange.range;
        } else {
            markedTextNSRange = NSMakeRange(NSNotFound, 0);
        }
        
        NSMutableAttributedString *editingAttributedText = self.editingAttributedText;
        NSRange deleteRange = NSMakeRange(0, 0);
        
        if (markedTextRange && markedTextNSRange.location != NSNotFound) {
            deleteRange = markedTextNSRange;
            
            selectedNSRange.location = markedTextNSRange.location;
            selectedNSRange.length = 0;
            
            markedTextNSRange = NSMakeRange(NSNotFound, 0);
        } else if (selectedNSRange.length > 0) {
            unichar c = [editingAttributedText.string characterAtIndex:selectedNSRange.location];
            if (CFStringIsSurrogateLowCharacter(c)) {
                selectedNSRange.location -= 1;
                selectedNSRange.length += 1;
                if ((0xDDE6 <= c && c <= 0xDDFF) || c == 0x20E3) {
                    c = [editingAttributedText.string characterAtIndex:selectedNSRange.location];
                    if (c == 0xD83C) {
                        selectedNSRange.location -= 2;
                        selectedNSRange.length += 2;
                    }
                }
            } else if (CFStringIsSurrogateHighCharacter(c)) {
                if (c == 0xD83C) {
                    c = [editingAttributedText.string characterAtIndex:selectedNSRange.location + 1];
                    if ((0xDDE6 <= c && c <= 0xDDFF) || c == 0x20E3) {
                        selectedNSRange.location -= 2;
                        selectedNSRange.length += 2;
                    }
                }
            }
            
            deleteRange = selectedNSRange;
            selectedNSRange.length = 0;
        } else if (selectedNSRange.location > 0) {
            selectedNSRange.location -= 1;
            selectedNSRange.length = 1;
            
            unichar c = [editingAttributedText.string characterAtIndex:selectedNSRange.location];
            if (CFStringIsSurrogateLowCharacter(c)) {
                selectedNSRange.location -= 1;
                selectedNSRange.length += 1;
                if ((0xDDE6 <= c && c <= 0xDDFF) || c == 0x20E3) {
                    c = [editingAttributedText.string characterAtIndex:selectedNSRange.location];
                    if (c == 0xD83C) {
                        selectedNSRange.location -= 2;
                        selectedNSRange.length += 2;
                    }
                }
            } else if (CFStringIsSurrogateHighCharacter(c)) {
                if (c == 0xD83C) {
                    c = [editingAttributedText.string characterAtIndex:selectedNSRange.location + 1];
                    if ((0xDDE6 <= c && c <= 0xDDFF) || c == 0x20E3) {
                        selectedNSRange.location -= 2;
                        selectedNSRange.length += 2;
                    }
                }
            } else if (c == 0x20E3) {
                selectedNSRange.location -= 1;
                selectedNSRange.length += 1;
            }
            
            deleteRange = selectedNSRange;
            
            selectedNSRange.length = 0;
        }
        
        [editingAttributedText deleteCharactersInRange:deleteRange];
        
        self.attributedText = editingAttributedText.copy;
        self.textLayout.markedTextRange = markedTextNSRange;
        self.textLayout.textSelection.selectedRange = selectedNSRange;
    }
    
    [self updateLayout];
    
    [self selectionChanged];
    [self textChanged];
    
    [self hideEditingMenu];
}

#pragma mark -

- (void)insertAttributedText:(NSAttributedString *)attributedText
{
    NSRange selectedNSRange = self.textLayout.textSelection.selectedRange;
    SETextRange *markedTextRange = (SETextRange *)self.markedTextRange;
    NSRange markedTextNSRange;
    if (markedTextRange) {
        markedTextNSRange = markedTextRange.range;
    } else {
        markedTextNSRange = NSMakeRange(NSNotFound, 0);
    }
    
    NSMutableAttributedString *editingAttributedText = self.editingAttributedText;
    NSRange replaceRange;
    
    if (markedTextRange && markedTextNSRange.location != NSNotFound) {
        replaceRange = markedTextNSRange;
        
        selectedNSRange.location = markedTextNSRange.location + attributedText.length;
        selectedNSRange.length = 0;
        
        markedTextNSRange = NSMakeRange(NSNotFound, 0);
    } else if (selectedNSRange.length > 0) {
        replaceRange = selectedNSRange;
        
        selectedNSRange.length = 0;
        selectedNSRange.location += attributedText.length;
    } else {
        replaceRange = selectedNSRange;
        selectedNSRange.location += attributedText.length;
    }
    
    [editingAttributedText replaceCharactersInRange:replaceRange withAttributedString:attributedText];
    
    self.attributedText = editingAttributedText.copy;
    self.textLayout.markedTextRange = markedTextNSRange;
    self.textLayout.textSelection.selectedRange = selectedNSRange;
    
    [self updateLayout];
    
    [self selectionChanged];
    [self textChanged];
    
    [self hideEditingMenu];
}

- (void)insertObject:(id)object size:(CGSize)size;
{
    NSRange selectedNSRange = self.textLayout.textSelection.selectedRange;
    SETextRange *markedTextRange = (SETextRange *)self.markedTextRange;
    NSRange markedTextNSRange;
    if (markedTextRange) {
        markedTextNSRange = markedTextRange.range;
    } else {
        markedTextNSRange = NSMakeRange(NSNotFound, 0);
    }
    
    SETextAttachment *attachment = nil;
    NSUInteger location = 0;
    if (markedTextRange && markedTextNSRange.location != NSNotFound) {
        location = markedTextNSRange.location;
    } else {
        location = selectedNSRange.location;
    }
    
    NSString *replacementCharacter = OBJECT_REPLACEMENT_CHARACTER;
    attachment = [[SETextAttachment alloc] initWithObject:object size:size range:NSMakeRange(location, replacementCharacter.length)];
    [self.attachments addObject:attachment];
    
    [self insertText:replacementCharacter];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString forAttributedString:(NSMutableAttributedString *)attributedString
{
    if (!aString) {
        aString = @"";
    }
    
    id attribute = nil;
    NSUInteger location = range.location;
    NSUInteger index = location;
    if (location > attributedString.length) {
        index = attributedString.length;
    }
    if (index > 0) {
        attribute = [attributedString attribute:(id)kCTRunDelegateAttributeName atIndex:index - 1 effectiveRange:nil];
    } else if (attributedString.length > 0) {
        attribute = [attributedString attribute:(id)kCTRunDelegateAttributeName atIndex:0 effectiveRange:nil];
    }
    if (NSMaxRange(range) > attributedString.length) {
        return;
    }
    
    if (attribute) {
        [attributedString replaceCharactersInRange:range withAttributedString:[[NSAttributedString alloc] initWithString:aString]];
    } else {
        [attributedString replaceCharactersInRange:range withString:aString];
    }
}
#endif

@end
