//
//  SendHomeworkRequest.m
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "SendHomeworkRequest.h"

@interface SendHomeworkRequest()

@property (nonatomic, strong) NSArray *homeworkIds;
@property (nonatomic, strong) NSArray *classIds;
@property (nonatomic, strong) NSArray *studentIds;
@property (nonatomic, assign) NSInteger teacherId;
@property (nonatomic, strong) NSDate *date;

@end

@implementation SendHomeworkRequest

- (instancetype)initWithHomeworkIds:(NSArray <NSNumber *> *)homeworkIds
                           classIds:(NSArray <NSNumber *> *)classIds
                         studentIds:(NSArray <NSNumber *> *)studentIds
                          teacherId:(NSInteger)teacherId
                               date:(NSDate *)date {
    self = [super init];
    if (self != nil) {
        _homeworkIds = homeworkIds;
        _classIds = classIds;
        _studentIds = studentIds;
        _teacherId = teacherId;
        _date = date;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/homework/sendHomeworks", ServerProjectName];
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionary];
    
    if (self.homeworkIds.count > 0) {
        argument[@"ids"] = self.homeworkIds;
    }
    
    if (self.classIds.count > 0) {
        argument[@"classIds"] = self.classIds;
    }
    
    if (self.studentIds.count > 0) {
        argument[@"studentIds"] = self.studentIds;
    }
    
    argument[@"teacherId"] = @(self.teacherId);

    if (self.date != nil) {
        argument[@"time"] = @((NSInteger)([self.date timeIntervalSince1970]*1000));
    }
    
    return argument;
}

@end


