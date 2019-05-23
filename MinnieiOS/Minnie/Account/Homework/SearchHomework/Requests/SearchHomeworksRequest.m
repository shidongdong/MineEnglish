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
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageNo;

@end

@implementation SearchHomeworksRequest

- (instancetype)initWithKeyword:(NSArray<NSString *> *)keyword {
    self = [super init];
    if (self != nil) {
        
        _pageNo = 1;
        _pageNum = 10;
        _keyword = keyword;
    }
    
    return self;
}

- (instancetype)initWithNextUrl:(NSString *)nextUrl withKeyword:(NSArray<NSString *> *)keyword {
    self = [super init];
    if (self != nil) {
        
        NSArray * urls = [nextUrl componentsSeparatedByString:@"&tags="];
        
        NSString * parmsString = [urls objectAtIndex:0];
        NSArray * parmsArray = [parmsString componentsSeparatedByString:@"&pageNum="];
        _pageNum = [[parmsArray objectAtIndex:1] integerValue];
        parmsString = [parmsArray objectAtIndex:0];
        parmsArray = [parmsString componentsSeparatedByString:@"pageNo="];
        _pageNo = [[parmsArray objectAtIndex:1] integerValue];
        _keyword = keyword;
        _nextUrl = nextUrl;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    
    return [NSString stringWithFormat:@"%@/homework/searchHomeworksByTags?pageNo=%@&pageNum=%@", ServerProjectName,@(self.pageNo),@(self.pageNum)];
}

- (id)requestArgument {
    
    if (self.keyword.count > 0) {
        return @{@"tags":self.keyword};
    }
    return nil;
}

@end

