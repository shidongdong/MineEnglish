//
//  Award.m
//  X5
//
//  Created by yebw on 2017/9/14.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "Award.h"

@implementation Award

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"awardId":@"id",
             @"name":@"name",
             @"imageUrl":@"imageUrl",
             @"price":@"price",
             @"count":@"count"};
}

@end
