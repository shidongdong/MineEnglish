//
//  CorrectHomeworkScoreTableViewCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/12/24.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "CorrectHomeworkScoreTableViewCell.h"

NSString * const CorrectHomeworkScoreTableViewCellId = @"CorrectHomeworkScoreTableViewCellId";
CGFloat const CorrectHomeworkScoreTableViewCellHeight = 39.0f;

@interface CorrectHomeworkScoreTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *oneStarView;
@property (weak, nonatomic) IBOutlet UIView *twoStarView;
@property (weak, nonatomic) IBOutlet UIView *threeStarView;
@property (weak, nonatomic) IBOutlet UIView *fourStarView;
@property (weak, nonatomic) IBOutlet UIView *fiveStarView;
@property (weak, nonatomic) IBOutlet UIView *zeroStarView;
@property (weak, nonatomic) IBOutlet UIView *shareView;

@property (nonatomic, assign)NSInteger lastSelectedScore;   //上次选中的分数
@property (nonatomic, assign)NSInteger bShareCircle;            //分享到朋友圈

@property (nonatomic, assign)NSInteger homeworkLevel;

@end

@implementation CorrectHomeworkScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.oneStarView.layer.cornerRadius = 4.0;
    self.oneStarView.layer.borderColor = [UIColor colorWithHex:0xDDDDDD].CGColor;
    self.oneStarView.layer.borderWidth = 1.0;
    self.twoStarView.layer.cornerRadius = 4.0;
    self.twoStarView.layer.borderColor = [UIColor colorWithHex:0xDDDDDD].CGColor;
    self.twoStarView.layer.borderWidth = 1.0;
    self.threeStarView.layer.cornerRadius = 4.0;
    self.threeStarView.layer.borderColor = [UIColor colorWithHex:0xDDDDDD].CGColor;
    self.threeStarView.layer.borderWidth = 1.0;
    self.fourStarView.layer.cornerRadius = 4.0;
    self.fourStarView.layer.borderColor = [UIColor colorWithHex:0xDDDDDD].CGColor;
    self.fourStarView.layer.borderWidth = 1.0;
    self.fiveStarView.layer.cornerRadius = 4.0;
    self.fiveStarView.layer.borderColor = [UIColor colorWithHex:0xDDDDDD].CGColor;
    self.fiveStarView.layer.borderWidth = 1.0;
    self.zeroStarView.layer.cornerRadius = 4.0;
    self.zeroStarView.layer.borderColor = [UIColor colorWithHex:0xDDDDDD].CGColor;
    self.zeroStarView.layer.borderWidth = 1.0;
    self.shareView.layer.cornerRadius = 4.0;
    self.shareView.layer.borderColor = [UIColor colorWithHex:0xDDDDDD].CGColor;
    self.shareView.layer.borderWidth = 1.0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateRecommendScoreHomeworkLevel:(NSInteger)level
{
    self.homeworkLevel = level;
    switch (level) {
        case 0:
        {
            self.twoStarView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
            UIButton * twoStarBtn = [self viewWithTag:100 + 2];
            [twoStarBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
            self.threeStarView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
            UIButton * threeStarBtn = [self viewWithTag:100 + 3];
            [threeStarBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
            self.fourStarView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
            UIButton * fourStarBtn = [self viewWithTag:100 + 4];
            [fourStarBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
            self.fiveStarView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
            UIButton * fiveStarBtn = [self viewWithTag:100 + 5];
            [fiveStarBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
            break;
        }
        case 1:
        {
            self.threeStarView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
            UIButton * threeStarBtn = [self viewWithTag:100 + 3];
            [threeStarBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
            self.fourStarView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
            UIButton * fourStarBtn = [self viewWithTag:100 + 4];
            [fourStarBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
            self.fiveStarView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
            UIButton * fiveStarBtn = [self viewWithTag:100 + 5];
            [fiveStarBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
            break;
        }
        case 2:
        {
            self.fourStarView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
            UIButton * fourStarBtn = [self viewWithTag:100 + 4];
            [fourStarBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
            self.fiveStarView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
            UIButton * fiveStarBtn = [self viewWithTag:100 + 5];
            [fiveStarBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
            break;
        }
        case 3:
        {
            self.fiveStarView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
            UIButton * fiveStarBtn = [self viewWithTag:100 + 5];
            [fiveStarBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
            break;
        }
        case 4:
            
            break;
    }
}


- (IBAction)scorePressed:(UIButton *)sender {
    
    if (self.lastSelectedScore == sender.tag - 100)
    {
        return;
    }
    
    if (self.lastSelectedScore <= self.homeworkLevel + 1)
    {
        UIView * lastScoreView = (UIView *)[self viewWithTag:self.lastSelectedScore + 200];
        lastScoreView.backgroundColor = [UIColor colorWithHex:0XFFFFFF];
        
        UIButton * lastScoreBtn = (UIButton *)[self viewWithTag:self.lastSelectedScore + 100];
        [lastScoreBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    }
    else
    {
        UIView * lastScoreView = (UIView *)[self viewWithTag:self.lastSelectedScore + 200];
        lastScoreView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
        
        UIButton * lastScoreBtn = (UIButton *)[self viewWithTag:self.lastSelectedScore + 100];
        [lastScoreBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    }
    
    switch (sender.tag) {
        case 100:
            self.zeroStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
        case 101:
            self.oneStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
        case 102:
            self.twoStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
        case 103:
            self.threeStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
        case 104:
            self.fourStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
        case 105:
            self.fiveStarView.backgroundColor = [UIColor colorWithHex:0x00CE00];
            break;
    }
    
    [sender setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    
    self.lastSelectedScore = sender.tag - 100;
    
    if (self.scoreCallback)
    {
        self.scoreCallback(self.lastSelectedScore);
    }
    
}

- (IBAction)shareCirclePressed:(id)sender {
    
    self.bShareCircle = self.bShareCircle == 1 ? 0 : 1;
    
    if (self.bShareCircle) {
        self.shareView.backgroundColor = [UIColor colorWithHex:0x00CE00];
        [sender setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    }
    else
    {
        self.shareView.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
        [sender setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    }
    
    if (self.shareCallback)
    {
        self.shareCallback(self.bShareCircle);
    }
    
}


@end