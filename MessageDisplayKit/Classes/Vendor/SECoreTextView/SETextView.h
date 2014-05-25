//
//  SETextView.h
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/20.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "SELinkText.h"
#import "SETextAttachment.h"
#import "SECompatibility.h"
#import "NSMutableAttributedString+Helper.h"

typedef void(^SETextAttachmentDrawingBlock)(CGRect rect, CGContextRef context);

typedef NS_ENUM(NSUInteger, SETextAttachmentDrawingOptions) {
    SETextAttachmentDrawingOptionNone = 0,
    SETextAttachmentDrawingOptionNewLine  = 1 << 0
};

@protocol SETextViewDelegate;

@class SELinkText;

#if TARGET_OS_IPHONE
@interface SETextView : UIView <UITextInput, UITextInputTraits>
#else
@interface SETextView : NSView
#endif

@property (nonatomic, weak) IBOutlet id<SETextViewDelegate> delegate;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSAttributedString *attributedText;

@property (nonatomic) NSFont *font;
@property (nonatomic) NSColor *textColor;
@property (nonatomic) NSColor *highlightedTextColor;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) NSLineBreakMode lineBreakMode;
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) CGFloat lineHeight;
@property (nonatomic) CGFloat paragraphSpacing;

@property (nonatomic) NSColor *selectedTextBackgroundColor;
@property (nonatomic) NSColor *linkHighlightColor;
@property (nonatomic) NSColor *linkRolloverEffectColor;

@property (nonatomic, readonly) CGRect layoutFrame;

@property (nonatomic, getter = isHighlighted) BOOL highlighted;
@property (nonatomic, getter = isSelectable) BOOL selectable;
#if TARGET_OS_IPHONE
@property (nonatomic) BOOL showsEditingMenuAutomatically;
#endif

#if TARGET_OS_IPHONE
@property (nonatomic) NSRange selectedRange;
#else
@property (nonatomic, readonly) NSRange selectedRange;
#endif
@property (nonatomic, readonly) NSString *selectedText;
@property (nonatomic, readonly) NSAttributedString *selectedAttributedText;

@property (nonatomic) NSTimeInterval minimumLongPressDuration;

@property (nonatomic, getter = isEditable) BOOL editable;
@property (nonatomic, readonly, getter = isEditing) BOOL editing;
@property (nonatomic, readonly) CGRect caretRect;

@property (readwrite) UIView *inputView;
@property (readwrite) UIView *inputAccessoryView;

#if TARGET_OS_IPHONE
@property (nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic) UITextAutocorrectionType autocorrectionType;
@property (nonatomic) UITextSpellCheckingType spellCheckingType;
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic) UIKeyboardAppearance keyboardAppearance;
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic) BOOL enablesReturnKeyAutomatically;
@property (nonatomic, getter = isSecureTextEntry) BOOL secureTextEntry;
#endif

- (id)initWithFrame:(CGRect)frame;

+ (CGRect)frameRectWithAttributtedString:(NSAttributedString *)attributedString
                          constraintSize:(CGSize)constraintSize;
+ (CGRect)frameRectWithAttributtedString:(NSAttributedString *)attributedString
                          constraintSize:(CGSize)constraintSize
                             lineSpacing:(CGFloat)lineSpacing;
+ (CGRect)frameRectWithAttributtedString:(NSAttributedString *)attributedString
                          constraintSize:(CGSize)constraintSize
                             lineSpacing:(CGFloat)lineSpacing
                                    font:(NSFont *)font;
+ (CGRect)frameRectWithAttributtedString:(NSAttributedString *)attributedString
                          constraintSize:(CGSize)constraintSize
                             lineSpacing:(CGFloat)lineSpacing
                        paragraphSpacing:(CGFloat)paragraphSpacing
                                    font:(NSFont *)font;

- (void)addObject:(id)object size:(CGSize)size atIndex:(NSInteger)index;
- (void)addObject:(id)object size:(CGSize)size replaceRange:(NSRange)range;
#if TARGET_OS_IPHONE
- (void)insertAttributedText:(NSAttributedString *)attributedText;
- (void)insertObject:(id)object size:(CGSize)size;
#endif

- (void)clearSelection;

@end

@protocol SETextViewDelegate <NSObject>

@optional
- (BOOL)textViewShouldBeginEditing:(SETextView *)textView;
- (BOOL)textViewShouldEndEditing:(SETextView *)textView;

- (void)textViewDidBeginEditing:(SETextView *)textView;
- (void)textViewDidEndEditing:(SETextView *)textView;

- (BOOL)textView:(SETextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(SETextView *)textView;

- (void)textViewDidChangeSelection:(SETextView *)textView;
- (void)textViewDidEndSelecting:(SETextView *)textView;

//- (BOOL)textView:(SETextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange;
//- (BOOL)textView:(SETextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange;

- (BOOL)textView:(SETextView *)textView clickedOnLink:(SELinkText *)link atIndex:(NSUInteger)charIndex;
- (BOOL)textView:(SETextView *)textView longPressedOnLink:(SELinkText *)link atIndex:(NSUInteger)charIndex;

@end
