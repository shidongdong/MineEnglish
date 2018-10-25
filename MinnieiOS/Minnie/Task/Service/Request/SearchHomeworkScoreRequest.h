//
//  SearchHomeworkScoreRequest.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/25.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "BaseRequest.h"

@interface SearchHomeworkScoreRequest : BaseRequest

- (instancetype)initWithHomeworkSessionForScore:(NSInteger)homeworkScore;

@end
