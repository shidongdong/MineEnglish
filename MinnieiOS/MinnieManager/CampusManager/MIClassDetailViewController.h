//
//  MIClassViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/7/12.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CampusInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MIClassDetailViewControllerDelegate <NSObject>

- (void)classDetailViewControllerClickedIndex:(NSInteger)index clazz:(Clazz *_Nullable)clazz;

@end

@interface MIClassDetailViewController : UIViewController

@property (nonatomic, weak) id<MIClassDetailViewControllerDelegate> delegate;

// 管理端  校区信息
@property (nonatomic, strong) CampusInfo *campusInfo;


- (void)updateClassInfo;

- (void)resetSelectIndex;

@end

NS_ASSUME_NONNULL_END
