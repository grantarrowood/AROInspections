///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import "DBPROPERTIESListPropertyTemplateIds.h"
#import "DBStoneSerializers.h"
#import "DBStoneValidators.h"

#pragma mark - API Object

@implementation DBPROPERTIESListPropertyTemplateIds

#pragma mark - Constructors

- (instancetype)initWithTemplateIds:(NSArray<NSString *> *)templateIds {
  [DBStoneValidators arrayValidator:nil maxItems:nil
                      itemValidator:[DBStoneValidators stringValidator:@(1) maxLength:nil pattern:@"(/|ptid:).*"]](
      templateIds);

  self = [super init];
  if (self) {
    _templateIds = templateIds;
  }
  return self;
}

#pragma mark - Serialization methods

+ (NSDictionary *)serialize:(id)instance {
  return [DBPROPERTIESListPropertyTemplateIdsSerializer serialize:instance];
}

+ (id)deserialize:(NSDictionary *)dict {
  return [DBPROPERTIESListPropertyTemplateIdsSerializer deserialize:dict];
}

#pragma mark - Description method

- (NSString *)description {
  return [[DBPROPERTIESListPropertyTemplateIdsSerializer serialize:self] description];
}

@end

#pragma mark - Serializer Object

@implementation DBPROPERTIESListPropertyTemplateIdsSerializer

+ (NSDictionary *)serialize:(DBPROPERTIESListPropertyTemplateIds *)valueObj {
  NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];

  jsonDict[@"template_ids"] = [DBArraySerializer serialize:valueObj.templateIds
                                                 withBlock:^id(id elem) {
                                                   return elem;
                                                 }];

  return jsonDict;
}

+ (DBPROPERTIESListPropertyTemplateIds *)deserialize:(NSDictionary *)valueDict {
  NSArray<NSString *> *templateIds = [DBArraySerializer deserialize:valueDict[@"template_ids"]
                                                          withBlock:^id(id elem) {
                                                            return elem;
                                                          }];

  return [[DBPROPERTIESListPropertyTemplateIds alloc] initWithTemplateIds:templateIds];
}

@end
