//
//  MICampusManagerViewController.h
//  MinnieManager
//
//  Created by songzhen on 2019/7/11.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MICampusManagerViewControllerDelegate <NSObject>


- (void)campusManagerViewControllerPopEditClassState;

- (void)campusManagerViewControllerEditClazz:(Clazz *_Nullable)clazz;

@end

@interface MICampusManagerViewController : UIViewController

@property (nonatomic, weak) id<MICampusManagerViewControllerDelegate> delegate;

- (void)updateCampusInfo;

- (void)updateClassInfo;

- (void)resetSelectIndex;

@end

NS_ASSUME_NONNULL_END
