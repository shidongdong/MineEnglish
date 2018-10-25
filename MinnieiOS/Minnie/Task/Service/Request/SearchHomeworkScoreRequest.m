//
//  SearchHomeworkScoreRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/25.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "SearchHomeworkScoreRequest.h"

@interface SearchHomeworkScoreRequest()

@property(nonatomic,assign)NSInteger score;

@end

@implementation SearchHomeworkScoreRequest

- (instancetype)initWithHomeworkSessionForScore:(NSInteger)homeworkScore
{
    self = [super init];
    if (self != nil) {
        _score = homeworkScore;
    }
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homeworkTask/getHomeworkTaskByScore", ServerProjectName];
}

- (id)requestArgument {
    return @{@"score":@(self.score)};
}

@end
