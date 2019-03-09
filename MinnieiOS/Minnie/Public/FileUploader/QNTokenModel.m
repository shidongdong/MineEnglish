//
//  QNTokenModel.m
//  Minnie
//
//  Created by 栋栋 施 on 2019/3/1.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import "QNTokenModel.h"

@implementation QNTokenModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"expires":@"expires",
             @"upToken":@"upToken",
             };
}

@end
