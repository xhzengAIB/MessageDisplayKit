//
//  DCIntrospect.m
//
//  Created by Domestic Cat on 29/04/11.
//

#import "DCIntrospect.h"
#import "UIView+DCAdditions.h"
#import <dlfcn.h>
#import "DCTextView.h"

#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>

#define IS_IOS7_AND_UP ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)

// break into GDB code complied from following sources: 
// http://blog.timac.org/?p=190, http://developer.apple.com/library/mac/#qa/qa1361/_index.html, http://cocoawithlove.com/2008/03/break-into-debugger.html

// Returns true if the current process is being debugged (either 
// running under the debugger or has a debugger attached post facto).
static bool AmIBeingDebugged(void)
{
	int                 junk;
	int                 mib[4];
	struct kinfo_proc   info;
	size_t              size;

	// Initialize the flags so that, if sysctl fails for some bizarre 
	// reason, we get a predictable result.

	info.kp_proc.p_flag = 0;

	// Initialize mib, which tells sysctl the info we want, in this case
	// we're looking for information about a specific process ID.

	mib[0] = CTL_KERN;
	mib[1] = KERN_PROC;
	mib[2] = KERN_PROC_PID;
	mib[3] = getpid();

	// Call sysctl.

	size = sizeof(info);
	junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
	assert(junk == 0);

	// We're being debugged if the P_TRACED flag is set.

	return ( (info.kp_proc.p_flag & P_TRACED) != 0 );
}

#if TARGET_CPU_ARM
#define DEBUGSTOP(signal) __asm__ __volatile__ ("mov r0, %0\nmov r1, %1\nmov r12, %2\nswi 128\n" : : "r"(getpid ()), "r"(signal), "r"(37) : "r12", "r0", "r1", "cc");
#define DEBUGGER do { int trapSignal = AmIBeingDebugged () ? SIGINT : SIGSTOP; DEBUGSTOP(trapSignal); if (trapSignal == SIGSTOP) { DEBUGSTOP (SIGINT); } } while (false);
#elif TARGET_CPU_ARM64
#define DEBUGGER // Breaking into debugger on arm64 is not currently supported
#else
#define DEBUGGER do { int trapSignal = AmIBeingDebugged () ? SIGINT : SIGSTOP; __asm__ __volatile__ ("pushl %0\npushl %1\npush $0\nmovl %2, %%eax\nint $0x80\nadd $12, %%esp" : : "g" (trapSignal), "g" (getpid ()), "n" (37) : "eax", "cc"); } while (false);
#endif

@interface DCIntrospect () <DCTextViewDelegate>

@property(nonatomic, assign, getter=isKeyboardVisible) BOOL keyboardVisible;

- (void)takeFirstResponder;

@end

@implementation DCIntrospect

#pragma mark Setup

+ (void)initialize
{	
	NSString *simulatorRoot = [[[NSProcessInfo processInfo] environment] objectForKey:@"IPHONE_SIMULATOR_ROOT"];
	if (simulatorRoot)
	{
		void *AppSupport = dlopen([[simulatorRoot stringByAppendingPathComponent:@"/System/Library/PrivateFrameworks/AppSupport.framework/AppSupport"] fileSystemRepresentation], RTLD_LAZY);
		CFStringRef (*CPCopySharedResourcesPreferencesDomainForDomain)(CFStringRef domain) = (CFStringRef (*)())dlsym(AppSupport, "CPCopySharedResourcesPreferencesDomainForDomain");
		if (CPCopySharedResourcesPreferencesDomainForDomain)
		{
			CFStringRef accessibilityDomain = CPCopySharedResourcesPreferencesDomainForDomain(CFSTR("com.apple.Accessibility"));
			if (accessibilityDomain)
			{
				// This must be done *before* UIApplicationMain, hence +load
				CFPreferencesSetValue(CFSTR("ApplicationAccessibilityEnabled"), kCFBooleanTrue, accessibilityDomain, kCFPreferencesAnyUser, kCFPreferencesAnyHost);
				CFRelease(accessibilityDomain);
			}
		}
	}
}

static void *originalValueForKeyIMPKey = &originalValueForKeyIMPKey;

id UITextInputTraits_valueForKey(id self, SEL _cmd, NSString *key);
id UITextInputTraits_valueForKey(id self, SEL _cmd, NSString *key)
{
	static NSMutableSet *textInputTraitsProperties = nil;
	if (!textInputTraitsProperties)
	{
		textInputTraitsProperties = [[NSMutableSet alloc] init];
		unsigned int count = 0;
		objc_property_t *properties = protocol_copyPropertyList(@protocol(UITextInputTraits), &count);
		for (unsigned int i = 0; i < count; i++)
		{
			objc_property_t property = properties[i];
			NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
			[textInputTraitsProperties addObject:propertyName];
		}
		free(properties);
	}
	
	IMP valueForKey = (IMP)[objc_getAssociatedObject([self class], originalValueForKeyIMPKey) pointerValue];
	if ([textInputTraitsProperties containsObject:key])
	{
		id textInputTraits = valueForKey(self, _cmd, @"textInputTraits");
		return valueForKey(textInputTraits, _cmd, key);
	}
	else
	{
		return valueForKey(self, _cmd, key);
	}
}

// See http://stackoverflow.com/questions/6617472/why-does-valueforkey-on-a-uitextfield-throws-an-exception-for-uitextinputtraits
+ (void)workaroundUITextInputTraitsPropertiesBug
{
	
	unsigned int count = 0;
	Class *classes = objc_copyClassList(&count);
    NSMutableSet *visitedClasses = [[NSMutableSet alloc] initWithCapacity:count];
	for (unsigned int i = 0; i < count; i++)
	{
		Class class = classes[i];
        [self visitClassForWorkaroundUITextInputTraitsPropertiesBug:class visited:visitedClasses];
	}
	free(classes);
}

+ (void)visitClassForWorkaroundUITextInputTraitsPropertiesBug:(Class) class visited:(NSMutableSet*) visited {
    NSString *className = NSStringFromClass(class);
    if (![visited containsObject:className]) {
        [visited addObject:className];
        Method valueForKey = class_getInstanceMethod([NSObject class], @selector(valueForKey:));
        const char *valueForKeyTypeEncoding = method_getTypeEncoding(valueForKey);
        if (class_getInstanceMethod(class, NSSelectorFromString(@"textInputTraits")))
        {
            Class superclass = [class superclass];
            if (superclass) {
                [self visitClassForWorkaroundUITextInputTraitsPropertiesBug:superclass visited:visited];
            }
            IMP originalValueForKey = nil;
            if (!class_addMethod(class, @selector(valueForKey:), (IMP)UITextInputTraits_valueForKey, valueForKeyTypeEncoding)) {
                originalValueForKey = class_replaceMethod(class, @selector(valueForKey:), (IMP)UITextInputTraits_valueForKey, valueForKeyTypeEncoding);
            }
            if (!originalValueForKey) {
                originalValueForKey = (IMP)[objc_getAssociatedObject(superclass, originalValueForKeyIMPKey) pointerValue];
            }
            if (!originalValueForKey) {
                originalValueForKey = class_getMethodImplementation(superclass, @selector(valueForKey:));
            }
            objc_setAssociatedObject(class, originalValueForKeyIMPKey, [NSValue valueWithPointer:(void *)originalValueForKey], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

+ (DCIntrospect *)sharedIntrospector
{
	static DCIntrospect *sharedInstance = nil;
#ifdef DEBUG
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[DCIntrospect alloc] init];
		sharedInstance.keyboardBindingsOn = YES;
		sharedInstance.showStatusBarOverlay = ![UIApplication sharedApplication].statusBarHidden;
		[self workaroundUITextInputTraitsPropertiesBug];
	});
#endif
	return sharedInstance;
}

- (void)start
{
	UIWindow *mainWindow = [self mainWindow];
	if (!mainWindow)
	{
		NSLog(@"DCIntrospect-ARC: Couldn't setup.  No main window?");
		return;
	}
	
	if (!self.statusBarOverlay)
	{
		self.statusBarOverlay = [[DCStatusBarOverlay alloc] init];
	}
	
	if (!self.inputTextView)
	{
        if (iOS7OrHigher()) {
            self.inputTextView = [[DCTextView alloc] initWithFrame:CGRectMake(0, -100, 100, 100)];
            [(DCTextView*)self.inputTextView setKeyboardInputDelegate: self];
        }
        else {
            self.inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, -100, 100, 100)];
            self.inputTextView.delegate = self;
        }
		self.inputTextView.autocorrectionType = UITextAutocorrectionTypeNo;
		self.inputTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
		self.inputTextView.inputView = [[UIView alloc] init];
		self.inputTextView.scrollsToTop = NO;
		[mainWindow addSubview:self.inputTextView];
	}
	
	if (self.keyboardBindingsOn)
	{
		if (![self.inputTextView becomeFirstResponder])
		{
			[self performSelector:@selector(takeFirstResponder) withObject:nil afterDelay:0.5];
		}
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTapped) name:kDCIntrospectNotificationStatusBarTapped object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
		self.keyboardVisible = YES;
	}];
	
	// reclaim the keyboard after dismissal if it is taken
	[[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
		self.keyboardVisible = NO;
		
		// needs to be done after a delay or else it doesn't work for some reason.
		if (self.keyboardBindingsOn)
			[self performSelector:@selector(takeFirstResponder)
					   withObject:nil
					   afterDelay:0.1];
	}];
    
    // dirty hack for UIWebView keyboard problems
	[[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
													  object:nil
													   queue:nil
												  usingBlock:^(NSNotification *notification) {
													  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(takeFirstResponder) object:nil];
												  }];
    
	[[NSNotificationCenter defaultCenter] addObserverForName:UIMenuControllerDidHideMenuNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
		if (!self.keyboardVisible)
		{
			[self performSelector:@selector(takeFirstResponder) withObject:nil afterDelay:0.1];
		}
	}];

	// listen for device orientation changes to adjust the status bar
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViews) name:UIDeviceOrientationDidChangeNotification object:nil];
	
	if (!self.currentViewHistory)
		self.currentViewHistory = [[NSMutableArray alloc] init];
	
	NSLog(@"DCIntrospect-ARC is setup. %@ to start.", [kDCIntrospectKeysInvoke isEqualToString:@" "] ? @"Push the space bar" : [NSString stringWithFormat:@"Type '%@'",  kDCIntrospectKeysInvoke]);
}

- (void)takeFirstResponder
{
	if (![self.inputTextView becomeFirstResponder])
		NSLog(@"DCIntrospect-ARC: Couldn't reclaim keyboard input.  Is the keyboard used elsewhere?");
}

- (void)resetInputTextView
{
	self.inputTextView.text = @"\n2 4567 9\n";
	self.handleArrowKeys = NO;
	self.inputTextView.selectedRange = NSMakeRange(5, 0);
	self.handleArrowKeys = YES;
}

#pragma mark Custom Setters
- (void)setInvokeGestureRecognizer:(UIGestureRecognizer *)newGestureRecognizer
{
	UIWindow *mainWindow = [self mainWindow];
	[mainWindow removeGestureRecognizer:self.invokeGestureRecognizer];
	_invokeGestureRecognizer = newGestureRecognizer;
	[self.invokeGestureRecognizer addTarget:self action:@selector(invokeIntrospector)];
	[mainWindow addGestureRecognizer:self.invokeGestureRecognizer];
}

- (void)setKeyboardBindingsOn:(BOOL)areKeyboardBindingsOn
{
	_keyboardBindingsOn = areKeyboardBindingsOn;
	if (self.keyboardBindingsOn)
		[self.inputTextView becomeFirstResponder];
	else
		[self.inputTextView resignFirstResponder];
}

#pragma mark Main Actions

- (void)invokeIntrospector
{
	self.on = !self.on;
	
	if (self.on)
	{
		[self updateViews];
		[self updateStatusBar];
		[self updateFrameView];
		
		if (self.keyboardBindingsOn)
			[self.inputTextView becomeFirstResponder];
		else
			[self.inputTextView resignFirstResponder];
		
		[self resetInputTextView];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kDCIntrospectNotificationIntrospectionDidStart
															object:nil];
	}
	else
	{
		if (self.viewOutlines)
			[self toggleOutlines];
		if (self.highlightNonOpaqueViews)
			[self toggleNonOpaqueViews];
		if (self.showingHelp)
			[self toggleHelp];
		
		self.statusBarOverlay.hidden = YES;
		self.frameView.alpha = 0;
		self.currentView = nil;
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kDCIntrospectNotificationIntrospectionDidEnd
															object:nil];
	}
}

- (void)touchAtPoint:(CGPoint)point
{
	// convert the point into the main window
	CGPoint convertedTouchPoint = [[self mainWindow] convertPoint:point fromView:self.frameView];
	
	// find all the views under that point – will be added in order on screen, ie mainWindow will be index 0, main view controller at index 1 etc, note that hidden views are ignored.
	NSMutableArray *views = [self viewsAtPoint:convertedTouchPoint inView:[self mainWindow]];
	while ([views.lastObject isHidden]) {
		[views removeLastObject];
	}
	if (views.count == 0)
		return;
	
	// get the topmost view and setup the UI
	[self.currentViewHistory removeAllObjects];
	UIView *newView = [views lastObject];
	[self selectView:newView];
}

- (void)selectView:(UIView *)view
{
	self.currentView = view;
	self.originalFrame = self.currentView.frame;
	self.originalAlpha = self.currentView.alpha;
	
	if (self.frameView.rectsToOutline.count > 0)
	{
		[self.frameView.rectsToOutline removeAllObjects];
		[self.frameView setNeedsDisplay];
		self.viewOutlines = NO;
	}
	
	[self updateFrameView];
	[self updateStatusBar];
	
	if (![self.currentViewHistory containsObject:self.currentView])
		[self.currentViewHistory addObject:self.currentView];
}

- (void)statusBarTapped
{
	if (self.showingHelp)
	{
		[self toggleHelp];
		return;
	}
}

#pragma mark Keyboard Capture

- (void)textViewDidChangeSelection:(UITextView *)textView
{
	if (!(self.on && self.handleArrowKeys))
		return;
	
	NSUInteger selectionLocation = textView.selectedRange.location;
	NSUInteger selectionLength = textView.selectedRange.length;
	BOOL shiftKey = selectionLength != 0;
	BOOL optionKey = selectionLocation % 2 == 1;
	
	if (shiftKey)
	{
		if (selectionLocation == 4 && selectionLength == 1)
            [self manipulateFrame:FrameManipulationNudgeLeft withBigStep:YES];
		else if (selectionLocation == 5 && selectionLength == 1)
            [self manipulateFrame:FrameManipulationNudgeRight withBigStep:YES];
		else if (selectionLocation == 0 && selectionLength == 5)
			[self manipulateFrame:FrameManipulationNudgeUp withBigStep:YES];
		else if (selectionLocation == 5 && selectionLength == 5)
			[self manipulateFrame:FrameManipulationNudgeDown withBigStep:YES];
	}
	else if (optionKey)
	{
		if (selectionLocation == 7)
			[self manipulateFrame:FrameManipulationIncreaseWidth withBigStep:NO];
		else if (selectionLocation == 3)
			[self manipulateFrame:FrameManipulationDecreaseWidth withBigStep:NO];
		else if (selectionLocation == 9)
			[self manipulateFrame:FrameManipulationIncreaseHeight withBigStep:NO];
		else if (selectionLocation == 1)
			[self manipulateFrame:FrameManipulationDecreaseHeight withBigStep:NO];
	}
	else
	{
		if (selectionLocation == 4)
			[self manipulateFrame:FrameManipulationNudgeLeft withBigStep:NO];
		else if (selectionLocation == 6)
			[self manipulateFrame:FrameManipulationNudgeRight withBigStep:NO];
		else if (selectionLocation == 0)
			[self manipulateFrame:FrameManipulationNudgeUp withBigStep:NO];
		else if (selectionLocation == 10)
			[self manipulateFrame:FrameManipulationNudgeDown withBigStep:NO];
	}
	
    self.handleArrowKeys = NO; //option-down arrow will get handled twice if key handling isn't disabled immediately
    [self performSelector:@selector(resetInputTextView) withObject:nil afterDelay:0.0]; //selectedRange doesn't reset correctly on iOS 6 if this isn't performed with a delay
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string
{
	if ([string isEqualToString:kDCIntrospectKeysDisableForPeriod])
    {
        [self disableForPeriod];
        return NO;
    }
    
	if ([string isEqualToString:kDCIntrospectKeysInvoke])
	{
		[self invokeIntrospector];
		return NO;
	}
	
	if (!self.on)
		return NO;
	
	if (self.showingHelp)
	{
		[self toggleHelp];
		return NO;
	}
	
    if ([string isEqualToString:kDCIntrospectKeysToggleViewOutlines])
	{
		[self toggleOutlines];
		return NO;
	}
	else if ([string isEqualToString:kDCIntrospectKeysToggleNonOpaqueViews])
	{
		[self toggleNonOpaqueViews];
		return NO;
	}
	else if ([string isEqualToString:kDCIntrospectKeysToggleAmbiguousLayouts])
	{
		[self toggleAmbiguousLayouts];
		return NO;
	}
	else if ([string isEqualToString:kDCIntrospectKeysToggleFlashViewRedraws])
	{
		[self toggleRedrawFlashing];
		return NO;
	}
	else if ([string isEqualToString:kDCIntrospectKeysToggleShowCoordinates])
	{
		[self toggleShowCoordinates];
		return NO;
	}
	else if ([string isEqualToString:kDCIntrospectKeysToggleHelp])
	{
		[self toggleHelp];
		return NO;
	}
	
	if (self.on && self.currentView)
	{
		if ([string isEqualToString:kDCIntrospectKeysLogProperties])
		{
			[self logPropertiesForObject:self.currentView];
			return NO;
		}
		else if ([string isEqualToString:kDCIntrospectKeysLogAccessibilityProperties])
		{
			[self logAccessabilityPropertiesForObject:self.currentView];
			return NO;
		}
		else if ([string isEqualToString:kDCIntrospectKeysLogViewRecursive])
		{
			[self logRecursiveDescriptionForView:self.currentView];
			return NO;
		}
		else if ([string isEqualToString:kDCIntrospectKeysExerciseAmbiguityInLayout])
		{
			[self exerciseAmbiguityInLayoutForView:self.currentView];
			return NO;
		}
		else if ([string isEqualToString:kDCIntrospectKeysConstraintsAffectingLayoutForAxisX])
		{
			[self logHorizontalConstraintsForView:self.currentView];
			return NO;
		}
		else if ([string isEqualToString:kDCIntrospectKeysConstraintsAffectingLayoutForAxisY]) {
			[self logVerticalConstraintsForView:self.currentView];
			return NO;
		}
		else if ([string isEqualToString:kDCIntrospectKeysSetNeedsDisplay])
		{
			[self forceSetNeedsDisplay];
			return NO;
		}
		else if ([string isEqualToString:kDCIntrospectKeysSetNeedsLayout])
		{
			[self forceSetNeedsLayout];
			return NO;
		}
		else if ([string isEqualToString:kDCIntrospectKeysReloadData])
		{
			[self forceReloadOfView];
			return NO;
		}
		else if ([string isEqualToString:kDCIntrospectKeysMoveUpInViewHierarchy])
		{
			[self moveUpInViewHierarchy];
			return NO;
		}
		else if ([string isEqualToString:kDCIntrospectKeysMoveBackInViewHierarchy])
		{
			[self moveBackInViewHierarchy];
            return NO;
		}
		else if ([string isEqualToString:kDCIntrospectKeysMoveDownToFirstSubview])
		{
			[self moveDownToFirstSubview];
			return NO;
		}
		else if ([string isEqualToString:kDCIntrospectKeysMoveToNextSiblingView])
		{
			[self moveToNextSiblingView];
			return NO;
		}
		else if ([string isEqualToString:kDCIntrospectKeysMoveToPrevSiblingView])
		{
			[self moveToPrevSiblingView];
			return NO;
		}
		else if ([string isEqualToString:kDCIntrospectKeysLogCodeForCurrentViewChanges])
		{
			[self logCodeForCurrentViewChanges];
			return NO;
		}
        else if ([string isEqualToString:kDCIntrospectKeysEnterGDB])
		{
			[self enterGDB];
			return NO;
		}
		
		if ([string isEqualToString:kDCIntrospectKeysNudgeViewLeft])
			[self manipulateFrame:FrameManipulationNudgeLeft withBigStep:NO];
		else if ([string isEqualToString:kDCIntrospectKeysNudgeViewRight])
			[self manipulateFrame:FrameManipulationNudgeRight withBigStep:NO];
		else if ([string isEqualToString:kDCIntrospectKeysNudgeViewUp])
			[self manipulateFrame:FrameManipulationNudgeUp withBigStep:NO];
		else if ([string isEqualToString:kDCIntrospectKeysNudgeViewDown])
			[self manipulateFrame:FrameManipulationNudgeDown withBigStep:NO];
		else if ([string isEqualToString:kDCIntrospectKeysCenterInSuperview])
			[self manipulateFrame:FrameManipulationCenterInSuperview withBigStep:NO];
		else if ([string isEqualToString:kDCIntrospectKeysIncreaseWidth])
			[self manipulateFrame:FrameManipulationIncreaseWidth withBigStep:NO];
		else if ([string isEqualToString:kDCIntrospectKeysDecreaseWidth])
			[self manipulateFrame:FrameManipulationDecreaseWidth withBigStep:NO];
		else if ([string isEqualToString:kDCIntrospectKeysIncreaseHeight])
			[self manipulateFrame:FrameManipulationIncreaseHeight withBigStep:NO];
		else if ([string isEqualToString:kDCIntrospectKeysDecreaseHeight])
			[self manipulateFrame:FrameManipulationDecreaseHeight withBigStep:NO];
		else if ([string isEqualToString:kDCIntrospectKeysIncreaseViewAlpha])
            [self manipulateFrame:FrameManipulationIncreaseAlpha withBigStep:NO];
		else if ([string isEqualToString:kDCIntrospectKeysDecreaseViewAlpha])
            [self manipulateFrame:FrameManipulationDecreaseAlpha withBigStep:NO];
	}
	
	return NO;
}

#pragma mark Object Names

- (void)logCodeForCurrentViewChanges
{
	if (!self.on || !self.currentView)
        return;
	
	NSString *varName = [self nameForObject:self.currentView];
	if ([varName isEqualToString:[NSString stringWithFormat:@"%@", self.currentView.class]])
		varName = @"<#view#>";
	
	NSMutableString *outputString = [NSMutableString string];
	if (!CGRectEqualToRect(self.originalFrame, self.currentView.frame))
	{
		[outputString appendFormat:@"%@.frame = CGRectMake(%.1f, %.1f, %.1f, %.1f);\n", varName, self.currentView.frame.origin.x, self.currentView.frame.origin.y, self.currentView.frame.size.width, self.currentView.frame.size.height];
	}
	
	if (self.originalAlpha != self.currentView.alpha)
	{
		[outputString appendFormat:@"%@.alpha = %.2f;\n", varName, self.currentView.alpha];
	}
	
	if (outputString.length == 0)
		NSLog(@"DCIntrospect-ARC: No changes made to %@.", self.currentView.class);
	else
		printf("\n\n%s\n", [outputString UTF8String]);
}

- (void)setName:(NSString *)name forObject:(id)object accessedWithSelf:(BOOL)accessedWithSelf
{
	if (!self.objectNames)
		self.objectNames = [NSMutableDictionary dictionary];
	
	if (accessedWithSelf)
		name = [@"self." stringByAppendingString:name];
	
	[self.objectNames setValue:object forKey:name];
}

- (NSString *)nameForObject:(id)object
{
	__block NSString *objectName = [NSString stringWithFormat:@"%@", [object class]];
	if (!self.objectNames)
		return objectName;
	
	[self.objectNames enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		if (obj == object)
		{
			objectName = (NSString *)key;
			*stop = YES;
		}
	}];
	
	return objectName;
}

- (void)removeNamesForViewsInView:(UIView *)view
{
	if (!self.objectNames)
		return;
	
	NSMutableArray *objectsToRemove = [NSMutableArray array];
	[self.objectNames enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		if ([[obj class] isSubclassOfClass:[UIView class]])
		{
			UIView *subview = (UIView *)obj;
			if ([self view:view containsSubview:subview])
				[objectsToRemove addObject:key];
		}
	}];
	
	[objectsToRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSString *key = (NSString *)obj;
		[self.objectNames removeObjectForKey:key];
	}];
}

- (void)removeNameForObject:(id)object
{
	if (!self.objectNames)
		return;
	
	NSString *objectName = [self nameForObject:object];
	[self.objectNames removeObjectForKey:objectName];
}

#pragma mark Layout

- (void)updateFrameView
{
	UIWindow *mainWindow = [self mainWindow];
	if (!self.frameView)
	{
		self.frameView = [[DCFrameView alloc] initWithFrame:(CGRect){ CGPointZero, mainWindow.frame.size } delegate:self];
		[mainWindow addSubview:self.frameView];
		self.frameView.alpha = 0.0f;
		[self updateViews];
	}
	
	[mainWindow bringSubviewToFront:self.frameView];
	
	if (self.on)
	{
		if (self.currentView)
		{
			self.frameView.mainRect = [self.currentView.superview convertRect:self.currentView.frame toView:self.frameView];
			if (self.currentView.superview == mainWindow)
				self.frameView.superRect = CGRectZero;
			else if (self.currentView.superview.superview)
				self.frameView.superRect = [self.currentView.superview.superview convertRect:self.currentView.superview.frame toView:self.frameView];
			else
				self.frameView.superRect = CGRectZero;
		}
		else
		{
			self.frameView.mainRect = CGRectZero;
		}
		
		[self fadeView:self.frameView toAlpha:1.0f];
	}
	else
	{
		[self fadeView:self.frameView toAlpha:0.0f];
	}
}

- (void)updateStatusBar
{
	if (self.currentView)
	{
		NSString *nameForObject = [self nameForObject:self.currentView];
		
		// remove the 'self.' if it's there to save space
		if ([nameForObject hasPrefix:@"self."])
			nameForObject = [nameForObject substringFromIndex:@"self.".length];
		
		if (self.currentView.tag != 0)
			self.statusBarOverlay.leftLabel.text = [NSString stringWithFormat:@"%@ (tag: %ld)", nameForObject, (long)self.currentView.tag];
		else
			self.statusBarOverlay.leftLabel.text = [NSString stringWithFormat:@"%@", nameForObject];
		
		self.statusBarOverlay.rightLabel.text = NSStringFromCGRect(self.currentView.frame);

		if ([self.currentView respondsToSelector:@selector(hasAmbiguousLayout)])
			if ([self.currentView hasAmbiguousLayout])
				self.statusBarOverlay.rightLabel.text = [NSString stringWithFormat:@"\ue021%@", self.statusBarOverlay.rightLabel.text];
	}
	else
	{
		self.statusBarOverlay.leftLabel.text = @"DCIntrospect-ARC";
		self.statusBarOverlay.rightLabel.text = [NSString stringWithFormat:@"'%@' for help", kDCIntrospectKeysToggleHelp];
	}
	
	if (self.showStatusBarOverlay)
		self.statusBarOverlay.hidden = NO;
	else
		self.statusBarOverlay.hidden = YES;
}

- (void)updateViews
{
	// current interface orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
	CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
	
	CGFloat pi = (CGFloat)M_PI;
	if (orientation == UIDeviceOrientationPortrait)
	{
		self.frameView.transform = CGAffineTransformIdentity;
		self.frameView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
	}
	else if (orientation == UIDeviceOrientationLandscapeLeft)
	{
		self.frameView.transform = CGAffineTransformMakeRotation(pi * (90) / 180.0f);
		self.frameView.frame = CGRectMake(screenWidth - screenHeight, 0, screenHeight, screenHeight);
	}
	else if (orientation == UIDeviceOrientationLandscapeRight)
	{
		self.frameView.transform = CGAffineTransformMakeRotation(pi * (-90) / 180.0f);
		self.frameView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
	}
	else if (orientation == UIDeviceOrientationPortraitUpsideDown)
	{
		self.frameView.transform = CGAffineTransformMakeRotation(pi);
		self.frameView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
	}
	
	self.currentView = nil;
	[self updateFrameView];
}

- (void)showTemporaryStringInStatusBar:(NSString *)string
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateStatusBar) object:nil];
	
	self.statusBarOverlay.leftLabel.text = string;
	self.statusBarOverlay.rightLabel.text = nil;
	[self performSelector:@selector(updateStatusBar) withObject:nil afterDelay:0.75];
}

#pragma mark Actions

- (void)disableForPeriod {
    [self setKeyboardBindingsOn:NO];
    [[self inputTextView] resignFirstResponder];
    NSLog(@"DCIntrospect-ARC: Disabled for %.1f seconds", kDCIntrospectTemporaryDisableDuration);
    [self performSelector:@selector(setKeyboardBindingsOn:) withObject:[NSNumber numberWithFloat:YES] afterDelay:kDCIntrospectTemporaryDisableDuration];
}

- (void)logRecursiveDescriptionForCurrentView
{
    if (!self.on || !self.currentView)
        return;
	[self logRecursiveDescriptionForView:self.currentView];
}

- (void)logRecursiveDescriptionForView:(UIView *)view
{
#ifdef DEBUG
	// [UIView recursiveDescription] is a private method.  This should probably be re-written to avoid any potential problems.
	NSLog(@"DCIntrospect-ARC: %@", [view recursiveDescription]);
#endif
}

- (void)forceSetNeedsDisplay
{
    if (!self.on || !self.currentView)
        return;
	[self.currentView setNeedsDisplay];
}

- (void)forceSetNeedsLayout
{
    if (!self.on || !self.currentView)
        return;
	[self.currentView setNeedsLayout];
}

- (void)forceReloadOfView
{
    if (!self.on || !self.currentView)
        return;
    
	if ([self.currentView class] == [UITableView class])
		[(UITableView *)self.currentView reloadData];
}

- (void)toggleOutlines
{
    if (!self.on)
		return;
	
	if (self.showingHelp)
	{
		[self toggleHelp];
		return;
	}
    
	UIWindow *mainWindow = [self mainWindow];
	self.viewOutlines = !self.viewOutlines;
	
	if (self.viewOutlines)
		[self addOutlinesToFrameViewFromSubview:mainWindow];
	else
		[self.frameView.rectsToOutline removeAllObjects];
	
	[self.frameView setNeedsDisplay];
	
	NSString *string = [NSString stringWithFormat:@"Showing view outlines is %@", (self.viewOutlines) ? @"on" : @"off"];
	if (self.showStatusBarOverlay)
		[self showTemporaryStringInStatusBar:string];
	else
		NSLog(@"DCIntrospect-ARC: %@", string);
}

- (void)addOutlinesToFrameViewFromSubview:(UIView *)view
{
	for (UIView *subview in view.subviews)
	{
		if ([self shouldIgnoreView:subview])
			continue;
		
		CGRect rect = [subview.superview convertRect:subview.frame toView:self.frameView];
		
		NSValue *rectValue = [NSValue valueWithCGRect:rect];
		[self.frameView.rectsToOutline addObject:rectValue];
		[self addOutlinesToFrameViewFromSubview:subview];
	}
}

- (void)toggleNonOpaqueViews
{
    if (!self.on)
		return;
	
	if (self.showingHelp)
	{
		[self toggleHelp];
		return;
	}
    
	self.highlightNonOpaqueViews = !self.highlightNonOpaqueViews;
	
	UIWindow *mainWindow = [self mainWindow];
	[self setBackgroundColor:(self.highlightNonOpaqueViews) ? kDCIntrospectOpaqueColor : [UIColor clearColor]
   ofNonOpaqueViewsInSubview:mainWindow];
	
	NSString *string = [NSString stringWithFormat:@"Highlighting non-opaque views is %@", (self.highlightNonOpaqueViews) ? @"on" : @"off"];
	if (self.showStatusBarOverlay)
		[self showTemporaryStringInStatusBar:string];
	else
		NSLog(@"DCIntrospect-ARC: %@", string);
}

- (void)setBackgroundColor:(UIColor *)color ofNonOpaqueViewsInSubview:(UIView *)view
{
	for (UIView *subview in view.subviews)
	{
		if ([self shouldIgnoreView:subview])
			continue;
		
		if (!subview.opaque)
			subview.backgroundColor = color;
		
		[self setBackgroundColor:color ofNonOpaqueViewsInSubview:subview];
	}
}

- (void)toggleAmbiguousLayouts
{
    if (!self.on)
		return;
	
	if (self.showingHelp)
	{
		[self toggleHelp];
		return;
	}
    
	self.highlightAmbiguousLayouts = !self.highlightAmbiguousLayouts;
	
	UIWindow *mainWindow = [self mainWindow];
	[self toggleAmbiguousLayoutsOfSubiew:mainWindow];
	
	NSString *string = [NSString stringWithFormat:@"Highlighting ambiguous layouts is %@", (self.highlightAmbiguousLayouts) ? @"on" : @"off"];
	if (self.showStatusBarOverlay)
		[self showTemporaryStringInStatusBar:string];
	else
		NSLog(@"DCIntrospect-ARC: %@", string);
}

- (void)toggleAmbiguousLayoutsOfSubiew:(UIView *)view
{
	for (UIView *subview in view.subviews)
	{
		if ([self shouldIgnoreView:subview])
			continue;
		
		if ([subview respondsToSelector:@selector(hasAmbiguousLayout)])
		{
			UIColor *originalColor = subview.dc_originalBackgroundColor;
			
			BOOL hasAmbiguousLayout = [subview hasAmbiguousLayout];
			UIColor *toggledBackgroundColor = self.highlightAmbiguousLayouts ? [kDCIntrospectAmbiguousColor colorWithAlphaComponent:.6] : originalColor;
						
			if (hasAmbiguousLayout)
				subview.backgroundColor = toggledBackgroundColor;
		}
		
		[self toggleAmbiguousLayoutsOfSubiew:subview];
	}
}

- (void)toggleRedrawFlashing
{
    if (!self.on)
		return;
	
	if (self.showingHelp)
	{
		[self toggleHelp];
		return;
	}
    
	self.flashOnRedraw = !self.flashOnRedraw;
	NSString *string = [NSString stringWithFormat:@"Flashing on redraw is %@", (self.flashOnRedraw) ? @"on" : @"off"];
	if (self.showStatusBarOverlay)
		[self showTemporaryStringInStatusBar:string];
	else
		NSLog(@"DCIntrospect-ARC: %@", string);
	
	// flash all views to show what is working
	[self callDrawRectOnViewsInSubview:[self mainWindow]];
}

- (void)toggleShowCoordinates {
    if (!self.on)
		return;
	
	if (self.showingHelp)
	{
		[self toggleHelp];
		return;
	}
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.frameView.touchPointLabel.alpha = !self.frameView.touchPointLabel.alpha;
                     } completion:^(BOOL finished) {
                         NSString *coordinatesString = [NSString stringWithFormat:@"Coordinates are %@", (self.frameView.touchPointLabel.alpha) ? @"on" : @"off"];
                         if (self.showStatusBarOverlay)
                             [self showTemporaryStringInStatusBar:coordinatesString];
                         else
                             NSLog(@"DCIntrospect-ARC: %@", coordinatesString);
                     }];
}

- (void)callDrawRectOnViewsInSubview:(UIView *)subview
{
	for (UIView *view in subview.subviews)
	{
		if (![self shouldIgnoreView:view])
		{
			[view setNeedsDisplay];
			[self callDrawRectOnViewsInSubview:view];
		}
	}
}

- (void)flashRect:(CGRect)rect inView:(UIView *)view
{
	if (self.flashOnRedraw)
	{
		CALayer *layer = [CALayer layer];
		layer.frame = rect;
		layer.backgroundColor = kDCIntrospectFlashOnRedrawColor.CGColor;
		[view.layer addSublayer:layer];
		[layer performSelector:@selector(removeFromSuperlayer) withObject:nil afterDelay:kDCIntrospectFlashOnRedrawFlashLength];
	}
}

- (void)exerciseAmbiguityInLayoutForView:(UIView *)view
{
	if ([view respondsToSelector:@selector(hasAmbiguousLayout)])
	{
		BOOL hasAmbiguousLayout = [view hasAmbiguousLayout];
		NSLog(@"DCIntrospect-ARC: ambiguous layout? %@", hasAmbiguousLayout ? @"YES" : @"NO");
		if (hasAmbiguousLayout)
			[view exerciseAmbiguityInLayout];
	}
}

- (void)logHorizontalConstraintsForView:(UIView *)view
{
	if ([view respondsToSelector:@selector(constraintsAffectingLayoutForAxis:)])
		NSLog(@"DCIntrospect-ARC: constraints for horizontal axis: %@",
			  [view constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal]);
}

- (void)logVerticalConstraintsForView:(UIView *)view
{
	if ([view respondsToSelector:@selector(constraintsAffectingLayoutForAxis:)])
		NSLog(@"DCIntrospect-ARC: constraints for vertical axis: %@",
			  [view constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical]);
}

- (void)logAccessabilityPropertiesForCurrentView {
    if (!self.on || !self.currentView)
        return;
    [self logAccessabilityPropertiesForObject:self.currentView];
}

- (void)logHorizontalConstraintsForCurrentView {
    if (!self.on || !self.currentView)
        return;
    [self logHorizontalConstraintsForView:self.currentView];
}

- (void)logVerticalConstraintsForCurrentView {
    if (!self.on || !self.currentView)
        return;
    [self logVerticalConstraintsForView:self.currentView];
}

- (void)exerciseAmbiguityInLayoutForCurrentView {
    if (!self.on || !self.currentView)
        return;
    [self exerciseAmbiguityInLayoutForView:self.currentView];
}

- (void)moveUpInViewHierarchy {
    if (!self.on || !self.currentView)
        return;
    
    if (self.currentView.superview)
    {
        [self selectView:self.currentView.superview];
    }
    else
    {
        NSLog(@"DCIntrospect-ARC: At top of view hierarchy.");
    }
}

- (void)moveBackInViewHierarchy {
    if (!self.on || !self.currentView || self.currentViewHistory.count == 0)
        return;
    
    NSUInteger indexOfCurrentView = [self.currentViewHistory indexOfObject:self.currentView];
    if (indexOfCurrentView == 0)
    {
        NSLog(@"DCIntrospect-ARC: At bottom of view history.");
        return;
    }
    
    [self selectView:[self.currentViewHistory objectAtIndex:indexOfCurrentView - 1]];
}

- (void)moveDownToFirstSubview {
    if (!self.on || !self.currentView)
        return;
    
    if (self.currentView.subviews.count>0) {
        [self selectView:[self.currentView.subviews objectAtIndex:0]];
    } else{
        NSLog(@"DCIntrospect-ARC: No subviews.");
    }
}

- (void)moveToNextSiblingView {
    if (!self.on || !self.currentView)
        return;
    
    NSUInteger currentViewsIndex = [self.currentView.superview.subviews indexOfObject:self.currentView];
    
    if (currentViewsIndex==NSNotFound) {
        NSLog(@"DCIntrospect-ARC: BROKEN HIERARCHY.");
    } else if (self.currentView.superview.subviews.count>currentViewsIndex + 1) {
        [self selectView:[self.currentView.superview.subviews objectAtIndex:currentViewsIndex + 1]];
    } else{
        NSLog(@"DCIntrospect-ARC: No next sibling views.");
    }
}

- (void)moveToPrevSiblingView {
    if (!self.on || !self.currentView)
        return;
    
    NSUInteger currentViewsIndex = [self.currentView.superview.subviews indexOfObject:self.currentView];
    if (currentViewsIndex==NSNotFound) {
        NSLog(@"DCIntrospect-ARC: BROKEN HIERARCHY.");
    } else if (currentViewsIndex!=0) {
        [self selectView:[self.currentView.superview.subviews objectAtIndex:currentViewsIndex - 1]];
    } else {
        NSLog(@"DCIntrospect-ARC: No previous sibling views.");
    }
}

- (void)enterGDB {
    if (!self.on || !self.currentView)
        return;
    
    UIView *view = self.currentView;
    view.tag = view.tag;	// suppress the xcode warning about an unused variable.
    NSLog(@"DCIntrospect-ARC: access current view using local 'view' variable.");
    DEBUGGER;
}

- (void)manipulateFrame:(FrameManipulation)manipulation withBigStep:(BOOL)bigstep {
    if (!self.on || !self.currentView)
        return;
    
    CGRect frame = self.currentView.frame;
    CGFloat commandOffset = bigstep ? 10.0f : 1.0f;
    
    switch (manipulation) {
        case FrameManipulationNudgeLeft:
            frame.origin.x -= commandOffset;
            break;
        case FrameManipulationNudgeRight:
            frame.origin.x += commandOffset;
            break;
        case FrameManipulationNudgeUp:
            frame.origin.y -= commandOffset;
            break;
        case FrameManipulationNudgeDown:
            frame.origin.y += commandOffset;
            break;
        case FrameManipulationCenterInSuperview:
            frame = CGRectMake(floorf((self.currentView.superview.frame.size.width - frame.size.width) / 2.0f),
                               floorf((self.currentView.superview.frame.size.height - frame.size.height) / 2.0f),
                               frame.size.width,
                               frame.size.height);
            break;
        case FrameManipulationIncreaseWidth:
            frame.size.width += commandOffset;
            break;
        case FrameManipulationDecreaseWidth:
            frame.size.width -= commandOffset;
            break;
        case FrameManipulationIncreaseHeight:
            frame.size.height += commandOffset;
            break;
        case FrameManipulationDecreaseHeight:
            frame.size.height -= commandOffset;
            break;
        case FrameManipulationIncreaseAlpha:
            if (self.currentView.alpha < 1.0f)
                self.currentView.alpha += 0.05f;
            break;
        case FrameManipulationDecreaseAlpha:
            if (self.currentView.alpha > 0.0f)
                self.currentView.alpha -= 0.05f;
            break;
        default:
            break;
    }
    
    self.currentView.frame = CGRectMake(floorf(frame.origin.x),
                                        floorf(frame.origin.y),
                                        floorf(frame.size.width),
                                        floorf(frame.size.height));
    
    [self updateFrameView];
    [self updateStatusBar];
}

#pragma mark Description Methods

- (NSString *)describeProperty:(NSString *)propertyName value:(id)value
{
	if ([propertyName isEqualToString:@"contentMode"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIViewContentModeScaleToFill";
			case 1: return @"UIViewContentModeScaleAspectFit";
			case 2: return @"UIViewContentModeScaleAspectFill";
			case 3: return @"UIViewContentModeRedraw";
			case 4: return @"UIViewContentModeCenter";
			case 5: return @"UIViewContentModeTop";
			case 6: return @"UIViewContentModeBottom";
			case 7: return @"UIViewContentModeLeft";
			case 8: return @"UIViewContentModeRight";
			case 9: return @"UIViewContentModeTopLeft";
			case 10: return @"UIViewContentModeTopRight";
			case 11: return @"UIViewContentModeBottomLeft";
			case 12: return @"UIViewContentModeBottomRight";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"textAlignment"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITextAlignmentLeft";
			case 1: return @"UITextAlignmentCenter";
			case 2: return @"UITextAlignmentRight";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"lineBreakMode"])
	{
		switch ([value intValue])
		{
			case 0: return @"UILineBreakModeWordWrap";
			case 1: return @"UILineBreakModeCharacterWrap";
			case 2: return @"UILineBreakModeClip";
			case 3: return @"UILineBreakModeHeadTruncation";
			case 4: return @"UILineBreakModeTailTruncation";
			case 5: return @"UILineBreakModeMiddleTruncation";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"activityIndicatorViewStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIActivityIndicatorViewStyleWhiteLarge";
			case 1: return @"UIActivityIndicatorViewStyleWhite";
			case 2: return @"UIActivityIndicatorViewStyleGray";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"returnKeyType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIReturnKeyDefault";
			case 1: return @"UIReturnKeyGo";
			case 2: return @"UIReturnKeyGoogle";
			case 3: return @"UIReturnKeyJoin";
			case 4: return @"UIReturnKeyNext";
			case 5: return @"UIReturnKeyRoute";
			case 6: return @"UIReturnKeySearch";
			case 7: return @"UIReturnKeySend";
			case 8: return @"UIReturnKeyYahoo";
			case 9: return @"UIReturnKeyDone";
			case 10: return @"UIReturnKeyEmergencyCall";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"keyboardAppearance"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIKeyboardAppearanceDefault";
			case 1: return @"UIKeyboardAppearanceAlert";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"keyboardType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIKeyboardTypeDefault";
			case 1: return @"UIKeyboardTypeASCIICapable";
			case 2: return @"UIKeyboardTypeNumbersAndPunctuation";
			case 3: return @"UIKeyboardTypeURL";
			case 4: return @"UIKeyboardTypeNumberPad";
			case 5: return @"UIKeyboardTypePhonePad";
			case 6: return @"UIKeyboardTypeNamePhonePad";
			case 7: return @"UIKeyboardTypeEmailAddress";
			case 8: return @"UIKeyboardTypeDecimalPad";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"autocorrectionType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIKeyboardTypeDefault";
			case 1: return @"UITextAutocorrectionTypeDefault";
			case 2: return @"UITextAutocorrectionTypeNo";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"autocapitalizationType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITextAutocapitalizationTypeNone";
			case 1: return @"UITextAutocapitalizationTypeWords";
			case 2: return @"UITextAutocapitalizationTypeSentences";
			case 3: return @"UITextAutocapitalizationTypeAllCharacters";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"clearButtonMode"] ||
			 [propertyName isEqualToString:@"leftViewMode"] ||
			 [propertyName isEqualToString:@"rightViewMode"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITextFieldViewModeNever";
			case 1: return @"UITextFieldViewModeWhileEditing";
			case 2: return @"UITextFieldViewModeUnlessEditing";
			case 3: return @"UITextFieldViewModeAlways";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"borderStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITextBorderStyleNone";
			case 1: return @"UITextBorderStyleLine";
			case 2: return @"UITextBorderStyleBezel";
			case 3: return @"UITextBorderStyleRoundedRect";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"progressViewStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UIProgressViewStyleBar";
			case 1: return @"UIProgressViewStyleDefault";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"separatorStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewCellSeparatorStyleNone";
			case 1: return @"UITableViewCellSeparatorStyleSingleLine";
			case 2: return @"UITableViewCellSeparatorStyleSingleLineEtched";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"selectionStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewCellSelectionStyleNone";
			case 1: return @"UITableViewCellSelectionStyleBlue";
			case 2: return @"UITableViewCellSelectionStyleGray";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"editingStyle"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewCellEditingStyleNone";
			case 1: return @"UITableViewCellEditingStyleDelete";
			case 2: return @"UITableViewCellEditingStyleInsert";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"accessoryType"] || [propertyName isEqualToString:@"editingAccessoryType"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewCellAccessoryNone";
			case 1: return @"UITableViewCellAccessoryDisclosureIndicator";
			case 2: return @"UITableViewCellAccessoryDetailDisclosureButton";
			case 3: return @"UITableViewCellAccessoryCheckmark";
			default: return nil;
		}
	}
	else if ([propertyName isEqualToString:@"style"])
	{
		switch ([value intValue])
		{
			case 0: return @"UITableViewStylePlain";
			case 1: return @"UITableViewStyleGrouped";
			default: return nil;
		}
		
	}
	else if ([propertyName isEqualToString:@"autoresizingMask"])
	{
		UIViewAutoresizing mask = [value intValue];
		NSMutableString *string = [NSMutableString string];
		if (mask & UIViewAutoresizingFlexibleLeftMargin)
			[string appendString:@"UIViewAutoresizingFlexibleLeftMargin"];
		if (mask & UIViewAutoresizingFlexibleRightMargin)
			[string appendString:@" | UIViewAutoresizingFlexibleRightMargin"];
		if (mask & UIViewAutoresizingFlexibleTopMargin)
			[string appendString:@" | UIViewAutoresizingFlexibleTopMargin"];
		if (mask & UIViewAutoresizingFlexibleBottomMargin)
			[string appendString:@" | UIViewAutoresizingFlexibleBottomMargin"];
		if (mask & UIViewAutoresizingFlexibleWidth)
			[string appendString:@" | UIViewAutoresizingFlexibleWidthMargin"];
		if (mask & UIViewAutoresizingFlexibleHeight)
			[string appendString:@" | UIViewAutoresizingFlexibleHeightMargin"];
		
		if ([string hasPrefix:@" | "])
			[string replaceCharactersInRange:NSMakeRange(0, 3) withString:@""];
		
		return ([string length] > 0) ? string : @"UIViewAutoresizingNone";
	}
	else if ([propertyName isEqualToString:@"accessibilityTraits"])
	{
		UIAccessibilityTraits traits = [value intValue];
		NSMutableString *string = [NSMutableString string];
		if (traits & UIAccessibilityTraitButton)
			[string appendString:@"UIAccessibilityTraitButton"];
		if (traits & UIAccessibilityTraitLink)
			[string appendString:@" | UIAccessibilityTraitLink"];
		if (traits & UIAccessibilityTraitSearchField)
			[string appendString:@" | UIAccessibilityTraitSearchField"];
		if (traits & UIAccessibilityTraitImage)
			[string appendString:@" | UIAccessibilityTraitImage"];
		if (traits & UIAccessibilityTraitSelected)
			[string appendString:@" | UIAccessibilityTraitSelected"];
		if (traits & UIAccessibilityTraitPlaysSound)
			[string appendString:@" | UIAccessibilityTraitPlaysSound"];
		if (traits & UIAccessibilityTraitKeyboardKey)
			[string appendString:@" | UIAccessibilityTraitKeyboardKey"];
		if (traits & UIAccessibilityTraitStaticText)
			[string appendString:@" | UIAccessibilityTraitStaticText"];
		if (traits & UIAccessibilityTraitSummaryElement)
			[string appendString:@" | UIAccessibilityTraitSummaryElement"];
		if (traits & UIAccessibilityTraitNotEnabled)
			[string appendString:@" | UIAccessibilityTraitNotEnabled"];
		if (traits & UIAccessibilityTraitUpdatesFrequently)
			[string appendString:@" | UIAccessibilityTraitUpdatesFrequently"];
		if (traits & UIAccessibilityTraitStartsMediaSession)
			[string appendString:@" | UIAccessibilityTraitStartsMediaSession"];
		if (traits & UIAccessibilityTraitAdjustable)
			[string appendFormat:@" | UIAccessibilityTraitAdjustable"];
		if ([string hasPrefix:@" | "])
			[string replaceCharactersInRange:NSMakeRange(0, 3) withString:@""];
		
		return ([string length] > 0) ? string : @"UIAccessibilityTraitNone";
	}
	
	if ([value isKindOfClass:[NSValue class]])
	{
		// print out the return for each value depending on type
		NSString *type = [NSString stringWithUTF8String:[value objCType]];
		if ([type isEqualToString:@"c"])
		{
			return ([value boolValue]) ? @"YES" : @"NO";
		}
		else if ([type isEqualToString:@"{CGSize=ff}"])
		{
			CGSize size = [value CGSizeValue];
			return CGSizeEqualToSize(size, CGSizeZero) ? @"CGSizeZero" : NSStringFromCGSize(size);
		}
		else if ([type isEqualToString:@"{UIEdgeInsets=ffff}"])
		{
			UIEdgeInsets edgeInsets = [value UIEdgeInsetsValue];
			return UIEdgeInsetsEqualToEdgeInsets(edgeInsets, UIEdgeInsetsZero) ? @"UIEdgeInsetsZero" : NSStringFromUIEdgeInsets(edgeInsets);
		}
	}
	else if ([value isKindOfClass:[UIColor class]])
	{
		UIColor *color = (UIColor *)value;
		return [self describeColor:color];
	}
	else if ([value isKindOfClass:[UIFont class]])
	{
		UIFont *font = (UIFont *)value;
		return [NSString stringWithFormat:@"%.0fpx %@", font.pointSize, font.fontName];
	}
	
	return value ? [value description] : @"nil";
}

- (NSString *)describeColor:(UIColor *)color
{
	if (!color)
		return @"nil";
	
	NSString *returnString = nil;
	if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelRGB)
	{
		const CGFloat *components = CGColorGetComponents(color.CGColor);
		returnString = [NSString stringWithFormat:@"R: %.0f G: %.0f B: %.0f A: %.2f",
						components[0] * 256,
						components[1] * 256,
						components[2] * 256,
						components[3]];
	}
	else
	{
		returnString = [NSString stringWithFormat:@"%@ (incompatible color space)", color];
	}
	return returnString;
}

#pragma mark DCIntrospector Help

- (void)toggleHelp
{
    if (!self.on)
		return;
    
	UIWindow *mainWindow = [self mainWindow];
	self.showingHelp = !self.showingHelp;
	
	if (self.showingHelp)
	{
		self.statusBarOverlay.leftLabel.text = @"Help";
		self.statusBarOverlay.rightLabel.text = [NSString stringWithFormat:@"'%@' or 'c' to close",kDCIntrospectKeysToggleHelp];
		UIView *backingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWindow.frame.size.width, mainWindow.frame.size.height)];
		backingView.tag = 1548;
		backingView.alpha = 0;
		backingView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.85f];
		[mainWindow addSubview:backingView];
		
		UIWebView *webView = [[UIWebView alloc] initWithFrame:backingView.frame];
		webView.opaque = NO;
		webView.backgroundColor = [UIColor clearColor];
		webView.delegate = self;
		[backingView addSubview:webView];
		
		NSMutableString *helpString = [NSMutableString stringWithString:@"<html>"];
		[helpString appendString:@"<head><style>"];
		[helpString appendString:@"body { background-color:rgba(0, 0, 0, 0.0); font:10pt helvetica; line-height: 15px margin-left:5px; margin-right:5px; margin-top:20px; color:rgb(240, 240, 240); } a { color:#45e0fe; font-weight:bold; } h1 { width:100%; font-size:14pt; border-bottom: 1px solid white; margin-top:22px; } h2 { font-size:11pt; margin-left:3px; margin-bottom:2px; } .name { margin-left:7px; } .key { float:right; margin-right:7px; } .key, .code { font-family:Courier; font-weight:bold; color:#CE8B39; } .spacer { height:10px; } p { margin-left: 7px; margin-right: 7px; }"];
		
		if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
			[helpString appendString:@"body { font-size:11pt; width:500px; margin:0 auto; }"];
		
		[helpString appendString:@"</style></head><body><h1>DCIntrospect-ARC</h1>"];
		[helpString appendString:@"<p>Created  by <a href='http://lukaswelte.de'>Lukas Welte</a> 2013.</p>"];
		[helpString appendString:@"<p>More info and full documentation: <a href='http://logicreative.github.io/DCIntrospect-ARC/'>logicreative.github.io/DCIntrospect-ARC/</a></p>"];
		[helpString appendString:@"<p>GitHub project: <a href='https://github.com/logicreative/DCIntrospect-ARC'>github.com/logicreative/DCIntrospect-ARC/</a></p>"];
		[helpString appendString:@"<p>Forked from <a href='https://github.com/logicreative/DCIntrospect'>DCIntrospect</a></p>"];
		
		[helpString appendString:@"<div class='bindings'><h1>Key Bindings</h1>"];
		[helpString appendString:@"<p>Edit DCIntrospectSettings.h to change key bindings.</p>"];
		
		[helpString appendString:@"<h2>General</h2>"];
		
		[helpString appendFormat:@"<div><span class='name'>Invoke Introspector</span><div class='key'>%@</div></div>", ([kDCIntrospectKeysInvoke isEqualToString:@" "]) ? @"spacebar" : kDCIntrospectKeysInvoke];
		[helpString appendFormat:@"<div><span class='name'>Toggle View Outlines</span><div class='key'>%@</div></div>", kDCIntrospectKeysToggleViewOutlines];
		[helpString appendFormat:@"<div><span class='name'>Toggle Highlighting Non-Opaque Views</span><div class='key'>%@</div></div>", kDCIntrospectKeysToggleNonOpaqueViews];
		[helpString appendFormat:@"<div><span class='name'>Toggle Highlighting Ambiguous Layouts</span><div class='key'>%@</div></div>", kDCIntrospectKeysToggleAmbiguousLayouts];

		[helpString appendFormat:@"<div><span class='name'>Toggle Help</span><div class='key'>%@</div></div>", kDCIntrospectKeysToggleHelp];
		[helpString appendFormat:@"<div><span class='name'>Toggle flash on <span class='code'>drawRect:</span> (see below)</span><div class='key'>%@</div></div>", kDCIntrospectKeysToggleFlashViewRedraws];
		[helpString appendFormat:@"<div><span class='name'>Toggle coordinates</span><div class='key'>%@</div></div>", kDCIntrospectKeysToggleShowCoordinates];
		[helpString appendString:@"<div class='spacer'></div>"];
		
		[helpString appendString:@"<h2>When a view is selected</h2>"];
		[helpString appendFormat:@"<div><span class='name'>Log Properties</span><div class='key'>%@</div></div>", kDCIntrospectKeysLogProperties];
		[helpString appendFormat:@"<div><span class='name'>Log Accessibility Properties</span><div class='key'>%@</div></div>", kDCIntrospectKeysLogAccessibilityProperties];
		[helpString appendFormat:@"<div><span class='name'>Log Recursive Description for View</span><div class='key'>%@</div></div>", kDCIntrospectKeysLogViewRecursive];
		[helpString appendFormat:@"<div><span class='name'>Exercise autolayout ambiguity, if any</span><div class='key'>%@</div></div>", kDCIntrospectKeysExerciseAmbiguityInLayout];
		[helpString appendFormat:@"<div><span class='name'>Log horizontal constraints affecting View</span><div class='key'>%@</div></div>", kDCIntrospectKeysConstraintsAffectingLayoutForAxisX];
		[helpString appendFormat:@"<div><span class='name'>Log vertical constraints affecting View</span><div class='key'>%@</div></div>", kDCIntrospectKeysConstraintsAffectingLayoutForAxisY];
		[helpString appendFormat:@"<div><span class='name'>Enter GDB</span><div class='key'>%@</div></div>", kDCIntrospectKeysEnterGDB];
		[helpString appendFormat:@"<div><span class='name'>Move up in view hierarchy</span><div class='key'>%@</div></div>", ([kDCIntrospectKeysMoveUpInViewHierarchy isEqualToString:@""]) ? @"page up" : kDCIntrospectKeysMoveUpInViewHierarchy];
		[helpString appendFormat:@"<div><span class='name'>Move back down in view hierarchy</span><div class='key'>%@</div></div>", ([kDCIntrospectKeysMoveBackInViewHierarchy isEqualToString:@""]) ? @"page down" : kDCIntrospectKeysMoveBackInViewHierarchy];
		[helpString appendString:@"<div class='spacer'></div>"];
		
		[helpString appendFormat:@"<div><span class='name'>Nudge Left</span><div class='key'>\uE235 / %@</div></div>", kDCIntrospectKeysNudgeViewLeft];
		[helpString appendFormat:@"<div><span class='name'>Nudge Right</span><div class='key'>\uE234 / %@</div></div>", kDCIntrospectKeysNudgeViewRight];
		[helpString appendFormat:@"<div><span class='name'>Nudge Up</span><div class='key'>\uE232 / %@</div></div>", kDCIntrospectKeysNudgeViewUp];
		[helpString appendFormat:@"<div><span class='name'>Nudge Down</span><div class='key'>\uE233 / %@</div></div>", kDCIntrospectKeysNudgeViewDown];
		[helpString appendFormat:@"<div><span class='name'>Center in Superview</span><div class='key'>%@</div></div>", kDCIntrospectKeysCenterInSuperview];
		[helpString appendFormat:@"<div><span class='name'>Increase Width</span><div class='key'>alt + \uE234 / %@</div></div>", kDCIntrospectKeysIncreaseWidth];
		[helpString appendFormat:@"<div><span class='name'>Decrease Width</span><div class='key'>alt + \uE235 / %@</div></div>", kDCIntrospectKeysDecreaseWidth];
		[helpString appendFormat:@"<div><span class='name'>Increase Height</span><div class='key'>alt + \uE233 / %@</div></div>", kDCIntrospectKeysIncreaseHeight];
		[helpString appendFormat:@"<div><span class='name'>Decrease Height</span><div class='key'>alt + \uE232 / %@</div></div>", kDCIntrospectKeysDecreaseHeight];
		[helpString appendFormat:@"<div><span class='name'>Increase Alpha</span><div class='key'>%@</div></div>", kDCIntrospectKeysIncreaseViewAlpha];
		[helpString appendFormat:@"<div><span class='name'>Decrease Alpha</span><div class='key'>%@</div></div>", kDCIntrospectKeysDecreaseViewAlpha];
		[helpString appendFormat:@"<div><span class='name'>Log view code</span><div class='key'>%@</div></div>", kDCIntrospectKeysLogCodeForCurrentViewChanges];
		[helpString appendString:@"<div class='spacer'></div>"];
		
		[helpString appendFormat:@"<div><span class='name'>Call setNeedsDisplay</span><div class='key'>%@</div></div>", kDCIntrospectKeysSetNeedsDisplay];
		[helpString appendFormat:@"<div><span class='name'>Call setNeedsLayout</span><div class='key'>%@</div></div>", kDCIntrospectKeysSetNeedsLayout];
		[helpString appendFormat:@"<div><span class='name'>Call reloadData (UITableView only)</span><div class='key'>%@</div></div>", kDCIntrospectKeysReloadData];
		[helpString appendString:@"</div>"];
		
		[helpString appendFormat:@"<h1>GDB</h1><p>Push <span class='code'>%@</span> (backtick) to jump into GDB.  The currently selected view will be available as a variable named 'view'.</p>", kDCIntrospectKeysEnterGDB];
		
		[helpString appendFormat:@"<h1>Flash on <span class='code'>drawRect:</span> calls</h1><p>To implement, call <span class='code'>[[DCIntrospect sharedIntrospector] flashRect:inView:]</span> inside the <span class='code'>drawRect:</span> method of any view you want to track.</p><p>When Flash on <span class='code'>drawRect:</span> is toggled on (binding: <span class='code'>%@</span>) the view will flash whenever <span class='code'>drawRect:</span> is called.</p>", kDCIntrospectKeysToggleFlashViewRedraws];
		
		[helpString appendFormat:@"<h1>Naming objects & logging code</h1><p>By providing names for objects using <span class='code'>setName:forObject:accessedWithSelf:</span>, that name will be shown in the status bar instead of the class of the view.</p><p>This is also used when logging view code (binding: <span class='code'>%@</span>).  Logging view code prints formatted code to the console for properties that have been changed.</p><p>For example, if you resize/move a view using the nudge keys, logging the view code will print <span class='code'>view.frame = CGRectMake(50.0 ..etc);</span> to the console.  If a name is provided then <span class='code'>view</span> is replaced by the name.</p>", kDCIntrospectKeysLogCodeForCurrentViewChanges];
		
		[helpString appendString:@"<h1>License</h1><p>DCIntrospect is made available under the <a href='http://en.wikipedia.org/wiki/MIT_License'>MIT license</a>.</p>"];
		
		[helpString appendString:@"<h2 style='text-align:center;'><a href='http://close'>Close Help</h2>"];
		[helpString appendString:@"<div class='spacer'></div>"];
		
		[UIView animateWithDuration:0.1
						 animations:^{
							 backingView.alpha = 1.0f;
						 } completion:^(BOOL finished) {
							 [webView loadHTMLString:helpString baseURL:nil];
						 }];
	}
	else
	{
		UIView *backingView = (UIView *)[mainWindow viewWithTag:1548];
		[UIView animateWithDuration:0.1
						 animations:^{
							 backingView.alpha = 0;
						 } completion:^(BOOL finished) {
							 [backingView removeFromSuperview];
						 }];
		[self updateStatusBar];
	}
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSString *requestString = [[request URL] absoluteString];
	if ([requestString isEqualToString:@"about:blank"])
		return YES;
	else if ([requestString isEqualToString:@"http://close/"])
		[self toggleHelp];
	else
		[[UIApplication sharedApplication] openURL:[request URL]];
	
	return NO;
}

#pragma mark Experimental

- (void)logPropertiesForCurrentView
{
    if (!self.on || !self.currentView)
        return;
    
	[self logPropertiesForObject:self.currentView];
}

- (void)logPropertiesForObject:(id)object
{
	Class objectClass = [object class];
	NSString *className = [NSString stringWithFormat:@"%@", objectClass];
	
	unsigned int count;
	objc_property_t *properties = class_copyPropertyList(objectClass, &count);
    size_t buf_size = 1024;
    char *buffer = malloc(buf_size);
	NSMutableString *outputString = [NSMutableString stringWithFormat:@"\n\n** %@", className];
	
	// list the class heirachy
	Class superClass = [objectClass superclass];
	while (superClass)
	{
		[outputString appendFormat:@" : %@", superClass];
		superClass = [superClass superclass];
	}
	
	[outputString appendString:@" ** \n\n"];
	
	if ([objectClass isSubclassOfClass:UIView.class])
	{
		UIView *view = (UIView *)object;
		// print out generic uiview properties
		[outputString appendString:@"  ** UIView properties **\n"];
		[outputString appendFormat:@"    tag: %ld\n", (long)view.tag];
		[outputString appendFormat:@"    frame: %@ | ", NSStringFromCGRect(view.frame)];
		[outputString appendFormat:@"bounds: %@ | ", NSStringFromCGRect(view.bounds)];
		[outputString appendFormat:@"center: %@\n", NSStringFromCGPoint(view.center)];
		[outputString appendFormat:@"    transform: %@\n", NSStringFromCGAffineTransform(view.transform)];
		[outputString appendFormat:@"    autoresizingMask: %@\n", [self describeProperty:@"autoresizingMask" value:[NSNumber numberWithInt:view.autoresizingMask]]];
		[outputString appendFormat:@"    autoresizesSubviews: %@\n", (view.autoresizesSubviews) ? @"YES" : @"NO"];
		[outputString appendFormat:@"    contentMode: %@ | ", [self describeProperty:@"contentMode" value:[NSNumber numberWithInt:view.contentMode]]];
		[outputString appendFormat:@"contentStretch: %@\n", NSStringFromCGRect(view.contentStretch)];
		[outputString appendFormat:@"    backgroundColor: %@\n", [self describeColor:view.backgroundColor]];
		[outputString appendFormat:@"    alpha: %.2f | ", view.alpha];
		[outputString appendFormat:@"opaque: %@ | ", (view.opaque) ? @"YES" : @"NO"];
		[outputString appendFormat:@"hidden: %@ | ", (view.hidden) ? @"YES" : @"NO"];
		[outputString appendFormat:@"clips to bounds: %@ | ", (view.clipsToBounds) ? @"YES" : @"NO"];
		[outputString appendFormat:@"clearsContextBeforeDrawing: %@\n", (view.clearsContextBeforeDrawing) ? @"YES" : @"NO"];
		[outputString appendFormat:@"    userInteractionEnabled: %@ | ", (view.userInteractionEnabled) ? @"YES" : @"NO"];
		[outputString appendFormat:@"multipleTouchEnabled: %@\n", (view.multipleTouchEnabled) ? @"YES" : @"NO"];
		[outputString appendFormat:@"    gestureRecognizers: %@\n", (view.gestureRecognizers) ? [view.gestureRecognizers description] : @"nil"];
		
		[outputString appendString:@"\n"];
	}
	
	[outputString appendFormat:@"  ** %@ properties **\n", objectClass];
	
	if (objectClass == UIScrollView.class || objectClass == UIButton.class)
	{
		[outputString appendString:@"    Logging properties not currently supported for this view.\n"];
	}
	else
	{
		
		for (unsigned int i = 0; i < count; ++i)
		{
			// get the property name and selector name
			NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
			
			SEL sel = NSSelectorFromString(propertyName);
			if ([object respondsToSelector:sel])
			{
				NSString *propertyDescription;
				@try
				{
					// get the return object and type for the selector
					NSString *returnType = [NSString stringWithUTF8String:[[object methodSignatureForSelector:sel] methodReturnType]];
					id returnObject = [object valueForKey:propertyName];
					if ([returnType isEqualToString:@"c"])
						returnObject = [NSNumber numberWithBool:[returnObject intValue] != 0];
					
					propertyDescription = [self describeProperty:propertyName value:returnObject];
				}
				@catch (NSException *exception)
				{
					// Non KVC compliant properties, see also +workaroundUITextInputTraitsPropertiesBug
					propertyDescription = @"N/A";
				}
				[outputString appendFormat:@"    %@: %@\n", propertyName, propertyDescription];
			}
		}
	}
	
	// list targets if there are any
	if ([object respondsToSelector:@selector(allTargets)])
	{
		[outputString appendString:@"\n  ** Targets & Actions **\n"];
		UIControl *control = (UIControl *)object;
		UIControlEvents controlEvents = [control allControlEvents];
		NSSet *allTargets = [control allTargets];
		[allTargets enumerateObjectsUsingBlock:^(id target, BOOL *stop)
		 {
			 NSArray *actions = [control actionsForTarget:target forControlEvent:controlEvents];
			 [actions enumerateObjectsUsingBlock:^(id action, NSUInteger idx, BOOL *stop2)
			  {
				  [outputString appendFormat:@"    target: %@ action: %@\n", target, action];
			  }];
		 }];
	}
	
	[outputString appendString:@"\n"];
	NSLog(@"DCIntrospect-ARC: %@", outputString);
	
	free(properties);
    free(buffer);
}

- (void)logAccessabilityPropertiesForObject:(id)object
{
	Class objectClass = [object class];
	NSString *className = [NSString stringWithFormat:@"%@", objectClass];
	NSMutableString *outputString = [NSMutableString string];
	
	// warn about accessibility inspector if the element count is zero
	NSUInteger count = [object accessibilityElementCount];
	if (count == 0)
		[outputString appendString:@"\n\n** Warning: Logging accessibility properties requires Accessibility Inspector: Settings.app -> General -> Accessibility\n"];
	
	[outputString appendFormat:@"** %@ Accessibility Properties **\n", className];
	[outputString appendFormat:@"     label: %@\n", [object accessibilityLabel]];
    if ([object respondsToSelector:@selector(accessibilityIdentifier)]) {
        [outputString appendFormat:@"identifier: %@\n", [object accessibilityIdentifier]];
    }
	[outputString appendFormat:@"      hint: %@\n", [object accessibilityHint]];
	[outputString appendFormat:@"    traits: %@\n", [self describeProperty:@"accessibilityTraits" value:[NSNumber numberWithUnsignedLongLong:[object accessibilityTraits]]]];
	[outputString appendFormat:@"     value: %@\n", [object accessibilityValue]];
	[outputString appendFormat:@"     frame: %@\n", NSStringFromCGRect([object accessibilityFrame])];
	[outputString appendString:@"\n"];
	
	NSLog(@"DCIntrospect-ARC: %@", outputString);
}

- (NSArray *)subclassesOfClass:(Class)parentClass
{
	// thanks to Matt Gallagher:
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
	
//    classes = malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
	
    NSMutableArray *result = [NSMutableArray array];
    if (classes != NULL) {
        
        for (NSInteger i = 0; i < numClasses; i++)
        {
            
            Class superClass = classes[i];
            do
            {
                superClass = class_getSuperclass(superClass);
            } while(superClass && superClass != parentClass);
            
            if (superClass == nil)
            {
                continue;
            }
            
            [result addObject:classes[i]];
        }
        
        free(classes);
    }
    	
    classes = NULL;
	
    return result;
}

#pragma mark Helper Methods

- (UIWindow *)mainWindow
{
	NSArray *windows = [[UIApplication sharedApplication] windows];
	if (windows.count == 0)
		return nil;
	
	return [windows objectAtIndex:0];
}

- (NSMutableArray *)viewsAtPoint:(CGPoint)touchPoint inView:(UIView *)view
{
	NSMutableArray *views = [[NSMutableArray alloc] init];
	
	if ([view pointInside:touchPoint withEvent:nil])
	{
	   [views addObject:view];
	   
	   for (UIView *subview in view.subviews)
	   {
	       if ([self shouldIgnoreView:subview])
	           continue;
	       
	       CGPoint convertedTouchPoint = [view convertPoint:touchPoint toView:subview];
	       
	       [views addObjectsFromArray:[self viewsAtPoint:convertedTouchPoint inView:subview]];
	   }
	}
	
	return views;
}

- (void)fadeView:(UIView *)view toAlpha:(CGFloat)alpha
{
	[UIView animateWithDuration:0.1
						  delay:0.0
						options:UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 view.alpha = alpha;
					 }
					 completion:nil];
}

- (BOOL)view:(UIView *)view containsSubview:(UIView *)subview
{
	for (UIView *aView in view.subviews)
	{
		if (aView == subview)
			return YES;
		
		if ([self view:aView containsSubview:subview])
			return YES;
	}
	
	return NO;
}

- (BOOL)shouldIgnoreView:(UIView *)view
{
	if (view == self.frameView || view == self.inputTextView)
		return YES;
	return NO;
}

BOOL iOS7OrHigher() {
    NSString *osVersion = @"7.0";
    NSString *currOsVersion = [[UIDevice currentDevice] systemVersion];
    NSComparisonResult compareResult =  [currOsVersion compare:osVersion options:NSNumericSearch];
    return compareResult == NSOrderedDescending || compareResult == NSOrderedSame;
}

@end
