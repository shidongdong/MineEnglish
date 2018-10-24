//
//  RegisterViewController.h
// X5
//
//  Created by yebw on 2017/8/23.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, InputPhoneNumberActionType) {
    InputPhoneNumberActionRegister = 0,
    InputPhoneNumberActionFindPassword = 1,
};

@interface InputPhoneNumberViewController : BaseViewController

@property (nonatomic, assign) InputPhoneNumberActionType actionType;

@end
