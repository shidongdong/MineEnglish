//
//  StudentMarkRequest.m
//  MinnieStudent
//
//  Created by songzhen on 2019/5/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//   图形标注（教师端）


#import "StarLogs.h"
#import "Error.h"
#import "Result.h"
#import <Mantle/Mantle.h>
#import "StudentLabelRequest.h"
#pragma mark -
#pragma mark - 图形标注（教师端）

@interface StudentLabelRequest()

// 学生id
@property (nonatomic, assign) NSUInteger studentId;

/*
0：无
1：闪电图形
2：云朵图形
3：消息图形
 */
@property (nonatomic, assign) NSUInteger stuLabel;

@end

@implementation StudentLabelRequest

- (instancetype)initWithId:(NSUInteger)studentId stuLabel:(NSInteger)stuLabel{
    self = [super init];
    if (self != nil) {
        
        self.studentId = studentId;
        self.stuLabel = stuLabel;
    }
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/user/editLabel", ServerProjectName];
}

- (id)requestArgument {
    
    return @{@"studentId":@(self.studentId), @"stuLabel":@(self.stuLabel)};
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
@end


#pragma mark -
#pragma mark - 学生信息详情添加备注（教师端）

@interface StudentRemarkRequest()

// 学生id
@property (nonatomic, assign) NSUInteger studentId;
// 备注信息
@property (nonatomic, copy) NSString *stuRemark;

@end

@implementation StudentRemarkRequest

- (instancetype)initWithId:(NSUInteger)studentId stuRemark:(NSString *)stuRemark{
    self = [super init];
    if (self != nil) {
        
        self.studentId = studentId;
        self.stuRemark = stuRemark;
    }
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/user/editRemark", ServerProjectName];
}

- (id)requestArgument {
    
    return @{@"studentId":@(self.studentId), @"stuRemark":self.stuRemark};
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

@end

#pragma mark -
#pragma mark - 学生星星增减记录（学生端）
@interface StudentStarLogsRequest ()
//页码
@property (nonatomic, assign) NSUInteger pageNo;
//每页数目
@property (nonatomic, assign) NSUInteger pageNum;

//星星增减类别 0：所有 1：礼物 2：任务得分 3：考试统计
@property (nonatomic, copy) NSString *logType;


@end

@implementation StudentStarLogsRequest


- (instancetype)initWithPageNo:(NSUInteger)pageNo
                       pageNum:(NSUInteger)pageNum
                       logType:(NSString *)logType{
    self = [super init];
    if (self != nil) {
        
        self.pageNo = pageNo;
        self.pageNum = pageNum;
        self.logType = logType;
    }
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/user/getStarLogs", ServerProjectName];
}

- (id)requestArgument {
    
    return @{@"pageNo":@(self.pageNo),
             @"pageNum":@(self.pageNum),
             @"logType":self.logType };
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (Result *)parseResponse:(NSError **)error {
    Result *result = nil;
    NSError *err = nil;
   
    err = [Error errorWithResponseObject:self.responseObject];
    if (err != nil) {
        *error = err;
        return nil;
    }
    NSDictionary *dict = (NSDictionary *)(self.responseObject);
    NSObject *userInfo = dict[@"data"];
    
    result = [self parseResponseUserInfo:userInfo error:&err];
    if (result != nil || err != nil) {
        *error = err;
        return nil;
    }
    
    result = [[Result alloc] init];
    if ([userInfo isKindOfClass:[NSDictionary class]]) {
       
        StarLogs *logs = [MTLJSONAdapter modelOfClass:[StarLogs class] fromJSONDictionary:(NSDictionary *)userInfo error:nil];
        
        result.userInfo = logs;
    }
    result.response = self.response;
    result.responseData = self.responseData;
    return result;
}
@end
