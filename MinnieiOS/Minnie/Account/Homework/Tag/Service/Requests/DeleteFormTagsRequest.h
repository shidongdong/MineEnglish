//
//  DeleteFormTagsRequest.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/19.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "BaseRequest.h"

@interface DeleteFormTagsRequest : BaseRequest

- (instancetype)initWithFormTags:(NSArray<NSString *> *)formtags;

@end
