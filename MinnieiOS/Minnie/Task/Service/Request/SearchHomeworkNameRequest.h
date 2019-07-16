//
//  SearchHomeworkNameRequest.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/28.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "BaseRequest.h"

@interface SearchHomeworkNameRequest : BaseRequest

- (instancetype)initWithHomeworkSessionForName:(NSString *)name
                               withFinishState:(NSInteger)state
                                     teacherId:(NSInteger)teacherId;

- (instancetype)initWithNextUrl:(NSString *)nextUrl;

@end

