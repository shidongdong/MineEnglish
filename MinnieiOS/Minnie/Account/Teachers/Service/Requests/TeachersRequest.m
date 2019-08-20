//
//  TeachersRequest.m
//  X5Teacher
//
//  Created by yebw on 2017/12/19.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "TeachersRequest.h"

@implementation TeachersRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/teachers", ServerProjectName];
}

@end


@interface TeacherDetailRequest ()

@property (nonatomic,assign) NSInteger teacherId;

@end

@implementation TeacherDetailRequest

- (instancetype)initWithTeacherId:(NSInteger)teacherId
{
    self = [super init];
    if (self) {
        
        _teacherId = teacherId;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/teacher/teacherDetail", ServerProjectName];
}

- (id)requestArgument {//1478
    return @{@"teacherId":@(self.teacherId)};
}

@end


@implementation ALLTeachersRequest


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/teacher/getAllTeachers", ServerProjectName];
}


@end
