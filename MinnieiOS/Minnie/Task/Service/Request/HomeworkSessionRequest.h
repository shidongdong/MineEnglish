//
//  HomeworkSessionsRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/2/10.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"
#import "Result.h"

@interface HomeworkSessionRequest : BaseRequest

- (instancetype)initWithId:(NSInteger)homeworkId;

@end
