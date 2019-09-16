//
//  MIScoreListTableViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "ScoreInfo.h"
#import <UIKit/UIKit.h>

extern NSString * _Nullable const MIScoreListTableViewCellId;

extern CGFloat const MIScoreListTableViewCellHeight;


NS_ASSUME_NONNULL_BEGIN

@interface MIScoreListTableViewCell : UITableViewCell

-(void)setupModel:(ScoreInfo *)scoreInfo;

@end

NS_ASSUME_NONNULL_END
