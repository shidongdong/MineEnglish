//
//  CreateFormTagRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/19.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "CreateFormTagRequest.h"

@interface CreateFormTagRequest()

@property (nonatomic, copy) NSString *homeworkFromTag;

@end

@implementation CreateFormTagRequest

- (instancetype)initWithFormTag:(NSString *)formtag {
    self = [super init];
    if (self != nil) {
        _homeworkFromTag = formtag;
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
    return [NSString stringWithFormat:@"%@/homework/addFormtag", ServerProjectName];
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return @{@"formTag":self.homeworkFromTag};
}

@end
