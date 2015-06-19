//
//  AVRole.h
//  AVOS Cloud
//

#import <Foundation/Foundation.h>
#import "AVObject.h"

@class AVQuery;

/*!
 Represents a Role on the AVOS Cloud server. AVRoles represent groupings
 of AVUsers for the purposes of granting permissions (e.g. specifying a
 AVACL for a AVObject). Roles are specified by their sets of child users
 and child roles, all of which are granted any permissions that the
 parent role has.<br />
 <br />
 Roles must have a name (which cannot be changed after creation of the role),
 and must specify an ACL.
 */
@interface AVRole : AVObject

#pragma mark Creating a New Role

/** @name Creating a New Role */

/*!
 Constructs a new AVRole with the given name. If no default ACL has been
 specified, you must provide an ACL for the role.
 
 @param name The name of the Role to create.
 */
- (id)initWithName:(NSString *)name;

/*!
 Constructs a new AVRole with the given name.
 
 @param name The name of the Role to create.
 @param acl The ACL for this role. Roles must have an ACL.
 */
- (id)initWithName:(NSString *)name acl:(AVACL *)acl;

/*!
 Constructs a new AVRole with the given name. If no default ACL has been
 specified, you must provide an ACL for the role.
 
 @param name The name of the Role to create.
 */
+ (AVRole *)roleWithName:(NSString *)name;

/*!
 Constructs a new AVRole with the given name.
 
 @param name The name of the Role to create.
 @param acl The ACL for this role. Roles must have an ACL.
 */
+ (AVRole *)roleWithName:(NSString *)name acl:(AVACL *)acl;

#pragma mark -
#pragma mark Role-specific Properties

/** @name Role-specific Properties */

/*!
 Gets or sets the name for a role. This value must be set before the role
 has been saved to the server, and cannot be set once the role has been
 saved.<br />
 <br />
 A role's name can only contain alphanumeric characters, _, -, and spaces.
 */
@property (nonatomic, copy) NSString *name;

/*!
 Gets the AVRelation for the AVUsers that are direct children of this role.
 These users are granted any privileges that this role has been granted
 (e.g. read or write access through ACLs). You can add or remove users from
 the role through this relation.
 
 @return the relation for the users belonging to this role.
 */
- (AVRelation *)users;

/*!
 Gets the AVRelation for the AVRoles that are direct children of this role.
 These roles' users are granted any privileges that this role has been granted
 (e.g. read or write access through ACLs). You can add or remove child roles
 from this role through this relation.
 
 @return the relation for the roles belonging to this role.
 */
- (AVRelation *)roles;

#pragma mark -
#pragma mark Querying for Roles

/** @name Querying for Roles */
+ (AVQuery *)query;

@end
