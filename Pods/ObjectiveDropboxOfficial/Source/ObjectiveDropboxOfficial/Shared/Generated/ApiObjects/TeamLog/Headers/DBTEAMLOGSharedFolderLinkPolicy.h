///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGSharedFolderLinkPolicy;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `SharedFolderLinkPolicy` union.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGSharedFolderLinkPolicy : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The `DBTEAMLOGSharedFolderLinkPolicyTag` enum type represents the possible
/// tag states with which the `DBTEAMLOGSharedFolderLinkPolicy` union can exist.
typedef NS_ENUM(NSInteger, DBTEAMLOGSharedFolderLinkPolicyTag) {
  /// (no description).
  DBTEAMLOGSharedFolderLinkPolicyMembersOnly,

  /// (no description).
  DBTEAMLOGSharedFolderLinkPolicyMembersAndTeam,

  /// (no description).
  DBTEAMLOGSharedFolderLinkPolicyAnyone,

  /// (no description).
  DBTEAMLOGSharedFolderLinkPolicyOther,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBTEAMLOGSharedFolderLinkPolicyTag tag;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "members_only".
///
/// @return An initialized instance.
///
- (instancetype)initWithMembersOnly;

///
/// Initializes union class with tag state of "members_and_team".
///
/// @return An initialized instance.
///
- (instancetype)initWithMembersAndTeam;

///
/// Initializes union class with tag state of "anyone".
///
/// @return An initialized instance.
///
- (instancetype)initWithAnyone;

///
/// Initializes union class with tag state of "other".
///
/// @return An initialized instance.
///
- (instancetype)initWithOther;

- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value "members_only".
///
/// @return Whether the union's current tag state has value "members_only".
///
- (BOOL)isMembersOnly;

///
/// Retrieves whether the union's current tag state has value
/// "members_and_team".
///
/// @return Whether the union's current tag state has value "members_and_team".
///
- (BOOL)isMembersAndTeam;

///
/// Retrieves whether the union's current tag state has value "anyone".
///
/// @return Whether the union's current tag state has value "anyone".
///
- (BOOL)isAnyone;

///
/// Retrieves whether the union's current tag state has value "other".
///
/// @return Whether the union's current tag state has value "other".
///
- (BOOL)isOther;

///
/// Retrieves string value of union's current tag state.
///
/// @return A human-readable string representing the union's current tag state.
///
- (NSString *)tagName;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DBTEAMLOGSharedFolderLinkPolicy` union.
///
@interface DBTEAMLOGSharedFolderLinkPolicySerializer : NSObject

///
/// Serializes `DBTEAMLOGSharedFolderLinkPolicy` instances.
///
/// @param instance An instance of the `DBTEAMLOGSharedFolderLinkPolicy` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGSharedFolderLinkPolicy` API object.
///
+ (NSDictionary *)serialize:(DBTEAMLOGSharedFolderLinkPolicy *)instance;

///
/// Deserializes `DBTEAMLOGSharedFolderLinkPolicy` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGSharedFolderLinkPolicy` API object.
///
/// @return An instantiation of the `DBTEAMLOGSharedFolderLinkPolicy` object.
///
+ (DBTEAMLOGSharedFolderLinkPolicy *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
