//
//  AddAwardRequest.m
//  X5Teacher
//
//  Created by yebw on 2017/12/25.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "AddAwardRequest.h"

@interface AddAwardRequest()

@property (nonatomic, strong) NSDictionary *infos;

@end

@implementation AddAwardRequest

- (instancetype)initWithInfos:(NSDictionary *)infos {
    self = [super init];
    if (self != nil) {
        _infos = infos;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/award/create", ServerProjectName];
}

- (id)requestArgument {
    return self.infos;
}

@end
