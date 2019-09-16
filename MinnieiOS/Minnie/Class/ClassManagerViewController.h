//
//  ClassManagerViewController.h
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "Clazz.h"
#import "BaseViewController.h"


@interface ClassManagerViewController : BaseViewController

@property (nonatomic, assign) NSInteger classId;

@property (nonatomic, copy) void (^cancelCallBack) (void);
@property (nonatomic, copy) void (^successCallBack) (void);
@property (nonatomic, copy) void (^editCampusCallBack) (void);


@end
