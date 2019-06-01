//
//  ScoreInfo.m
//  MinnieManager
//
//  Created by songzhen on 2019/6/1.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "ScoreInfo.h"

@implementation ScoreInfo

-(NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"score":@"score",
             @"avatar":@"avatar",
             @"userId":@"userId",
             @"nickName":@"nickName"
             };
}
@end
