//
//  HomeworkDiffTableViewCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/25.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "HomeworkDiffTableViewCell.h"
NSString * const HomeworkDiffTableViewCellId = @"HomeworkDiffTableViewCellId";
CGFloat const HomeworkDiffcultTableViewCellHeight = 173.f;


@interface HomeworkDiffTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *oneStarView;
@property (weak, nonatomic) IBOutlet UIView *twoStarView;
@property (weak, nonatomic) IBOutlet UIView *threeStarView;
@property (weak, nonatomic) IBOutlet UIView *fourStarView;
@property (weak, nonatomic) IBOutlet UIView *fiveStarView;


@property (nonatomic,assign) NSInteger lastIndex;

@end

@implementation HomeworkDiffTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.oneStarView.layer.cornerRadius = 12.0;
    self.twoStarView.layer.cornerRadius = 12.0;
    self.threeStarView.layer.cornerRadius = 12.0;
    self.fourStarView.layer.cornerRadius = 12.0;
    self.fiveStarView.layer.cornerRadius = 12.0;
    
    self.lastIndex = -1;
    // Initialization code
}
- (IBAction)diffBtnClick:(UIButton *)sender {
    
    if (sender.tag - 100 == self.lastIndex)
    {
        return;
    }
    
    UIView * lastView = [self viewWithTag:self.lastIndex + 200];
    lastView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    UIButton * lastBtn = [self viewWithTag:self.lastIndex + 100];
    [lastBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    
    switch (sender.tag) 
    {
        case 100:
            self.oneStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
        case 101:
            self.twoStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
        case 102:
            self.threeStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
        case 103:
            self.fourStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
        case 104:
            self.fiveStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
    }
    
    [sender setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    
    self.lastIndex = sender.tag - 100;
    
    if (self.selectCallback)
    {
        self.selectCallback(self.lastIndex);
    }
    
}

- (void)updateHomeworkLevel:(NSInteger)level
{
    
    if (level == self.lastIndex)
    {
        return;
    }
    
    UIView * lastView = [self viewWithTag:self.lastIndex + 200];
    lastView.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    UIButton * lastBtn = [self viewWithTag:self.lastIndex + 100];
    [lastBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    
    switch (level)
    {
        case 0:
            self.oneStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
        case 1:
            self.twoStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
        case 2:
            self.threeStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
        case 3:
            self.fourStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
        case 4:
            self.fiveStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
    }
    
    UIButton * selectBtn = [self viewWithTag:level + 100];
    [selectBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    
    self.lastIndex = level;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
