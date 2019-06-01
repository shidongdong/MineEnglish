//
//  MISecondActivitySheetView.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//  活动管理  活动列表

#import <UIKit/UIKit.h>
#import "MIActivityModel.h"

#define kActivitySheetWidth         204.f


@protocol MISecondActivitySheetViewDelegate <NSObject>

// 点击活动列表
- (void)secondActivitySheetViewDidClickedActivity:(MIActivityModel *_Nullable)data index:(NSInteger)index;

@end


NS_ASSUME_NONNULL_BEGIN

@interface MISecondActivitySheetView : UIView

@property (nonatomic, weak) id<MISecondActivitySheetViewDelegate> delegate;

- (void)updateData:(NSArray *)activityArray;

// 编辑活动
- (void)activitySheetDidEditIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
