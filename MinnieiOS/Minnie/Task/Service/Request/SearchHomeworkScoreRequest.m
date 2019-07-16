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
@property (nonatomic, copy) NSString *nextUrl;
@property(nonatomic,assign)NSInteger teacherId;

@end

@implementation SearchHomeworkScoreRequest

- (instancetype)initWithHomeworkSessionForScore:(NSInteger)homeworkScore
                                      teacherId:(NSInteger)teacherId
{
    self = [super init];
    if (self != nil) {
        _score = homeworkScore;
        _teacherId = teacherId;
    }
    return self;
}

- (instancetype)initWithNextUrl:(NSString *)nextUrl
{
    self = [super init];
    if (self != nil) {
        _nextUrl = nextUrl;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl {
    if (self.nextUrl.length > 0) {
        return self.nextUrl;
    }

    return [NSString stringWithFormat:@"%@/homeworkTask/getHomeworkTasksByScore", ServerProjectName];
}

- (id)requestArgument {
    if (self.nextUrl.length > 0) {
        return nil;
    }
    if (self.teacherId == 0) {
       
        return @{@"score":@(self.score)};
    } else {
        return @{@"score":@(self.score),
                 @"teacherId":@(self.teacherId)};
    }
}

@end
