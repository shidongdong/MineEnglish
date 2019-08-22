//
//  ClassesRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "ClassesRequest.h"

#pragma mark - 2.5.1    获取班级列表（学生端，教师端，ipad端）
@interface ClassesRequest()

@property(nonatomic, assign) BOOL finished;
@property(nonatomic, assign) BOOL simple;
@property(nonatomic, assign) NSInteger teacherId;
@property(nonatomic, copy) NSString *nextUrl;
@property(nonatomic, copy) NSString *campusName; // Ipad端：校区名称

@end

@implementation ClassesRequest

- (instancetype)initWithFinishState:(BOOL)finished
                          teacherId:(NSInteger)teacherId
                             simple:(BOOL)simple
                         campusName:(NSString *)campusName
{
    self = [super init];
    if (self != nil) {
        _finished = finished;
        _simple = simple;
        _teacherId = teacherId;
        _campusName = campusName;
    }
    
    return self;
}

- (instancetype)initWithNextUrl:(NSString *)nextUrl {
    self = [super init];
    if (self != nil) {
        _nextUrl = nextUrl;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    if (self.nextUrl.length > 0) {
        return self.nextUrl;
    }
    
    return [NSString stringWithFormat:@"%@/class/classes", ServerProjectName];
}

- (id)requestArgument {
    if (self.nextUrl.length > 0) {
        return nil;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"finished"] = self.finished?@(1):@(0);
    dict[@"simple"] = self.simple?@(1):@(0);
    
    if (self.teacherId > 0) {
        dict[@"teacherId"] = @(self.teacherId);
    }
    if (self.campusName.length > 0) {
        dict[@"campusName"] = self.campusName;
    }
    return dict;
}

@end


#pragma mark - 2.5.2    获取班级列表new
@interface NewClassesRequest()

@property(nonatomic, assign) BOOL finished;
@property(nonatomic, assign) BOOL simple;
@property(nonatomic, assign) NSInteger teacherId;
@property(nonatomic, copy) NSString *nextUrl;
@property(nonatomic, copy) NSString *campusName; // Ipad端：校区名称

@end

@implementation NewClassesRequest

- (instancetype)initWithFinishState:(BOOL)finished
                          teacherId:(NSInteger)teacherId
                             simple:(BOOL)simple
                         campusName:(NSString *)campusName
{
    self = [super init];
    if (self != nil) {
        _finished = finished;
        _simple = simple;
        _teacherId = teacherId;
        _campusName = campusName;
    }
    
    return self;
}

- (instancetype)initWithNextUrl:(NSString *)nextUrl {
    self = [super init];
    if (self != nil) {
        _nextUrl = nextUrl;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    if (self.nextUrl.length > 0) {
        return self.nextUrl;
    }
    
    return [NSString stringWithFormat:@"%@/class/newClasses", ServerProjectName];
}

- (id)requestArgument {
    if (self.nextUrl.length > 0) {
        return nil;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"finished"] = self.finished?@(1):@(0);
    dict[@"simple"] = self.simple?@(1):@(0);
    
    if (self.teacherId > 0) {
        dict[@"teacherId"] = @(self.teacherId);
    }
    if (self.campusName.length > 0) {
        dict[@"campusName"] = self.campusName;
    }
    return dict;
}

@end



#pragma mark - 2.5.3    获取班级详情（学生端，教师端）
@interface ClassRequest()

@property (nonatomic, assign) NSUInteger classId;

@end

@implementation ClassRequest

- (instancetype)initWithClassId:(NSUInteger)classId {
    self = [super init];
    if (self != nil) {
        _classId = classId;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/class/detail", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.classId)};
}

@end


#pragma mark - 2.5.4    新建或更新班级信息（教师端）
@interface CreateOrUpdateClassRequest()

@property (nonatomic, strong) NSDictionary *dict;

@end

@implementation CreateOrUpdateClassRequest

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self != nil) {
        _dict = dict;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/class/create", ServerProjectName];
}

- (id)requestArgument {
    return self.dict;
}

@end



#pragma mark - 2.5.5    删除班级（教师端）
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


#pragma mark - 2.5.6    班级添加学生（教师端）
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



#pragma mark - 2.5.7    班级删除学生（教师端）
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


#pragma mark - 2.5.9    获取所有班级列表（设置权限用）
@implementation AllClassesRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {

    return [NSString stringWithFormat:@"%@/class/getAllclasses", ServerProjectName];
}

@end

