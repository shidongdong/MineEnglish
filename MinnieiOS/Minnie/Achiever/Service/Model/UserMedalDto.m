//
//  UserMedalDto.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/6.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "UserMedalDto.h"

@implementation UserMedalDto

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"achieverid":@"id",
             @"firstFlag":@"firstFlag",
             @"sencondFlag":@"sencondFlag",
             @"thirdFlag":@"thirdFlag",
             @"medalType":@"medalType",
             };
}

@end
