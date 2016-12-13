///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import "DBFILESListFolderArg.h"
#import "DBStoneSerializers.h"
#import "DBStoneValidators.h"

#pragma mark - API Object

@implementation DBFILESListFolderArg

#pragma mark - Constructors

- (instancetype)initWithPath:(NSString *)path
                          recursive:(NSNumber *)recursive
                   includeMediaInfo:(NSNumber *)includeMediaInfo
                     includeDeleted:(NSNumber *)includeDeleted
    includeHasExplicitSharedMembers:(NSNumber *)includeHasExplicitSharedMembers {
  [DBStoneValidators stringValidator:nil maxLength:nil pattern:@"(/(.|[\\r\\n])*)?|(ns:[0-9]+(/.*)?)"](path);

  self = [super init];
  if (self) {
    _path = path;
    _recursive = recursive ?: @NO;
    _includeMediaInfo = includeMediaInfo ?: @NO;
    _includeDeleted = includeDeleted ?: @NO;
    _includeHasExplicitSharedMembers = includeHasExplicitSharedMembers ?: @NO;
  }
  return self;
}

- (instancetype)initWithPath:(NSString *)path {
  return [self initWithPath:path
                            recursive:nil
                     includeMediaInfo:nil
                       includeDeleted:nil
      includeHasExplicitSharedMembers:nil];
}

#pragma mark - Serialization methods

+ (NSDictionary *)serialize:(id)instance {
  return [DBFILESListFolderArgSerializer serialize:instance];
}

+ (id)deserialize:(NSDictionary *)dict {
  return [DBFILESListFolderArgSerializer deserialize:dict];
}

#pragma mark - Description method

- (NSString *)description {
  return [[DBFILESListFolderArgSerializer serialize:self] description];
}

@end

#pragma mark - Serializer Object

@implementation DBFILESListFolderArgSerializer

+ (NSDictionary *)serialize:(DBFILESListFolderArg *)valueObj {
  NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];

  jsonDict[@"path"] = valueObj.path;
  jsonDict[@"recursive"] = valueObj.recursive;
  jsonDict[@"include_media_info"] = valueObj.includeMediaInfo;
  jsonDict[@"include_deleted"] = valueObj.includeDeleted;
  jsonDict[@"include_has_explicit_shared_members"] = valueObj.includeHasExplicitSharedMembers;

  return jsonDict;
}

+ (DBFILESListFolderArg *)deserialize:(NSDictionary *)valueDict {
  NSString *path = valueDict[@"path"];
  NSNumber *recursive = valueDict[@"recursive"] ?: @NO;
  NSNumber *includeMediaInfo = valueDict[@"include_media_info"] ?: @NO;
  NSNumber *includeDeleted = valueDict[@"include_deleted"] ?: @NO;
  NSNumber *includeHasExplicitSharedMembers = valueDict[@"include_has_explicit_shared_members"] ?: @NO;

  return [[DBFILESListFolderArg alloc] initWithPath:path
                                          recursive:recursive
                                   includeMediaInfo:includeMediaInfo
                                     includeDeleted:includeDeleted
                    includeHasExplicitSharedMembers:includeHasExplicitSharedMembers];
}

@end
