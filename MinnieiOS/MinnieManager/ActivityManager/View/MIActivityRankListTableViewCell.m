//
//  MIActivityRankListTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIActivityRankListTableViewCell.h"

CGFloat const MIActivityRankListTableViewCellHeight = 70.f;

NSString * const MIActivityRankListTableViewCellId = @"MIActivityRankListTableViewCellId";

@interface MIActivityRankListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (weak, nonatomic) IBOutlet UIImageView *portraitImagV;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end


@implementation MIActivityRankListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.portraitImagV.layer.masksToBounds = YES;
    self.portraitImagV.layer.cornerRadius = 20.0;
}

- (void)setupWithModel:(ActivityRankInfo *)model index:(NSInteger)index{
    
    self.rankLabel.text = [NSString stringWithFormat:@"%lu",index + 1];
    self.nameLabel.text = model.nickName;
    self.stateLabel.text = @"待审核";
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%ld",model.actTimes];
}

@end
