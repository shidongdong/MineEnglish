//
//  DeleteClassStudentRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "DeleteClassStudentRequest.h"

@interface DeleteClassStudentRequest()

@property (nonatomic, assign) NSUInteger classId;
@property (nonatomic, strong) NSArray<NSNumber *> *studentIds;

@end

@implementation DeleteClassStudentRequest

- (instancetype)initWithClassId:(NSUInteger)classId
                     studentIds:(NSArray<NSNumber *> *)studentIds {
    self = [super init];
    if (self != nil) {
        _classId = classId;
        _studentIds = studentIds;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    if (USING_MOCK_DATA) {
        return YTKRequestMethodGET;
    }
    
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/class/deleteStudents", ServerProjectName];
}

- (id)requestArgument {
    if (self.studentIds == nil) {
        self.studentIds = @[];
    }
    
    return @{@"classId":@(self.classId), @"studentIds":self.studentIds};
}


@end

