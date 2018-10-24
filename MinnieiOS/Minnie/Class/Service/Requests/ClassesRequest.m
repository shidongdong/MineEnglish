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

@end

@implementation ClassesRequest

- (instancetype)initWithFinishState:(BOOL)finished teacherId:(NSInteger)teacherId simple:(BOOL)simple {
    self = [super init];
    if (self != nil) {
        _finished = finished;
        _simple = simple;
        _teacherId = teacherId;
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
    
    return dict;
}

@end

