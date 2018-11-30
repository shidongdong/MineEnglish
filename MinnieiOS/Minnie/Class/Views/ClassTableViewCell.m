//
//  ClassTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2017/12/16.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "ClassTableViewCell.h"
#import "UIColor+HEX.h"

NSString * const ClassTableViewCellId = @"ClassTableViewCellId";
CGFloat const ClassTableViewCellHeight = 100.f;

@interface ClassTableViewCell()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic, weak) IBOutlet UIImageView *classIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *classNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *nextTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *circleCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *postedHomeworksCountLabel;


@end

@implementation ClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.containerView.layer.cornerRadius = 12.f;
    self.containerView.layer.shadowOpacity = 0.4;// 阴影透明度
    self.containerView.layer.shadowColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.containerView.layer.shadowRadius = 3;
    self.containerView.layer.shadowOffset = CGSizeMake(2, 4);
}

- (void)setupWithClass:(Clazz *)clazz {
    self.classNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", clazz.name, @(clazz.studentsCount)];
    
    if (clazz.nextClassTime == 0) {
        self.nextTimeLabel.text = nil;
    } else {
        self.nextTimeLabel.text = [Utils dateFormatterTime:clazz.nextClassTime];
    }

    self.locationLabel.text = clazz.location;
    
    self.circleCountLabel.text = [NSString stringWithFormat:@"%@", @(clazz.circleCount)];
    self.postedHomeworksCountLabel.text = [NSString stringWithFormat:@"%@", @(clazz.homeworksCount)];
//    self.unhandledHomeworksCountLabel.text = [NSString stringWithFormat:@"%@", @(clazz.uncorrectedHomeworksCount)];
}

@end
