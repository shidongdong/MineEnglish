//
//  MIParticipateDetailViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityInfo.h"
#import "BaseViewController.h"

typedef void(^CorrectActivityCancelCallBack)(void);
typedef void(^CorrectActivitySuccessCallBack)(void);

NS_ASSUME_NONNULL_BEGIN

@interface MIParticipateDetailViewController : BaseViewController

@property (nonatomic,strong) ActivityRankInfo *rankInfo;

@property (nonatomic,copy)CorrectActivityCancelCallBack cancelCallBack;
@property (nonatomic,copy)CorrectActivitySuccessCallBack correctCallBack;

@end

NS_ASSUME_NONNULL_END
