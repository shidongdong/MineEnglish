//
//  HomeworkDiffTableViewCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/25.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "HomeworkDiffTableViewCell.h"
NSString * const HomeworkDiffTableViewCellId = @"HomeworkDiffTableViewCellId";
CGFloat const HomeworkDiffcultTableViewCellHeight = 103.f;


@interface HomeworkDiffTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *easyLabel;
@property (weak, nonatomic) IBOutlet UILabel *normalLabel;
@property (weak, nonatomic) IBOutlet UILabel *diffcultLabel;
@property (weak, nonatomic) IBOutlet UIView *bgContentView;

@property (nonatomic,strong) UILabel * currentLabel;

@end

@implementation HomeworkDiffTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgContentView.layer.cornerRadius = 12.0;
    
    self.easyLabel.backgroundColor = [UIColor colorWithHex:0x00CE00];
    self.easyLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    self.currentLabel = self.easyLabel;
    
    // Initialization code
}
- (IBAction)diffBtnClick:(UIButton *)sender {
    
    self.currentLabel.backgroundColor = [UIColor clearColor];
    self.currentLabel.textColor = [UIColor colorWithHex:0x999999];
    switch (sender.tag) 
    {
        case 100:
            self.easyLabel.backgroundColor = [UIColor colorWithHex:0x00CE00];
            self.currentLabel = self.easyLabel;
            break;
        case 101:
            self.normalLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentLabel = self.normalLabel;
            break;
        case 102:
            self.diffcultLabel.backgroundColor = [UIColor colorWithHex:0xFF4858];
            self.currentLabel = self.diffcultLabel;
            break;
        default:
            break;
    }
    
    self.currentLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    
    if (self.selectCallback)
    {
        self.selectCallback(sender.tag - 100);
    }
    
}

- (void)updateHomeworkLevel:(NSInteger)level
{
    self.currentLabel.backgroundColor = [UIColor clearColor];
    self.currentLabel.textColor = [UIColor colorWithHex:0x999999];
    
    switch (level)
    {
        case 0:
            self.easyLabel.backgroundColor = [UIColor colorWithHex:0x00CE00];
            self.currentLabel = self.easyLabel;
            break;
        case 1:
            self.normalLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentLabel = self.normalLabel;
            break;
        case 2:
            self.diffcultLabel.backgroundColor = [UIColor colorWithHex:0xFF4858];
            self.currentLabel = self.diffcultLabel;
            break;
        default:
            break;
    }
    
    self.currentLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
