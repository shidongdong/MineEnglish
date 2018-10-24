//
//  AddNoticeMessageRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/1/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "AddNoticeMessageRequest.h"

@interface AddNoticeMessageRequest()

@property (nonatomic, strong) NoticeMessage *noticeMessage;

@end

@implementation AddNoticeMessageRequest

- (instancetype)initWithNoticeMessage:(NoticeMessage *)noticeMessage {
    self = [super init];
    if (self != nil) {
        _noticeMessage = noticeMessage;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/noticeMessage/create", ServerProjectName];
}

- (id)requestArgument {
    return [self.noticeMessage dictForUpload];
}

@end
