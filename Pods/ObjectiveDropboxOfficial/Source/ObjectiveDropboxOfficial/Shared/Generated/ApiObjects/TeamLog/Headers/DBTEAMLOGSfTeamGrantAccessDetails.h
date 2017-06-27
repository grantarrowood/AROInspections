///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGSfTeamGrantAccessDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `SfTeamGrantAccessDetails` struct.
///
/// Granted access to a shared folder.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGSfTeamGrantAccessDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Target asset index.
@property (nonatomic, readonly) NSNumber *targetIndex;

/// Original shared folder name.
@property (nonatomic, readonly, copy) NSString *originalFolderName;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param targetIndex Target asset index.
/// @param originalFolderName Original shared folder name.
///
/// @return An initialized instance.
///
- (instancetype)initWithTargetIndex:(NSNumber *)targetIndex originalFolderName:(NSString *)originalFolderName;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `SfTeamGrantAccessDetails` struct.
///
@interface DBTEAMLOGSfTeamGrantAccessDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGSfTeamGrantAccessDetails` instances.
///
/// @param instance An instance of the `DBTEAMLOGSfTeamGrantAccessDetails` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGSfTeamGrantAccessDetails` API object.
///
+ (NSDictionary *)serialize:(DBTEAMLOGSfTeamGrantAccessDetails *)instance;

///
/// Deserializes `DBTEAMLOGSfTeamGrantAccessDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGSfTeamGrantAccessDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGSfTeamGrantAccessDetails` object.
///
+ (DBTEAMLOGSfTeamGrantAccessDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
