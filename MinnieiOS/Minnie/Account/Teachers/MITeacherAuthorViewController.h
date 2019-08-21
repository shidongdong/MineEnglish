//
//  MITeacherAuthorViewController.h
//  Minnie
//
//  Created by songzhen on 2019/8/13.
//  Copyright © 2019 minnieedu. All rights reserved.
//  教师管理

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface MITeacherAuthorViewController : BaseViewController

@property (nonatomic, strong) Teacher *teacher; // 有传值表示是编辑，否则是新建

@end

NS_ASSUME_NONNULL_END
