//
//  StudentStarListTableViewCell.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/26.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarRank.h"

@interface StudentStarListTableViewCell : UITableViewCell

- (void)setContentData:(StarRank *)data forRank:(NSInteger)rank;

@end
