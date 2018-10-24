//
//  CircleHomeworksRequest.m
//  X5
//
//  Created by yebw on 2017/11/11.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "CircleHomeworksRequest.h"

@interface CircleHomeworksRequest()

@property (nonatomic, assign) NSUInteger userId;
@property (nonatomic, assign) NSUInteger classId;
@property (nonatomic, copy) NSString *nextUrl;

@end

@implementation CircleHomeworksRequest

- (BaseRequest *)initWithUserId:(NSUInteger)userId {
    self = [super init];
    if (self != nil) {
        _userId = userId;
    }
    
    return self;
}

- (BaseRequest *)initWithClassId:(NSUInteger)classId {
    self = [super init];
    if (self != nil) {
        _classId = classId;
    }
    
    return self;
}

- (BaseRequest *)initWithNextUrl:(NSString *)nextUrl {
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
    if (self.nextUrl != nil) {
        return self.nextUrl;
    }
    
    return [NSString stringWithFormat:@"%@/circle/homeworkTasks", ServerProjectName];
}

- (id)requestArgument {
    if (self.nextUrl != nil) {
        return nil;
    }
    
    if (self.userId > 0) {
        return @{@"studentId":@(self.userId)};
    } else if (self.classId > 0) {
        return @{@"classId":@(self.classId)};
    }
    
    return nil;
}

@end


