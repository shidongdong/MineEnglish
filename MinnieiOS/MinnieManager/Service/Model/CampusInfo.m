//
//  CampusInfo.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/16.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "CampusInfo.h"

@implementation CampusInfo


+(NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"campusId":@"id",
             @"campusName":@"campusName"
             };
}

@end
