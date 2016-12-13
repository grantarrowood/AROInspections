///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import "DBStoneSerializers.h"
#import "DBStoneValidators.h"
#import "DBTEAMApiApp.h"
#import "DBTEAMListMemberAppsResult.h"

#pragma mark - API Object

@implementation DBTEAMListMemberAppsResult

#pragma mark - Constructors

- (instancetype)initWithLinkedApiApps:(NSArray<DBTEAMApiApp *> *)linkedApiApps {
  [DBStoneValidators arrayValidator:nil maxItems:nil itemValidator:nil](linkedApiApps);

  self = [super init];
  if (self) {
    _linkedApiApps = linkedApiApps;
  }
  return self;
}

#pragma mark - Serialization methods

+ (NSDictionary *)serialize:(id)instance {
  return [DBTEAMListMemberAppsResultSerializer serialize:instance];
}

+ (id)deserialize:(NSDictionary *)dict {
  return [DBTEAMListMemberAppsResultSerializer deserialize:dict];
}

#pragma mark - Description method

- (NSString *)description {
  return [[DBTEAMListMemberAppsResultSerializer serialize:self] description];
}

@end

#pragma mark - Serializer Object

@implementation DBTEAMListMemberAppsResultSerializer

+ (NSDictionary *)serialize:(DBTEAMListMemberAppsResult *)valueObj {
  NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];

  jsonDict[@"linked_api_apps"] = [DBArraySerializer serialize:valueObj.linkedApiApps
                                                    withBlock:^id(id elem) {
                                                      return [DBTEAMApiAppSerializer serialize:elem];
                                                    }];

  return jsonDict;
}

+ (DBTEAMListMemberAppsResult *)deserialize:(NSDictionary *)valueDict {
  NSArray<DBTEAMApiApp *> *linkedApiApps = [DBArraySerializer deserialize:valueDict[@"linked_api_apps"]
                                                                withBlock:^id(id elem) {
                                                                  return [DBTEAMApiAppSerializer deserialize:elem];
                                                                }];

  return [[DBTEAMListMemberAppsResult alloc] initWithLinkedApiApps:linkedApiApps];
}

@end
