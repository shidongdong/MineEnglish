//
//  NoticeMessageRequest.m
//  X5
//
//  Created by yebw on 2017/12/5.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "NoticeMessageRequest.h"

@interface NoticeMessageRequest()

@property (nonatomic, assign) NSUInteger messageId;

@end

@implementation NoticeMessageRequest

- (instancetype)initWithMessageId:(NSUInteger)messageId {
    self = [super init];
    if (self != nil) {
        _messageId = messageId;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/message/noticeMessage", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.messageId)};
}

@end

