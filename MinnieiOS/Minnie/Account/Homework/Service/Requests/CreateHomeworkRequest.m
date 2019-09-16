//
//  CreateHomeworkRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "CreateHomeworkRequest.h"
#import <Mantle/Mantle.h>

@interface CreateHomeworkRequest()

@property (nonatomic, strong) Homework *homework;

@end

@implementation CreateHomeworkRequest

- (instancetype)initWithHomework:(Homework *)homework {
    self = [super init];
    if (self != nil) {
        self.homework = homework;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/create", ServerProjectName];
}

- (id)requestArgument {
    return [self.homework dictionaryForUpload];
}

@end
