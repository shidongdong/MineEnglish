//
//  StudentDetailCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/8.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "StudentDetailCell.h"

NSString * const StudentDetailCellId = @"StudentDetailCellId";

@interface StudentDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation StudentDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.modifyBtn.layer.cornerRadius = 10;
    self.modifyBtn.layer.borderWidth = 1.0;
    self.modifyBtn.layer.borderColor = [UIColor colorWithHex:0x333333].CGColor;
    // Initialization code
}
- (IBAction)modifyPressed:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(modifyStarAction)]) {
        [_delegate modifyStarAction];
    }
}

- (void)setCellTitle:(NSString *)title withContent:(NSString *)content
{
    self.titleLabel.text = title;
    self.contentLabel.text = content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
