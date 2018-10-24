//
//  AddClassStudentRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "AddClassStudentRequest.h"

@interface AddClassStudentRequest()

@property (nonatomic, assign) NSUInteger classId;
@property (nonatomic, strong) NSArray *studentIds;

@end

@implementation AddClassStudentRequest

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
    return [NSString stringWithFormat:@"%@/class/addStudents", ServerProjectName];
}

- (id)requestArgument {
    return @{@"classId":@(self.classId),
             @"studentIds":self.studentIds};
}

@end



