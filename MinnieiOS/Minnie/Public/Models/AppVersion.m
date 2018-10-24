//
//  AppVersion.m
//  MinnieStudent
//
//  Created by 栋栋 施 on 2018/9/14.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "AppVersion.h"

//@implementation AppVersionData
//
//+ (NSDictionary *)JSONKeyPathsByPropertyKey {
//    return @{@"appVersion":@"appVersion",
//             @"appName":@"appName",
//             @"upgradeType":@"upgradeType",
//             @"appUrl":@"appUrl",
//             };
//}
//
//@end

@implementation AppVersion


//+ (NSDictionary *)JSONKeyPathsByPropertyKey {
//    return @{@"data":@"data",
//             };
//}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"upgradeDes":@"upgradeDes",
             @"appVersion":@"appVersion",
             @"appName":@"appName",
             @"upgradeType":@"upgradeType",
             @"appUrl":@"appUrl",
             };
}

//+ (NSValueTransformer *)dataJSONTransformer {
//    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[AppVersionData class]];
//}


@end
