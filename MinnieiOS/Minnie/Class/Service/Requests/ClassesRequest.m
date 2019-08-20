//
//  ClassesRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/1/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "ClassesRequest.h"

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


//2.5.8    获取所有班级列表（设置权限用）
@implementation AllClassesRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {

    return [NSString stringWithFormat:@"%@/class/getAllclasses", ServerProjectName];
}

@end

