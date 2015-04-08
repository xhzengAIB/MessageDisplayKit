//
//  AVSubclassing.h
//  paas
//
//  Created by Summer on 13-4-2.
//  Copyright (c) 2013年 AVOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVQuery;

/*!
 If a subclass of AVObject conforms to AVSubclassing and calls registerSubclass, AVOS Cloud will be able to use that class as the native class for a AVOS Cloud object.

 Classes conforming to this protocol should subclass AVObject and include AVObject+Subclass.h in their implementation file. This ensures the methods in the Subclass category of AVObject are exposed in its subclasses only.
 */
@protocol AVSubclassing

@optional

/*! The name of the class as seen in the REST API. */
+ (NSString *)parseClassName;

/*!
 Constructs an object of the most specific class known to implement parseClassName.
 This method takes care to help AVObject subclasses be subclassed themselves.
 For example, [AVUser object] returns a AVUser by default but will return an
 object of a registered subclass instead if one is known.
 A default implementation is provided by AVObject which should always be sufficient.
 @return the object that is instantiated.
 */
+ (instancetype)object;

/*!
 Creates a reference to an existing AVObject for use in creating associations between AVObjects.  Calling isDataAvailable on this
 object will return NO until fetchIfNeeded or refresh has been called.  No network request will be made.
 A default implementation is provided by AVObject which should always be sufficient.
 @param objectId The object id for the referenced object.
 @return A AVObject without data.
 */
+ (instancetype)objectWithoutDataWithObjectId:(NSString *)objectId;



/*!
 Create a query which returns objects of this type.
 A default implementation is provided by AVObject which should always be sufficient.
 */
+ (AVQuery *)query;

/*!
 Lets AVOS Cloud know this class should be used to instantiate all objects with class type parseClassName.
 This method must be called before [AVOSCloud setApplicationId:clientKey:]
 */
+ (void)registerSubclass;

@end
