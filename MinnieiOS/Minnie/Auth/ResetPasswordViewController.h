//
//  ResetPasswordViewController.h
//  X5
//
//  Created by yebw on 2017/8/27.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ResetPasswordCancelCallBack) (void);

// 设置密码
@interface ResetPasswordViewController : BaseViewController

@property (nonatomic,copy) ResetPasswordCancelCallBack cancelCallBack;

@property (nonatomic,copy) NSString *phoneNumber;

@end
