//
//  CreateAwardViewController.h
//  X5Teacher
//
//  Created by yebw on 2017/12/26.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "BaseViewController.h"
#import "Award.h"

typedef void(^CreateAwardDissmissCallBack)(void);

@interface CreateAwardViewController : BaseViewController

@property (nonatomic, strong) Award *award;

@property (nonatomic, copy) CreateAwardDissmissCallBack cancelCallBack;


@end
