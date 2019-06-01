//
//  MIParticipateDetailTableViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIParticipateModel.h"

extern CGFloat const MIParticipateDetailTableViewCellHeight;

extern NSString * _Nullable const MIParticipateDetailTableViewCellId;


NS_ASSUME_NONNULL_BEGIN

@interface MIParticipateDetailTableViewCell : UITableViewCell

- (void)setupWithModel:(MIParticipateModel *)model;

@end

NS_ASSUME_NONNULL_END
