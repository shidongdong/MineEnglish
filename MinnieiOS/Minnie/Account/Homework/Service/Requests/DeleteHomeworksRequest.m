//
//  DeleteHomeworkRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "DeleteHomeworksRequest.h"

@interface DeleteHomeworksRequest()

@property (nonatomic, strong) NSArray<NSNumber *> *homeworkIds;

@end

@implementation DeleteHomeworksRequest

- (instancetype)initWithHomeworkIds:(NSArray<NSNumber *> *)homeworkIds {
    self = [super init];
    if (self != nil) {
        _homeworkIds = homeworkIds;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/delete", ServerProjectName];
}

- (id)requestArgument {
    NSMutableArray *ids = [NSMutableArray array];
    for (NSNumber *number in self.homeworkIds) {
        [ids addObject:number];
    }

    return @{@"ids":ids};
}


@end
