//
//  SearchHomeworksRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/2/4.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "SearchHomeworksRequest.h"

@interface SearchHomeworksRequest()

@property (nonatomic, copy) NSArray<NSString *> *keyword;
@property (nonatomic, copy) NSString *nextUrl;

@end

@implementation SearchHomeworksRequest

- (instancetype)initWithKeyword:(NSArray<NSString *> *)keyword {
    self = [super init];
    if (self != nil) {
        _keyword = keyword;
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
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    if (self.nextUrl.length > 0) {
        return self.nextUrl;
    }

    return [NSString stringWithFormat:@"%@/homework/searchHomeworksByTags", ServerProjectName];
}

- (id)requestArgument {
    if (self.keyword.count > 0) {
        return @{@"tags":self.keyword};
    }

    return nil;
}

@end

