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
    
    self.portraitImageV.layer.masksToBounds = YES;
    self.portraitImageV.layer.cornerRadius = 22.0;
}

- (void)setupWithModel:(id)model{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
