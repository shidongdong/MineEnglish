//
//  MISecondActivityTableViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityInfo.h"

extern CGFloat const MISecondActivityTableViewCellHeight;

extern NSString * _Nullable const MISecondActivityTableViewCellId;

NS_ASSUME_NONNULL_BEGIN

@interface MISecondActivityTableViewCell : UITableViewCell

- (void)setupWithModel:(ActivityInfo *)model selected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
