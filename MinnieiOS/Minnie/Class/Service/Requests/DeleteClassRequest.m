//
//  DeleteClassRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "DeleteClassRequest.h"

@interface DeleteClassRequest()

@property (nonatomic, assign) NSUInteger classId;

@end

@implementation DeleteClassRequest

- (instancetype)initWithClassId:(NSUInteger)classId {
    self = [super init];
    if (self != nil) {
        _classId = classId;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/class/delete", ServerProjectName];
}

- (id)requestArgument {
    return @{@"classId":@(self.classId)};
}

@end

