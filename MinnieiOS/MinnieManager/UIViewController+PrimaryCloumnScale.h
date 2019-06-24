//
//  UIViewController+PrimaryCloumnScale.h
//  Minnie
//
//  Created by songzhen on 2019/6/24.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (PrimaryCloumnScale)

#if MANAGERSIDE

- (void)updatePrimaryCloumnScale:(NSInteger)offset;

#endif

@end

NS_ASSUME_NONNULL_END
