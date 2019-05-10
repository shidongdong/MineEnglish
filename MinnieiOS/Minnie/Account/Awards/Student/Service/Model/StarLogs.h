//
//  StarRecordModel.h
//  MinnieStudent
//
//  Created by songzhen on 2019/5/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DayStarLogDetail <NSObject>

@end

@protocol StarLogDetail <NSObject>

@end

@interface StarLogDetail : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *starLogDesc;
@property (nonatomic, copy) NSString *starCount;

@end

@interface DayStarLogDetail : MTLModel<MTLJSONSerializing>

//日星星变动数量
@property(nonatomic, strong)NSString *dayStarSum;
//星星增减记录日期 2019-01-14
@property(nonatomic, strong)NSString *starLogDate;

@property(nonatomic, strong)NSArray<StarLogDetail> *starLogs;

@end


@interface StarLogs : MTLModel<MTLJSONSerializing>


@property(nonatomic, strong)NSArray<DayStarLogDetail> *list;

@end

NS_ASSUME_NONNULL_END
