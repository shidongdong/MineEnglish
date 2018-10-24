//
//  CommentMessageRequest.m
//  X5
//
//  Created by yebw on 2017/12/5.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "CommentMessagesRequest.h"

@interface CommentMessagesRequest()

@property (nonatomic, copy) NSString *nextUrl;

@end

@implementation CommentMessagesRequest

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
    
    return [NSString stringWithFormat:@"%@/message/comments", ServerProjectName];
}

@end

