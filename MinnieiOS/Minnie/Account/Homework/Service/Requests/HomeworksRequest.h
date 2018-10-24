//
//  HomeworksRequest.h
//  X5
//
//  Created by yebw on 2017/12/14.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseRequest.h"

@interface HomeworksRequest : BaseRequest

- (instancetype)initWithNextUrl:(NSString *)nextUrl;

- (instancetype)initWithClassId:(NSUInteger)classId;

@end
