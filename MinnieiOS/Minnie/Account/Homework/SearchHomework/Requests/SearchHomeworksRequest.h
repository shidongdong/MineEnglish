//
//  SearchHomeworksRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/2/4.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"

@interface SearchHomeworksRequest : BaseRequest

- (instancetype)initWithKeyword:(NSArray<NSString *> *)keyword;

- (instancetype)initWithNextUrl:(NSString *)nextUrl withKeyword:(NSArray<NSString *> *)keyword;

@end
