//
//  UpdateTeacherRequest.m
//  X5Teacher
//
//  Created by yebw on 2017/12/19.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "UpdateTeacherRequest.h"

@interface UpdateTeacherRequest()

@property (nonatomic, strong) NSDictionary *infos;

@end


@implementation UpdateTeacherRequest

- (instancetype)initWithInfos:(NSDictionary *)infos {
    self = [super init];
    if (self != nil) {
        _infos = infos;
    }

    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/teacher/create", ServerProjectName];
}

- (id)requestArgument {
    return self.infos;
}

@end

