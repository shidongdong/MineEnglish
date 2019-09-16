//
//  SettingsViewController.h
//  X5
//
//  Created by yebw on 2017/8/27.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SettingsPushNewVCCallBack) (UIViewController * _Nullable VC);


@interface SettingsViewController : BaseViewController

@property (assign, nonatomic) BOOL hiddenBackBtn;

@property (copy, nonatomic) SettingsPushNewVCCallBack _Nullable pushCallBack;

@property (copy, nonatomic) void (^popResetPasswordVCCallBack)(void);

@end
