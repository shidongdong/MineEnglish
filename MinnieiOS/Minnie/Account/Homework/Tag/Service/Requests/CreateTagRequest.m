//
//  CreateTagRequest.m
//  X5Teacher
//
//  Created by yebw on 2017/12/20.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "CreateTagRequest.h"

@interface CreateTagRequest()

@property (nonatomic, copy) NSString *homeworkTag;

@end

@implementation CreateTagRequest

- (instancetype)initWithTag:(NSString *)tag {
    self = [super init];
    if (self != nil) {
        _homeworkTag = tag;
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
    return [NSString stringWithFormat:@"%@/homework/addTag", ServerProjectName];
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return @{@"tag":self.homeworkTag};
}


@end
