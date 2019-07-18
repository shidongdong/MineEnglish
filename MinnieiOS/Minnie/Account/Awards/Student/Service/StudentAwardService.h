//
//  AwardService.h
//  X5
//
//  Created by yebw on 2017/10/19.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Award.h"
#import "ExchangeRecord.h"
#import "BaseRequest.h"
#import "Result.h"
#import "StarLogs.h"

@interface StudentAwardService : NSObject

+ (BaseRequest *)requestAwardsWithCallback:(RequestCallback)callback;

+ (BaseRequest *)exchangeAwardWithId:(NSUInteger)award callback:(RequestCallback)callback;

+ (BaseRequest *)requestExchangeRecordsWithCallback:(RequestCallback)callback;

//获取星星排行榜 
+ (BaseRequest *)requestStudentStarRankListWithCallback:(RequestCallback)callback;


//学生图形标注（教师端） 可用
+ (BaseRequest *)requestStudentLabelWithStudentId:(NSInteger)stuId
                                     studentLabel:(NSInteger)stuLabel
                                         callback:(RequestCallback)callback;

//学生信息详情添加备注（教师端）可用
+ (BaseRequest *)requestStudentRemarkWithStudentId:(NSInteger)stuId
                                         stuRemark:(NSString *)stuRemark
                                          callback:(RequestCallback)callback;

//学生星星增减记录（学生端,ipad端）
+ (BaseRequest *)requestStarLogsWithPageNo:(NSUInteger)pageNo
                                   pageNum:(NSUInteger)pageNum
                                   logType:(NSString *)logType
                                  callback:(RequestCallback)callback;

@end
