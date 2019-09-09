//
//  SearchHomeworksRequest.h
//  X5Teacher
//
//  Created by yebw on 2018/2/4.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseRequest.h"

@interface SearchHomeworksRequest : BaseRequest
// 二级目录id，如果所有为0
- (instancetype)initWithKeyword:(NSArray<NSString *> *)keyword fileId:(NSInteger)fileId;

- (instancetype)initWithNextUrl:(NSString *)nextUrl
                    withKeyword:(NSArray<NSString *> *)keyword
                         fileId:(NSInteger)fileId;

@end
