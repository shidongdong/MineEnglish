//
//  MIClassViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/7/12.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MIClassDetailViewControllerDelegate <NSObject>

- (void)classDetailViewControllerClickedIndex:(NSInteger)index clazz:(Clazz *)clazz;

@end

@interface MIClassDetailViewController : UIViewController

@property (nonatomic, weak) id<MIClassDetailViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
