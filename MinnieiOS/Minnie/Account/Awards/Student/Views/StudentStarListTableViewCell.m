//
//  StudentStarListTableViewCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/26.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "StudentStarListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface StudentStarListTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;


@end

@implementation StudentStarListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.cornerRadius = 12.0;
    
    // Initialization code
}

- (void)setContentData:(StarRank *)data forRank:(NSInteger)rank
{
    if (rank == 0)
    {
        self.rankImageView.image = [UIImage imageNamed:@"第1名"];
    }
    else if (rank == 1)
    {
        self.rankImageView.image = [UIImage imageNamed:@"第2名"];
    }
    else if (rank == 2)
    {
        self.rankImageView.image = [UIImage imageNamed:@"第3名"];
    }
    else
    {
        self.rankImageView.image = [UIImage imageNamed:@"第4名"];
    }
    
    self.rankLabel.text = [NSString stringWithFormat:@"%ld",rank+1];
    self.nameLabel.text = data.nickName;
    self.starLabel.text = [NSString stringWithFormat:@"%ld颗星",(long)data.starCount];
    
    self.headerImageView.layer.cornerRadius = 12.f;
    self.headerImageView.layer.masksToBounds = YES;
    
    if (data.avatar != nil) {
        [self.headerImageView sd_setImageWithURL:[data.avatar imageURLWithWidth:24.f]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
