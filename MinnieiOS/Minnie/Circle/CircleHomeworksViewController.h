//
//  CircleHomeworksViewController.h
//  X5
//
//  Created by yebw on 2017/12/12.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseViewController.h"
#import "Clazz.h"

@interface CircleHomeworksViewController : BaseViewController

@property (nonatomic, assign) NSUInteger userId;
@property (nonatomic, strong) Clazz *clazz;
@property (nonatomic, strong) NSString * userName;


// 管理端
@property (nonatomic, copy) void (^cancelCallBack) (void);
// 班级编辑成功
@property (nonatomic, copy) void (^editSuccessCallBack) (void);

@end
