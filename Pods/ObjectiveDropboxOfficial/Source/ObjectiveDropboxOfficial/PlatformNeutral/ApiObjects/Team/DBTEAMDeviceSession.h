///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMDeviceSession;

#pragma mark - API Object

///
/// The `DeviceSession` struct.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMDeviceSession : NSObject <DBSerializable>

#pragma mark - Instance fields

/// The session id
@property (nonatomic, readonly, copy) NSString * _Nonnull sessionId;

/// The IP address of the last activity from this session
@property (nonatomic, readonly) NSString * _Nullable ipAddress;

/// The country from which the last activity from this session was made
@property (nonatomic, readonly) NSString * _Nullable country;

/// The time this session was created
@property (nonatomic, readonly) NSDate * _Nullable created;

/// The time of the last activity from this session
@property (nonatomic, readonly) NSDate * _Nullable updated;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param sessionId The session id
/// @param ipAddress The IP address of the last activity from this session
/// @param country The country from which the last activity from this session
/// was made
/// @param created The time this session was created
/// @param updated The time of the last activity from this session
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithSessionId:(NSString * _Nonnull)sessionId
                                ipAddress:(NSString * _Nullable)ipAddress
                                  country:(NSString * _Nullable)country
                                  created:(NSDate * _Nullable)created
                                  updated:(NSDate * _Nullable)updated;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param sessionId The session id
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithSessionId:(NSString * _Nonnull)sessionId;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DeviceSession` struct.
///
@interface DBTEAMDeviceSessionSerializer : NSObject

///
/// Serializes `DBTEAMDeviceSession` instances.
///
/// @param instance An instance of the `DBTEAMDeviceSession` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMDeviceSession` API object.
///
+ (NSDictionary * _Nonnull)serialize:(DBTEAMDeviceSession * _Nonnull)instance;

///
/// Deserializes `DBTEAMDeviceSession` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMDeviceSession` API object.
///
/// @return An instantiation of the `DBTEAMDeviceSession` object.
///
+ (DBTEAMDeviceSession * _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

@end
