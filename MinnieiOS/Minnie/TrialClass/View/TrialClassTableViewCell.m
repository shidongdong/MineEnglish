//
//  TrialClassTableViewCell.m
//  MinnieStudent
//
//  Created by yebw on 2018/4/13.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "TrialClassTableViewCell.h"
#import "Utils.h"

NSString * const TrialClassTableViewCellId = @"TrialClassTableViewCellId";
CGFloat const TrialClassTableViewCellHeight = 52;

@interface TrialClassTableViewCell()

@property (nonatomic, weak) IBOutlet UIButton *classButton;

@end

@implementation TrialClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.classButton.layer.cornerRadius = 22.f;
    self.classButton.layer.masksToBounds = YES;
    self.classButton.layer.borderColor = [UIColor colorWithHex:0x00CE00].CGColor;
    self.classButton.layer.borderWidth = 1.f;
}

- (void)setupWithClass:(Clazz *)clazz {
    if (self.choice) {
        [self.classButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0x00CE00]] forState:UIControlStateNormal];
        [self.classButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [self.classButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0x00CE00]] forState:UIControlStateNormal];
        [self.classButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    long long time = [clazz.dates[0] longLongValue];
    NSString *date = [Utils montAndDateTime:time];
    
    NSString *duration = [NSString stringWithFormat:@"%@-%@", clazz.startTime, clazz.endTime];
    
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@", date, duration, clazz.name];
    
    [self.classButton setTitle:title forState:UIControlStateNormal];
}

- (void)setChoice:(BOOL)choice {
    _choice = choice;
    
    if (choice) {
        [self.classButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0x00CE00]] forState:UIControlStateNormal];
        [self.classButton setBackgroundImage:[Utils imageWithColor:[UIColor colorWithHex:0x00CE00]] forState:UIControlStateHighlighted];
        [self.classButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [self.classButton setBackgroundImage:[Utils imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.classButton setBackgroundImage:[Utils imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        [self.classButton setTitleColor:[UIColor colorWithHex:0x00CE00] forState:UIControlStateNormal];
    }
}

- (IBAction)classButtonPressed:(id)sender {
    if (self.choice) {
        return;
    }
    
    if (self.callback != nil) {
        self.callback();
    }
    
    [self setChoice:YES];
}

@end
