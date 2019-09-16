//
//  MIActivityRankListViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityInfo.h"

typedef void(^ActivityPushNewVCCallBack) (UIViewController * _Nullable VC);

typedef void(^ActivityRankListCallback)(NSInteger activityIndex);

NS_ASSUME_NONNULL_BEGIN

@interface MIActivityRankListViewController : UIViewController

@property (nonatomic,copy) ActivityRankListCallback callback;

@property (nonatomic,copy) ActivityPushNewVCCallBack pushVCCallback;

- (void)updateRankListWithActivityModel:(ActivityInfo *_Nullable)model index:(NSInteger)currentIndex;

- (void)createActivity;

@end

NS_ASSUME_NONNULL_END
