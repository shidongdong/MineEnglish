//
//  ClassScheduleAndStudentsTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "ClassScheduleAndStudentsTableViewCell.h"

NSString * const ClassScheduleAndStudentsTableViewCellId = @"ClassScheduleAndStudentsTableViewCellId";
CGFloat const ClassScheduleAndStudentsTableViewCellHeight = 100.f;

@interface ClassScheduleAndStudentsTableViewCell()

@property (nonatomic, weak) IBOutlet UIView *addScheduleView;
@property (nonatomic, weak) IBOutlet UIView *addStudentsView;
@property (nonatomic, weak) IBOutlet UIView *manageScheduleView;
@property (nonatomic, weak) IBOutlet UIView *managerStudentsView;

@property (nonatomic, weak) IBOutlet UIImageView *startDateBGImageView;
@property (nonatomic, weak) IBOutlet UILabel *startDateLabel;
@property (nonatomic, weak) IBOutlet UIImageView *endDateBGImageView;
@property (nonatomic, weak) IBOutlet UILabel *endDateLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *addStudentsViewConstraint;

@end

@implementation ClassScheduleAndStudentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.startDateBGImageView.layer.cornerRadius = 12.f;
    self.startDateBGImageView.layer.masksToBounds = YES;
    self.endDateBGImageView.layer.cornerRadius = 12.f;
    self.endDateBGImageView.layer.masksToBounds = YES;
}

- (void)setupWithClass:(Clazz *)clazz {
    self.addScheduleView.hidden = clazz.dates.count >= 1;
    self.manageScheduleView.hidden = clazz.dates.count <= 0;

    if (clazz.dates.count >= 1) {
        NSNumber *start = clazz.dates[0];
        NSNumber *end = clazz.dates[clazz.dates.count-1];
        
        self.startDateLabel.text = [[self class] formatedDateString:start];
        self.endDateLabel.text = [[self class] formatedDateString:end];
    } else {
        self.startDateLabel.text = nil;
        self.endDateLabel.text = nil;
    }
    
    if (clazz.classId == 0 || clazz.isFinished) {
        self.addStudentsViewConstraint.constant = 0;
    } else {
        self.addStudentsViewConstraint.constant = 44.f;
    }
    
    self.addStudentsView.hidden = clazz.students.count > 0;
    self.managerStudentsView.hidden = clazz.students.count == 0;
}

+ (NSString *)formatedDateString:(NSNumber *)dateNumber {
    double microSeconds = [dateNumber doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:microSeconds/1000];
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }

    [dateFormatter setDateFormat:@"yyyy/M/d"];
    return [dateFormatter stringFromDate:date];
}

- (IBAction)managerScheduleButtonPressed:(id)sender {
    if (self.managerScheduleCallback != nil) {
        self.managerScheduleCallback();
    }
}

- (IBAction)addScheduleButtonPressed:(id)sender {
    if (self.managerScheduleCallback != nil) {
        self.managerScheduleCallback();
    }
}

- (IBAction)managerStudentsButtonPressed:(id)sender {
    if (self.managerStudentsCallback != nil) {
        self.managerStudentsCallback();
    }
}

- (IBAction)addStudentsButtonPressed:(id)sender {
    if (self.managerStudentsCallback != nil) {
        self.managerStudentsCallback();
    }
}

@end

