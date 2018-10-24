//
//  LikeHomeworkRequest.h
//  X5
//
//  Created by yebw on 2017/11/27.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseRequest.h"

@interface LikeHomeworkRequest : BaseRequest

- (instancetype)initWithHomeworkSessionId:(NSUInteger)homeworkSessionId;

@end
