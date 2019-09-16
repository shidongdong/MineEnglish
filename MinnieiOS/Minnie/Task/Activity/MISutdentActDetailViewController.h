//
//  MISutdentActDetailViewController.h
//  Minnie
//
//  Created by songzhen on 2019/6/8.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "ActivityInfo.h"
#import "BaseViewController.h"

typedef void(^ActDetailCallBack)(void);

NS_ASSUME_NONNULL_BEGIN

@interface MISutdentActDetailViewController : BaseViewController

@property (nonatomic,strong) ActivityInfo *actInfo;

@property (nonatomic,copy) ActDetailCallBack actCallBack;

@end

NS_ASSUME_NONNULL_END
