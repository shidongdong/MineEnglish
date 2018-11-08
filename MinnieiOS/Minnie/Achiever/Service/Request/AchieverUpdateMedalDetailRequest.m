//
//  AchieverUpdateMedalDetailRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/6.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "AchieverUpdateMedalDetailRequest.h"

@interface AchieverUpdateMedalDetailRequest()

@property(nonatomic,assign)NSInteger medalId;
@property(nonatomic,strong)NSString * type;
@property(nonatomic,assign)NSInteger flag;
@end

@implementation AchieverUpdateMedalDetailRequest

- (instancetype)initWithMedalId:(NSInteger)medalid
                      medalType:(NSString *)type
                           flag:(NSInteger)flag {
    self = [super init];
    if (self != nil) {
        _medalId = medalid;
        _type = type;
        _flag = flag;
    }
    return self;
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/medal/updateMedalFlag", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.medalId),
             @"medalType":self.type,
             @"flag":@(self.flag)};
}

@end
