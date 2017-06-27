///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGEnableDisableChangePolicy;
@class DBTEAMLOGGoogleSsoChangePolicyDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `GoogleSsoChangePolicyDetails` struct.
///
/// Enabled or disabled Google single sign-on for the team.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGGoogleSsoChangePolicyDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// New Google single sign-on policy.
@property (nonatomic, readonly) DBTEAMLOGEnableDisableChangePolicy *dNewValue;

/// Previous Google single sign-on policy. Might be missing due to historical
/// data gap.
@property (nonatomic, readonly, nullable) DBTEAMLOGEnableDisableChangePolicy *previousValue;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param dNewValue New Google single sign-on policy.
/// @param previousValue Previous Google single sign-on policy. Might be missing
/// due to historical data gap.
///
/// @return An initialized instance.
///
- (instancetype)initWithDNewValue:(DBTEAMLOGEnableDisableChangePolicy *)dNewValue
                    previousValue:(nullable DBTEAMLOGEnableDisableChangePolicy *)previousValue;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param dNewValue New Google single sign-on policy.
///
/// @return An initialized instance.
///
- (instancetype)initWithDNewValue:(DBTEAMLOGEnableDisableChangePolicy *)dNewValue;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `GoogleSsoChangePolicyDetails` struct.
///
@interface DBTEAMLOGGoogleSsoChangePolicyDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGGoogleSsoChangePolicyDetails` instances.
///
/// @param instance An instance of the `DBTEAMLOGGoogleSsoChangePolicyDetails`
/// API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGGoogleSsoChangePolicyDetails` API object.
///
+ (NSDictionary *)serialize:(DBTEAMLOGGoogleSsoChangePolicyDetails *)instance;

///
/// Deserializes `DBTEAMLOGGoogleSsoChangePolicyDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGGoogleSsoChangePolicyDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGGoogleSsoChangePolicyDetails`
/// object.
///
+ (DBTEAMLOGGoogleSsoChangePolicyDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
