//
//  ClassManagerViewController.h
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "BaseViewController.h"
#import "Clazz.h"

typedef void (^ClassManagerCancelCallBack) (void);
typedef void (^ClassManagerSuccessCallBack) (void);


@interface ClassManagerViewController : BaseViewController

@property (nonatomic, assign) NSInteger classId;

@property (nonatomic, copy) ClassManagerCancelCallBack cancelCallBack;
@property (nonatomic, copy) ClassManagerSuccessCallBack successCallBack;


@end
