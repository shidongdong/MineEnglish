//
//  ActivityInfo.h
//  MinnieManager
//
//  Created by songzhen on 2019/6/1.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "HomeworkItem.h"
#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ActivityRankInfo <NSObject>

@end

@interface StringObj : MTLModel<MTLJSONSerializing>

@end

@interface ActivityInfo : MTLModel<MTLJSONSerializing>

// 返回目录id
@property (nonatomic ,assign) NSInteger activityId;
// 活动标题
@property (nonatomic ,copy) NSString *title;
// 活动材料，相当于附件
@property (nonatomic ,strong) NSArray<HomeworkItem*> *items;
//// 活动材料，相当于附件
//@property (nonatomic ,strong) HomeworkItem *coverItems;
// 创建时间，XXXX-xx-XX XX-XX-xx
@property (nonatomic ,copy) NSString *createTime;
// 提交的次数:1/2/3/4
@property (nonatomic ,assign) NSInteger submitNum;
// 作业限制时长，单位秒
@property (nonatomic ,assign) NSInteger limitTimes;
// 开始时间：XXXX-xx-XX XX-XX-xx
@property (nonatomic ,copy) NSString *startTime;
// 结束时间：XXXX-xx-XX XX-XX-xx
@property (nonatomic ,copy) NSString *endTime;
// 活动封面链接
@property (nonatomic ,copy) NSString *actCoverUrl;
// 学生id列表
@property (nonatomic ,strong) NSArray *studentIds;
// 班级id列表
@property (nonatomic ,copy) NSArray *classIds;
// 学生姓名列表跟studentIds对应
@property (nonatomic ,copy) NSArray *studentNames;
// 班级名称列表跟classIds对应
@property (nonatomic ,copy) NSArray *classNames;
// 状态，0未开始，1正在进行中，2已结束
@property (nonatomic ,assign) NSInteger status;

- (NSDictionary *)dictionaryForUpload;
@end


// 活动排名

@interface ActivityRankInfo : MTLModel<MTLJSONSerializing>

// 活动上次视频时长（秒）
@property (nonatomic ,assign) NSInteger actTimes;
// 活动视频URL
@property (nonatomic ,copy) NSString *actUrl;
// 用户头像地址
@property (nonatomic ,copy) NSString *avatar;
// 用户id
@property (nonatomic ,assign) NSInteger userId;
// 用户昵称
@property (nonatomic ,copy) NSString *nickName;
// 0:待审核；1合格；2不合格
@property (nonatomic ,assign) NSInteger isOk;

@property (nonatomic ,assign) NSInteger actId;

@end

// 活动排名列表
@interface ActivityRankListInfo : MTLModel<MTLJSONSerializing>

// 合格排行
@property (nonatomic ,strong) NSArray<ActivityRankInfo> *okRank;
// 待审核排行
@property (nonatomic ,strong) NSArray<ActivityRankInfo> *checkRank;

@end

@interface ActLogsInfo : MTLModel<MTLJSONSerializing>

// 记录id
@property (nonatomic ,assign) NSInteger logId;
// 活动上次视频时长（秒）
@property (nonatomic ,assign) NSInteger actTimes;
// 活动视频URL
@property (nonatomic ,copy) NSString *actUrl;
// 活动id
@property (nonatomic ,assign) NSInteger actId;
// 0:待审核；1合格；2不合格
@property (nonatomic ,assign) NSInteger isOk;
// 上传时间
@property (nonatomic ,copy) NSString *upTime;

@end

NS_ASSUME_NONNULL_END
