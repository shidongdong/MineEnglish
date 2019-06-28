//
//  MISecondActivityTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "NSDate+X5.h"
#import "NSDate+Extension.h"
#import "MISecondActivityTableViewCell.h"

CGFloat const MISecondActivityTableViewCellHeight = 70.f;

NSString * const MISecondActivityTableViewCellId = @"MISecondActivityTableViewCellId";


@interface MISecondActivityTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *endButton;

@end


@implementation MISecondActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.endButton.layer.masksToBounds = YES;
    self.endButton.layer.cornerRadius = 20.0;
}

- (void)setupWithModel:(ActivityInfo *)model selected:(BOOL)selected{
    
    self.titleLabel.text = model.title;
    // 活动是否结束
    NSDate *endDate = [NSDate dateByDateString:model.endTime format:@"yyyy-MM-dd HH:mm:ss"];
    if ([[endDate dateAtStartOfDay] isEarlierThanDate:[[NSDate date] dateAtStartOfDay]]) {
        self.endButton.hidden = NO;
    } else {
        self.endButton.hidden = YES;
    }
    // 活动时间
    if (model.startTime.length >= 10 && model.endTime.length >= 10) {
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[model.startTime substringToIndex:10] ,[model.endTime substringToIndex:10]];
    }
    if (selected) {
        self.titleLabel.textColor = [UIColor mainColor];
        self.timeLabel.textColor = [UIColor mainColor];
        [self.endButton setBackgroundColor:[UIColor mainColor]];
        self.backgroundColor = [UIColor colorWithHex:0xF2FAFF];
    } else {
        self.titleLabel.textColor = [UIColor detailColor];
        self.timeLabel.textColor = [UIColor detailColor];
        [self.endButton setBackgroundColor:[UIColor detailColor]];
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (IBAction)endAction:(id)sender {
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
