//
//  EditStudentRemarkViewController.h
//  MinnieStudent
//
//  Created by songzhen on 2019/5/10.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditStudentRemarkViewController : BaseViewController

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *remark;
@end

NS_ASSUME_NONNULL_END
