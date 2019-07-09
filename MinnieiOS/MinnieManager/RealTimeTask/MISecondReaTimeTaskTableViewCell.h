//
//  MISecondReaTimeTaskTableViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/7/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * _Nullable const MISecondReaTimeTaskTableViewCellId;

extern CGFloat const MISecondReaTimeTaskTableViewCellHeight;


NS_ASSUME_NONNULL_BEGIN

@interface MISecondReaTimeTaskTableViewCell : UITableViewCell

- (void)setupTitle:(NSString *)title icon:(NSString *)icon selectState:(BOOL)state;

@end

NS_ASSUME_NONNULL_END
