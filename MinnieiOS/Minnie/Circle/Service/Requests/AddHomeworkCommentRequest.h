//
//  AddCommentRequest.h
//  X5
//
//  Created by yebw on 2017/11/27.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseRequest.h"

@interface AddHomeworkCommentRequest : BaseRequest

/**
 创建评论请求
 
 @param homeworkSessionId 作业id
 @param commentId 原始评论id
 @param content 评论内容
 @return 实例
 */
- (id)initWithHomeworkSessionId:(NSUInteger)homeworkSessionId
                      commentId:(NSUInteger)commentId
                        content:(NSString *)content;

@end

