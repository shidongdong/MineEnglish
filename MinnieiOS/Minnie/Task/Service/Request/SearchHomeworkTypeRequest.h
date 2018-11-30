//
//  SearchHomeworkTypeRequest.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/19.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "BaseRequest.h"

@interface SearchHomeworkTypeRequest : BaseRequest

- (instancetype)initWithHomeworkSessionForType:(NSInteger)type withFinishState:(NSInteger)state;

- (instancetype)initWithNextUrl:(NSString *)nextUrl;

@end
