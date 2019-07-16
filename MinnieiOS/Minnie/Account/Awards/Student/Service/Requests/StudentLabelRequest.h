//
//  StudentMarkRequest.h
//  MinnieStudent
//
//  Created by songzhen on 2019/5/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//  图形标注（教师端）

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark - 图形标注（教师端）
@interface StudentLabelRequest : BaseRequest

- (instancetype)initWithId:(NSUInteger)studentId stuLabel:(NSInteger)stuLabel;

@end



#pragma mark -
#pragma mark - 学生信息详情添加备注（教师端）
@interface StudentRemarkRequest : BaseRequest

- (instancetype)initWithId:(NSUInteger)studentId stuRemark:(NSString *)stuRemark;

@end

#pragma mark -
#pragma mark - 学生星星增减记录（学生端）
@interface StudentStarLogsRequest: BaseRequest

// logType 0：所有 1：礼物 2：任务得分 3：考试统计
- (instancetype)initWithPageNo:(NSUInteger)pageNo
                       pageNum:(NSUInteger)pageNum
                       logType:(NSString *)logType;

@end

NS_ASSUME_NONNULL_END
