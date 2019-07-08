//
//  MIScoreListTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIScoreListTableViewCell.h"

NSString * const MIScoreListTableViewCellId = @"MIScoreListTableViewCellId";
CGFloat const MIScoreListTableViewCellHeight = 74.f;

@interface MIScoreListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLevelLabel;

@end

@implementation MIScoreListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.portraitImageV.layer.masksToBounds = YES;
    self.portraitImageV.layer.cornerRadius = 22.0;
}


-(void)setupModel:(ScoreInfo *)scoreInfo{
    
    self.nameLabel.text = scoreInfo.nickName;
    self.starLevelLabel.text = [NSString stringWithFormat:@"%lu星",scoreInfo.score];
    [self.portraitImageV sd_setImageWithURL:[scoreInfo.avatar imageURLWithWidth:44.f] placeholderImage:[UIImage imageNamed:@"attachment_placeholder"]];
  
}
@end
