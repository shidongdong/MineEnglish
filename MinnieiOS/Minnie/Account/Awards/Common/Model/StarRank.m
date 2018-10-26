//
//  StarRank.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/26.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "StarRank.h"

@implementation StarRank
-(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"starCount":@"starCount",
             @"avatar":@"avatar",
             @"userId":@"userId",
             @"nickName":@"nickName"};
}

@end
