//
//  SETextEditingCaret.h
//  CoreTextEditor
//
//  Created by kishikawa katsumi on 2013/09/24.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

@interface SETextEditingCaret : UIView

- (void)delayBlink;
- (void)stopBlink;

@end
#endif
