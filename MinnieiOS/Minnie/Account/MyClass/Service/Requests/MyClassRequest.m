//
//  ClassRequest.m
//  X5
//
//  Created by yebw on 2017/10/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "MyClassRequest.h"

@interface MyClassRequest()

@property (nonatomic, assign) NSUInteger classId;

@end

@implementation MyClassRequest

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

