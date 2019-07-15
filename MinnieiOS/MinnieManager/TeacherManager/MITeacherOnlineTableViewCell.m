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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
