//
//  MITeacherAuthorViewController.h
//  Minnie
//
//  Created by songzhen on 2019/8/13.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeacherEditViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface MITeacherAuthorViewController : UIViewController

@property (nonatomic, strong) Teacher *teacher; // 有传值表示是编辑，否则是新建

@property (nonatomic, copy) TeacherEditCancelCallBack cancelCallBack;

@property (nonatomic, copy) TeacherEditCancelCallBack successCallBack;

@end

NS_ASSUME_NONNULL_END
