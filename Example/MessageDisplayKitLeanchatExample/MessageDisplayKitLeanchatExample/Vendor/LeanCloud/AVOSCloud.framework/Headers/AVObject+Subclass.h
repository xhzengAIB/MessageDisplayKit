//
//  AVObject+Subclass.h
//  paas
//
//  Created by Summer on 13-4-2.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import "AVObject.h"

@class AVQuery;

/*!
 <h3>Subclassing Notes</h3>
 
 Developers can subclass AVObject for a more native object-oriented class structure. Strongly-typed subclasses of AVObject must conform to the AVSubclassing protocol and must call registerSubclass to be returned by AVQuery and other AVObject factories. All methods in AVSubclassing except for [AVSubclassing parseClassName] are already implemented in the AVObject(Subclass) category. Inculding AVObject+Subclass.h in your implementation file provides these implementations automatically.
 
 Subclasses support simpler initializers, query syntax, and dynamic synthesizers. The following shows an example subclass:
 
 ```
 @interface MYGame : AVObject< AVSubclassing >
 // Accessing this property is the same as objectForKey:@"title"
 @property (retain) NSString *title;
 + (NSString *)parseClassName;
 @end
 
 @implementation MYGame
 @dynamic title;
 + (NSString *)parseClassName {
 return @"Game";
 }
 @end
 
 MYGame *game = [[MYGame alloc] init];
 game.title = @"Bughouse";
 [game saveInBackground];
 ```
 
 */
@interface AVObject(Subclass)

///*! @name Methods for Subclasses */
//
///*!
// Designated initializer for subclasses.
// This method can only be called on subclasses which conform to AVSubclassing.
// This method should not be overridden.
// */
//- (id)init;

/*!
 Creates an instance of the registered subclass with this class's parseClassName.
 This helps a subclass ensure that it can be subclassed itself. For example, [AVUser object] will
 return a MyUser object if MyUser is a registered subclass of AVUser. For this reason, [MyClass object] is
 preferred to [[MyClass alloc] init].
 This method can only be called on subclasses which conform to AVSubclassing.
 A default implementation is provided by AVObject which should always be sufficient.
 */
+ (instancetype)object;

/*!
 Creates a reference to an existing AVObject for use in creating associations between AVObjects.  Calling isDataAvailable on this
 object will return NO until fetchIfNeeded or refresh has been called.  No network request will be made.
 This method can only be called on subclasses which conform to AVSubclassing.
 A default implementation is provided by AVObject which should always be sufficient.
 @param objectId The object id for the referenced object.
 @return A AVObject without data.
 */
+ (instancetype)objectWithoutDataWithObjectId:(NSString *)objectId;

/*!
 Registers an Objective-C class for LeanCloud to use for representing a given LeanCloud class.
 Once this is called on a AVObject subclass, any AVObject LeanCloud creates with a class
 name matching [self parseClassName] will be an instance of subclass.
 This method can only be called on subclasses which conform to AVSubclassing.
 A default implementation is provided by AVObject which should always be sufficient.
 */
+ (void)registerSubclass;

/*!
 Returns a query for objects of type +parseClassName.
 This method can only be called on subclasses which conform to AVSubclassing.
 A default implementation is provided by AVObject which should always be sufficient.
 */
+ (AVQuery *)query;

@end
