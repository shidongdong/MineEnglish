//
//  DeleteHomeworkRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"

@interface DeleteHomeworksRequest : BaseRequest

- (instancetype)initWithHomeworkIds:(NSArray<NSNumber *> *)homeworkIds;

@end
