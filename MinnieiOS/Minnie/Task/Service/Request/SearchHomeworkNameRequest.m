//
//  SearchHomeworkNameRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/28.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "SearchHomeworkNameRequest.h"

@interface SearchHomeworkNameRequest()

@property(nonatomic,copy)NSString * name;      //1:任务；2人
@property(nonatomic,assign)NSInteger finished;  //0：待批改；1已完成；2未提交
@property (nonatomic, copy) NSString *nextUrl;

@end

@implementation SearchHomeworkNameRequest

- (instancetype)initWithHomeworkSessionForName:(NSString *)name withFinishState:(NSInteger)state
{
    self = [super init];
    if (self != nil) {
        _name = name;
        _finished = state;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (instancetype)initWithNextUrl:(NSString *)nextUrl
{
    self = [super init];
    if (self != nil) {
        _nextUrl = nextUrl;
    }
    
    return self;
}

- (NSString *)requestUrl {
    if (self.nextUrl.length > 0) {
        return self.nextUrl;
    }
    
    return [NSString stringWithFormat:@"%@/homeworkTask/getHomeworkTasksByStudent", ServerProjectName];
}

- (id)requestArgument {
    if (self.nextUrl.length > 0) {
        return nil;
    }
    
    return @{@"studentName":self.name,@"finished":@(self.finished)};
}

@end
