//
//  ModifyStarRequest.h
//  Minnie
//
//  Created by 栋栋 施 on 2019/3/8.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import "BaseRequest.h"
@interface ModifyStarRequest : BaseRequest

- (instancetype)initWithStudentId:(NSInteger)studentId starCount:(NSInteger)count;

@end

