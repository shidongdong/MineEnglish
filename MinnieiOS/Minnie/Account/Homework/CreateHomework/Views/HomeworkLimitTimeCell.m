//
//  HomeworkLimitTimeCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/12.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "HomeworkLimitTimeCell.h"
NSString * const HomeworkLimitTimeCellId = @"HomeworkLimitTimeCellId";
CGFloat const HomeworkTimeLimitTableViewCellHeight = 103.f;

@interface HomeworkLimitTimeCell()

@property (weak, nonatomic) IBOutlet UIView *bgContentView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation HomeworkLimitTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgContentView.layer.cornerRadius = 12.0;
    self.bgContentView.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    self.bgContentView.layer.borderWidth = 0.5;
    // Initialization code
}

- (void)updateTimeLabel:(NSInteger)sec
{
    NSInteger secIndex = sec % 60;
    NSInteger minIndex = sec / 60;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%ld分02%ld秒",minIndex,secIndex];
}

- (IBAction)selectTimePress:(UIButton *)sender {
    
    if (self.timeCallback)
    {
        self.timeCallback();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
