//
//  AwardCollectionViewCell.h
//  X5
//
//  Created by yebw on 2017/9/14.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Award.h"

extern NSString * const TeacherAwardCollectionViewCellId;

@interface TeacherAwardCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *awardImageView;
@property (nonatomic, weak) IBOutlet UILabel *awardNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *starCostLabel;

+ (CGSize)size;

- (void)setupWithAward:(Award *)award;

@end
