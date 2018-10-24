//
//  CorrectHomeworkRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/4/6.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"
#import "Result.h"

@interface CorrectHomeworkRequest : BaseRequest

- (instancetype)initWithScore:(NSInteger)score
                         text:(NSString *)text
                      canRedo:(NSInteger)bRedo
                   sendCircle:(NSInteger)bSend
            homeworkSessionId:(NSInteger)homeworkSessionId;

@end

