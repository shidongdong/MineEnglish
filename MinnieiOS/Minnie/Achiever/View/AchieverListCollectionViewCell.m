//
//  AchieverListCollectionViewCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/5.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "AchieverListCollectionViewCell.h"

NSString * const AchieverListCollectionViewCellId = @"AchieverListCollectionViewCellId";

@interface AchieverListCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *medalImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end


@implementation AchieverListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentData:(id)data
{
    self.medalImageView.image = [UIImage imageNamed:@""];
    self.medalImageView.backgroundColor = [UIColor redColor];
    self.nameLabel.text = @"第几次点赞hahaha我的错";
}

@end
