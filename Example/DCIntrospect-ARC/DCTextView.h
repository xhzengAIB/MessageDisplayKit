//
//  DCTextView.h
//  Pods
//
//  Created by Mikkel Selsøe Sørensen on 29/10/13.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FrameManipulation) {
    FrameManipulationNudgeLeft,
    FrameManipulationNudgeRight,
    FrameManipulationNudgeUp,
    FrameManipulationNudgeDown,
    FrameManipulationCenterInSuperview,
    FrameManipulationIncreaseWidth,
    FrameManipulationDecreaseWidth,
    FrameManipulationIncreaseHeight,
    FrameManipulationDecreaseHeight,
    FrameManipulationIncreaseAlpha,
    FrameManipulationDecreaseAlpha,
};

@protocol DCTextViewDelegate <UITextViewDelegate>

- (void) disableForPeriod;
- (void) invokeIntrospector;
- (void) toggleHelp;
- (void) toggleOutlines;
- (void) toggleNonOpaqueViews;
- (void) toggleAmbiguousLayouts;
- (void) toggleRedrawFlashing;
- (void) toggleShowCoordinates;
- (void) logPropertiesForCurrentView;
- (void) logAccessabilityPropertiesForCurrentView;
- (void) logRecursiveDescriptionForCurrentView;
- (void) exerciseAmbiguityInLayoutForCurrentView;
- (void) logHorizontalConstraintsForCurrentView;
- (void) logVerticalConstraintsForCurrentView;
- (void) forceSetNeedsDisplay;
- (void) forceSetNeedsLayout;
- (void) forceReloadOfView;
- (void) moveUpInViewHierarchy;
- (void) moveBackInViewHierarchy;
- (void) moveDownToFirstSubview;
- (void) moveToNextSiblingView;
- (void) moveToPrevSiblingView;
- (void) logCodeForCurrentViewChanges;
- (void) manipulateFrame: (FrameManipulation) manipulation withBigStep: (BOOL) bigstep;
- (void) enterGDB;

@end

@interface DCTextView : UITextView

@property (nonatomic, weak) id<DCTextViewDelegate> keyboardInputDelegate;

@end
