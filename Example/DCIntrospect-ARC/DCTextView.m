//
//  DCTextView.m
//  Pods
//
//  Created by Mikkel Selsøe Sørensen on 29/10/13.
//
//

#import "DCTextView.h"
#import "DCIntrospectSettings.h"

@implementation DCTextView

#ifdef __IPHONE_7_0

- (NSArray *)keyCommands {
    return @[[UIKeyCommand keyCommandWithInput:kDCIntrospectKeysInvoke modifierFlags:0 action:@selector(invoke)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysToggleViewOutlines modifierFlags:0 action:@selector(toggleViewOutlines)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysToggleNonOpaqueViews modifierFlags:0 action:@selector(toggleNonOpaqueViews)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysToggleHelp modifierFlags:0 action:@selector(toggleHelp)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysToggleFlashViewRedraws modifierFlags:0 action:@selector(toggleFlashViewRedraws)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysToggleShowCoordinates modifierFlags:0 action:@selector(toggleShowCoordinates)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysEnterBlockMode modifierFlags:0 action:@selector(enterBlockMode)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysNudgeViewLeft modifierFlags:0 action:@selector(nudgeViewLeft)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysNudgeViewRight modifierFlags:0 action:@selector(nudgeViewRight)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysNudgeViewUp modifierFlags:0 action:@selector(nudgeViewUp)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysNudgeViewDown modifierFlags:0 action:@selector(nudgeViewDown)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysCenterInSuperview modifierFlags:0 action:@selector(centerInSuperview)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysIncreaseWidth modifierFlags:0 action:@selector(increaseWidth)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysDecreaseWidth modifierFlags:0 action:@selector(decreaseWidth)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysIncreaseHeight modifierFlags:0 action:@selector(increaseHeight)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysDecreaseHeight modifierFlags:0 action:@selector(decreaseHeight)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysLogCodeForCurrentViewChanges modifierFlags:0 action:@selector(logCodeForCurrentViewChanges)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysIncreaseViewAlpha modifierFlags:0 action:@selector(increaseViewAlpha)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysDecreaseViewAlpha modifierFlags:0 action:@selector(decreaseViewAlpha)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysSetNeedsDisplay modifierFlags:0 action:@selector(forceSetNeedsDisplay)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysSetNeedsLayout modifierFlags:0 action:@selector(forceSetNeedsLayout)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysReloadData modifierFlags:0 action:@selector(reloadData)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysLogProperties modifierFlags:0 action:@selector(logProperties)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysLogAccessibilityProperties modifierFlags:0 action:@selector(logAccessibilityProperties)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysLogViewRecursive modifierFlags:0 action:@selector(logViewRecursive)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysExerciseAmbiguityInLayout modifierFlags:0 action:@selector(exerciseAmbiguityInLayout)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysConstraintsAffectingLayoutForAxisX modifierFlags:0 action:@selector(constraintsAffectingLayoutForAxisX)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysConstraintsAffectingLayoutForAxisY modifierFlags:0 action:@selector(constraintsAffectingLayoutForAxisY)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysMoveUpInViewHierarchy modifierFlags:0 action:@selector(moveUpInViewHierarchy)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysMoveBackInViewHierarchy modifierFlags:0 action:@selector(moveBackInViewHierarchy)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysMoveDownToFirstSubview modifierFlags:0 action:@selector(moveDownToFirstSubview)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysMoveToNextSiblingView modifierFlags:0 action:@selector(moveToNextSiblingView)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysMoveToPrevSiblingView modifierFlags:0 action:@selector(moveToPrevSiblingView)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysEnterGDB modifierFlags:0 action:@selector(enterGDB)],
             [UIKeyCommand keyCommandWithInput:kDCIntrospectKeysDisableForPeriod modifierFlags:0 action:@selector(disableForPeriod)],
             
             [UIKeyCommand keyCommandWithInput:UIKeyInputUpArrow modifierFlags:0 action:@selector(keyUp:)],
             [UIKeyCommand keyCommandWithInput:UIKeyInputUpArrow modifierFlags:UIKeyModifierShift action:@selector(keyUp:)],
             [UIKeyCommand keyCommandWithInput:UIKeyInputUpArrow modifierFlags:UIKeyModifierAlternate action:@selector(keyUp:)],
             
             [UIKeyCommand keyCommandWithInput:UIKeyInputDownArrow modifierFlags:0 action:@selector(keyDown:)],
             [UIKeyCommand keyCommandWithInput:UIKeyInputDownArrow modifierFlags:UIKeyModifierShift action:@selector(keyDown:)],
             [UIKeyCommand keyCommandWithInput:UIKeyInputDownArrow modifierFlags:UIKeyModifierAlternate action:@selector(keyDown:)],

             [UIKeyCommand keyCommandWithInput:UIKeyInputLeftArrow modifierFlags:0 action:@selector(keyLeft:)],
             [UIKeyCommand keyCommandWithInput:UIKeyInputLeftArrow modifierFlags:UIKeyModifierShift action:@selector(keyLeft:)],
             [UIKeyCommand keyCommandWithInput:UIKeyInputLeftArrow modifierFlags:UIKeyModifierAlternate action:@selector(keyLeft:)],
             
             [UIKeyCommand keyCommandWithInput:UIKeyInputRightArrow modifierFlags:0 action:@selector(keyRight:)],
             [UIKeyCommand keyCommandWithInput:UIKeyInputRightArrow modifierFlags:UIKeyModifierShift action:@selector(keyRight:)],
             [UIKeyCommand keyCommandWithInput:UIKeyInputRightArrow modifierFlags:UIKeyModifierAlternate action:@selector(keyRight:)],
             
             ];
}

- (void) invoke {
    [self.keyboardInputDelegate invokeIntrospector];
}

- (void) toggleViewOutlines {
    [self.keyboardInputDelegate toggleOutlines];
}

- (void) toggleNonOpaqueViews {
    [self.keyboardInputDelegate toggleNonOpaqueViews];
}

- (void) toggleHelp {
    [self.keyboardInputDelegate toggleHelp];
}

- (void) toggleFlashViewRedraws {
    [self.keyboardInputDelegate toggleRedrawFlashing];
}

- (void) toggleShowCoordinates {
    [self.keyboardInputDelegate toggleShowCoordinates];
}

- (void) enterBlockMode {
    
}

- (void) nudgeViewLeft {
    [self.keyboardInputDelegate manipulateFrame:FrameManipulationNudgeLeft withBigStep:NO];
}

- (void) nudgeViewRight {
    [self.keyboardInputDelegate manipulateFrame:FrameManipulationNudgeRight withBigStep:NO];
}

- (void) nudgeViewUp {
    [self.keyboardInputDelegate manipulateFrame:FrameManipulationNudgeUp withBigStep:NO];
}

- (void) nudgeViewDown {
    [self.keyboardInputDelegate manipulateFrame:FrameManipulationNudgeDown withBigStep:NO];
}

- (void) centerInSuperview {
    [self.keyboardInputDelegate manipulateFrame:FrameManipulationCenterInSuperview withBigStep:NO];
}

- (void) increaseWidth {
    [self.keyboardInputDelegate manipulateFrame:FrameManipulationIncreaseWidth withBigStep:NO];
}

- (void) decreaseWidth {
    [self.keyboardInputDelegate manipulateFrame:FrameManipulationDecreaseWidth withBigStep:NO];
}

- (void) increaseHeight {
    [self.keyboardInputDelegate manipulateFrame:FrameManipulationIncreaseHeight withBigStep:NO];
}

- (void) decreaseHeight {
    [self.keyboardInputDelegate manipulateFrame:FrameManipulationDecreaseHeight withBigStep:NO];
}

- (void) logCodeForCurrentViewChanges {
    [self.keyboardInputDelegate logCodeForCurrentViewChanges];
}

- (void) increaseViewAlpha {
    [self.keyboardInputDelegate manipulateFrame:FrameManipulationIncreaseAlpha withBigStep:NO];
}

- (void) decreaseViewAlpha {
    [self.keyboardInputDelegate manipulateFrame:FrameManipulationDecreaseAlpha withBigStep:NO];
}

- (void) forceSetNeedsDisplay {
    [self.keyboardInputDelegate forceSetNeedsDisplay];
}

- (void) forceSetNeedsLayout {
    [self.keyboardInputDelegate forceSetNeedsLayout];
}

- (void) reloadData {
    [self.keyboardInputDelegate forceReloadOfView];
}

- (void) logProperties {
    [self.keyboardInputDelegate logPropertiesForCurrentView];
}

- (void) logAccessibilityProperties {
    [self.keyboardInputDelegate logAccessabilityPropertiesForCurrentView];
}

- (void) logViewRecursive {
    [self.keyboardInputDelegate logRecursiveDescriptionForCurrentView];
}

- (void) exerciseAmbiguityInLayout {
    [self.keyboardInputDelegate exerciseAmbiguityInLayoutForCurrentView];
}

- (void) constraintsAffectingLayoutForAxisX {
    [self.keyboardInputDelegate logHorizontalConstraintsForCurrentView];
}

- (void) constraintsAffectingLayoutForAxisY {
    [self.keyboardInputDelegate logVerticalConstraintsForCurrentView];
}

- (void) moveUpInViewHierarchy {
    [self.keyboardInputDelegate moveUpInViewHierarchy];
}

- (void) moveBackInViewHierarchy {
    [self.keyboardInputDelegate moveBackInViewHierarchy];
}

- (void) moveDownToFirstSubview {
    [self.keyboardInputDelegate moveDownToFirstSubview];
}

- (void) moveToNextSiblingView {
    [self.keyboardInputDelegate moveToNextSiblingView];
}

- (void) moveToPrevSiblingView {
    [self.keyboardInputDelegate moveToPrevSiblingView];
}

- (void) enterGDB {
    [self.keyboardInputDelegate enterGDB];
}

- (void) disableForPeriod {
    [self.keyboardInputDelegate disableForPeriod];
}

- (void) keyLeft: (UIKeyCommand*) sender {
    switch (sender.modifierFlags) {
        case UIKeyModifierShift:
            [self.keyboardInputDelegate manipulateFrame:FrameManipulationNudgeLeft withBigStep:YES];
            break;
        case UIKeyModifierAlternate:
            [self.keyboardInputDelegate manipulateFrame:FrameManipulationDecreaseWidth withBigStep:NO];
            break;
        default:
            [self.keyboardInputDelegate manipulateFrame:FrameManipulationNudgeLeft withBigStep:NO];
            break;
    }
}

- (void) keyRight: (UIKeyCommand*) sender {
    switch (sender.modifierFlags) {
        case UIKeyModifierShift:
            [self.keyboardInputDelegate manipulateFrame:FrameManipulationNudgeRight withBigStep:YES];
            break;
        case UIKeyModifierAlternate:
            [self.keyboardInputDelegate manipulateFrame:FrameManipulationIncreaseWidth withBigStep:NO];
            break;
        default:
            [self.keyboardInputDelegate manipulateFrame:FrameManipulationNudgeRight withBigStep:NO];
            break;
    }
}

- (void) keyUp: (UIKeyCommand*) sender {
    switch (sender.modifierFlags) {
        case UIKeyModifierShift:
            [self.keyboardInputDelegate manipulateFrame:FrameManipulationNudgeUp withBigStep:YES];
            break;
        case UIKeyModifierAlternate:
            [self.keyboardInputDelegate manipulateFrame:FrameManipulationDecreaseHeight withBigStep:NO];
            break;
        default:
            [self.keyboardInputDelegate manipulateFrame:FrameManipulationNudgeUp withBigStep:NO];
            break;
    }
}

- (void) keyDown: (UIKeyCommand*) sender {
    switch (sender.modifierFlags) {
        case UIKeyModifierShift:
            [self.keyboardInputDelegate manipulateFrame:FrameManipulationNudgeDown withBigStep:YES];
            break;
        case UIKeyModifierAlternate:
            [self.keyboardInputDelegate manipulateFrame:FrameManipulationIncreaseHeight withBigStep:NO];
            break;
        default:
            [self.keyboardInputDelegate manipulateFrame:FrameManipulationNudgeDown withBigStep:NO];
            break;
    }
}

#endif

@end
