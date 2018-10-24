//
//  ClassRequest.m
//  X5
//
//  Created by yebw on 2017/10/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "ClassRequest.h"

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


