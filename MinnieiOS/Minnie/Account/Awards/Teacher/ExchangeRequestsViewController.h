//
//  ExchangeRequestsViewController.h
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseViewController.h"

// 兑换记录和兑换请求页面
@interface ExchangeRequestsViewController : BaseViewController

@property (nonatomic, assign) BOOL exchanged; // 是否已经兑换

// 礼物管理 礼物列表（按班级）
@property (nonatomic, assign) BOOL isAwardListByClass;

@end

