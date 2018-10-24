//
//  AddNoticeMessageRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/1/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"
#import "NoticeMessage.h"

@interface AddNoticeMessageRequest : BaseRequest

- (instancetype)initWithNoticeMessage:(NoticeMessage *)noticeMessage;

@end
