//
//  SETextInput.h
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/09/22.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SETextRange : UITextRange

@property (nonatomic) NSRange range;

+ (SETextRange *)rangeWithNSRange:(NSRange)theRange;

@end

@interface SETextPosition : UITextPosition

@property (nonatomic, weak) id delegate;
@property (nonatomic) NSUInteger index;

+ (SETextPosition *)positionWithIndex:(NSUInteger)index;

@end
#endif
