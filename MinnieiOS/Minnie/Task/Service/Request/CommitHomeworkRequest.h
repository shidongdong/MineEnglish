//
//  CommitHomeworkRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/4/7.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"

// 提交作业
@interface CommitHomeworkRequest : BaseRequest

- (instancetype)initWithImageUrl:(NSString *)imageUrl
                        videoUrl:(NSString *)videoUrl
               homeworkSessionId:(NSInteger)homeworkSessionId;

@end

