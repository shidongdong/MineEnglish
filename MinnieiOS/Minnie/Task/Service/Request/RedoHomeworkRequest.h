//
//  redoHomeworkRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/4/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"

@interface RedoHomeworkRequest : BaseRequest

- (instancetype)initWithHomeworkSessionId:(NSInteger)homeworkSessionId;

@end
