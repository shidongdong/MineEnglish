//
//  StudentDetailHeaderCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/8.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "StudentDetailHeaderCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const StudentDetailHeaderCellId = @"StudentDetailHeaderCellId";

@interface StudentDetailHeaderCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation StudentDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = 40.f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    // Initialization code
}

- (void)setHeaderURL:(NSString *)avatarUrl
{
    if (avatarUrl != nil) {
        [self.avatarImageView sd_setImageWithURL:[avatarUrl imageURLWithWidth:80.f]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
