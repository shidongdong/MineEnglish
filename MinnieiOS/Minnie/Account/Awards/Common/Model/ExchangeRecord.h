//
//  ExchangeRecord.h
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "User.h"
#import "Award.h"

/**
 交换记录
 */
@interface ExchangeRecord : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger exchangeRequestId;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Award *award;
@property (nonatomic, assign) long long time; // 兑换时间
@property (nonatomic, assign) NSInteger state; // 0表示未取礼物 1表示已取

@end

@interface ExchangeAwardInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger awardId;
@property (nonatomic, copy) NSString *awardName;
@property (nonatomic, copy) NSString *awardImageUrl;
@property (nonatomic, assign) NSInteger awardPrice;
@property (nonatomic, assign) long long exchangeTime;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *nickName;

@end

@interface ExchangeAwardListRecord : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger classId;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, strong) NSArray<ExchangeAwardInfo*> *awardList;

@property (nonatomic, copy) NSString *pinyinName;


@end


