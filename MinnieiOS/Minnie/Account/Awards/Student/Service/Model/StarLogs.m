//
//  StarRecordModel.m
//  MinnieStudent
//
//  Created by songzhen on 2019/5/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "StarLogs.h"

@implementation StarLogs

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"list":@"list"};
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    
    if ([key isEqualToString:@"list"]) {
        
        return [MTLJSONAdapter arrayTransformerWithModelClass:[DayStarLogDetail class]];
    }
    return nil;
}

@end

@implementation DayStarLogDetail

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{@"dayStarSum":@"dayStarSum",
             @"starLogDate":@"starLogDate",
             @"starLogs":@"starLogs"};
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    
    if ([key isEqualToString:@"starLogs"]) {
        
        return [MTLJSONAdapter arrayTransformerWithModelClass:[StarLogDetail class]];
    }
    return nil;
}

@end

@implementation StarLogDetail

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{@"starLogDesc":@"starLogDesc",
             @"starCount":@"starCount"};
}

@end
