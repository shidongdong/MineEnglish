//
//  User.m
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"userId":@"id",
             @"username":@"username",
             @"nickname":@"nickname",
             @"phoneNumber":@"phoneNumber",
             @"gender":@"gender",
             @"avatarUrl":@"avatarUrl",
             @"token":@"token",
             };
}

@end

