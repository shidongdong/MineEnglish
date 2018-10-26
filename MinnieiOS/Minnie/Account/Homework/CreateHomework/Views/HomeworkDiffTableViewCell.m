//
//  HomeworkDiffTableViewCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/25.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "HomeworkDiffTableViewCell.h"

@interface HomeworkDiffTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *easyLabel;
@property (weak, nonatomic) IBOutlet UILabel *normalLabel;
@property (weak, nonatomic) IBOutlet UILabel *diffcultLabel;

@property (nonatomic,strong) UILabel * currentLabel;

@end

@implementation HomeworkDiffTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)diffBtnClick:(UIButton *)sender {
    
    self.easyLabel.backgroundColor = [UIColor clearColor];
    
    switch (sender.tag) 
    {
        case 100:
            self.easyLabel.backgroundColor = [UIColor colorWithHex:0x00CE00];
            self.currentLabel = self.easyLabel;
            break;
        case 101:
            self.normalLabel.backgroundColor = [UIColor colorWithHex:0x00CE00];
            self.currentLabel = self.easyLabel;
            break;
        case 102:
            self.diffcultLabel.backgroundColor = [UIColor colorWithHex:0x00CE00];
            self.currentLabel = self.easyLabel;
            break;
        default:
            break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
