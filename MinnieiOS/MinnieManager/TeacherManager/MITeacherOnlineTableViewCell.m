//
//  MITeacherOnlineTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/15.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MITeacherOnlineTableViewCell.h"

NSString * const MITeacherOnlineTableViewCellId = @"MITeacherOnlineTableViewCellId";
CGFloat const MITeacherOnlineTableViewCellHeight = 80;


@interface MITeacherOnlineTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *todayTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthTimeLabel;
@end

@implementation MITeacherOnlineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setupTimeWithTeacher:(TeacherDetail *)teacher{
    
    if (teacher.onlineDetail.count >=3) {
        
        NSString *today = teacher.onlineDetail[0];
        self.todayTimeLabel.text = [NSString stringWithFormat:@"%.2d时%.2d分",today.intValue/60,today.intValue%60];
        
        NSString *week = teacher.onlineDetail[1];
        self.weekTimeLabel.text = [NSString stringWithFormat:@"%.2d时%.2d分",week.intValue/60,week.intValue%60];
        
        NSString *month = teacher.onlineDetail[2];
        self.monthTimeLabel.text = [NSString stringWithFormat:@"%.2d时%.2d分",month.intValue/24,week.intValue%24];
    } else {
        
        self.todayTimeLabel.text = @"0分";
        self.weekTimeLabel.text = @"0时0分";
        self.monthTimeLabel.text = @"0天0时";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
