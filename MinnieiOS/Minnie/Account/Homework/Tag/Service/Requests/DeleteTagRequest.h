//
//  DeleteTagRequest.h
//  X5Teacher
//
//  Created by yebw on 2017/12/20.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "BaseRequest.h"

@interface DeleteTagRequest : BaseRequest

- (instancetype)initWithTags:(NSArray<NSString *> *)tags;

@end
