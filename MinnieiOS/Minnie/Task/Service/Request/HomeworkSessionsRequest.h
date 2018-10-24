//
//  HomeworkSessionsRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/2/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"
#import "Result.h"

@interface HomeworkSessionsRequest : BaseRequest

- (instancetype)initWithFinishState:(BOOL)finished;

- (instancetype)initWithNextUrl:(NSString *)nextUrl;

@end
