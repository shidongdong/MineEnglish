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
@property (weak, nonatomic) IBOutlet UIView *rightLineView;

@end


@implementation MIActivityRankListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.rightLineView.hidden = YES;
    self.portraitImagV.layer.masksToBounds = YES;
    self.portraitImagV.layer.cornerRadius = 20.0;
}

- (void)setupWithModel:(ActivityRankInfo *)model index:(NSInteger)index {
    
    self.nameLabel.text = model.nickName;
    self.stateLabel.hidden = model.isOk;
    self.rankLabel.text = [NSString stringWithFormat:@"%lu",index];
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%.2ld分%.2ld秒",model.actTimes/60,model.actTimes%60];
    [self.portraitImagV sd_setImageWithURL:[model.avatar imageURLWithWidth:32] placeholderImage:[UIImage imageNamed:@"attachment_placeholder"]];
}

- (void)setSelectedState:(BOOL)selected{
    
    if (selected) {
        self.rightLineView.hidden = NO;
        self.backgroundColor = [UIColor colorWithHex:0xF2FAFF];
    } else {
        
        self.rightLineView.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
