//
//  DeleteCommentRequest.h
//  X5
//
//  Created by yebw on 2017/11/27.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseRequest.h"

@interface DeleteHomeworkCommentRequest : BaseRequest

- (instancetype)initWithCommentId:(NSUInteger)commentId;

@end
