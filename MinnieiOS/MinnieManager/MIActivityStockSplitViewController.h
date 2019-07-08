//
//  MIActivityStockSplitViewController.h
//  Minnie
//
//  Created by songzhen on 2019/7/3.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIStockSecondViewController.h"
#import "CSCustomSplitViewController.h"
#import "MIActivityRankListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIActivityStockSplitViewController : CSCustomSplitViewController

@property (nonatomic,copy) ActivityRankListCallback createCallback;

@property (nonatomic, strong) MIActivityRankListViewController *stockMasterVC;
@property (nonatomic, strong) MIStockSecondViewController *stockDetailVC;


/*
 *  活动列表
 */

- (void)updateRankListWithActivityModel:(ActivityInfo *_Nullable)model index:(NSInteger)currentIndex;

- (void)createActivity;



@end

NS_ASSUME_NONNULL_END
