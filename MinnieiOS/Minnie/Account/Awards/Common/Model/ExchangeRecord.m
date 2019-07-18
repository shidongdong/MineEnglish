//
//  ExchangeRecord.m
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "ExchangeRecord.h"

@implementation ExchangeRecord

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"exchangeRequestId":@"id",
             @"user":@"user",
             @"award":@"award",
             @"time":@"time",
             @"state":@"state"};
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[User class]];
}

+ (NSValueTransformer *)awardJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Award class]];
}

@end

@implementation ExchangeAwardInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"awardId":@"awardId",
             @"awardName":@"awardName",
             @"awardImageUrl":@"awardImageUrl",
             @"awardPrice":@"awardPrice",
             @"exchangeTime":@"exchangeTime",
             @"avatar":@"avatar",
             @"userId":@"userId",
             @"nickName":@"nickName",
             };
}

@end

@implementation ExchangeAwardListRecord

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"classId":@"classId",
             @"className":@"className",
             @"awardList":@"awardList",
             };
}
+ (NSValueTransformer *)awardListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ExchangeAwardInfo class]];
}

@end
