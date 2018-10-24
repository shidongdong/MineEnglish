//
//  DeleteTeacherRequest.m
//  X5Teacher
//
//  Created by yebw on 2017/12/19.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "DeleteTeacherRequest.h"

@interface DeleteTeacherRequest()

@property (nonatomic, assign) NSUInteger teacherId;

@end

@implementation DeleteTeacherRequest

- (instancetype)initWithTeacherId:(NSUInteger)teacherId {
    self = [super init];
    if (self != nil) {
        _teacherId = teacherId;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    if (USING_MOCK_DATA) {
        return YTKRequestMethodGET;
    }
    
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/teacher/delete", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.teacherId)};
}


@end
