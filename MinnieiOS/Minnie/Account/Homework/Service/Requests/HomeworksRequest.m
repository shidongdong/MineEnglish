//
//  HomeworksRequest.m
//  X5
//
//  Created by yebw on 2017/12/14.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "HomeworksRequest.h"

@interface HomeworksRequest()

@property (nonatomic, assign) NSUInteger classId;
@property (nonatomic, copy) NSString *nextUrl;

@end

@implementation HomeworksRequest

- (instancetype)initWithNextUrl:(NSString *)nextUrl {
    self = [super init];
    if (self != nil) {
        _nextUrl = nextUrl;
    }
    
    return self;
}

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
    if (self.nextUrl.length > 0) {
        return self.nextUrl;
    }

    return [NSString stringWithFormat:@"%@/homework/homeworks", ServerProjectName];
}

- (id)requestArgument {
    if (self.classId > 0) {
        return @{@"classId":@(self.classId)};
    }
    
    return nil;
}

@end

