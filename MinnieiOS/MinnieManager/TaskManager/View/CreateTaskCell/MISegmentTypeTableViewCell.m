//
//  MISegmentTypeTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MISegmentTypeTableViewCell.h"

CGFloat const MISegmentTypeTableViewCellHeight = 84.f;

NSString * const MISegmentTypeTableViewCellId = @"MISegmentTypeTableViewCellId";

@interface MISegmentTypeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fiveSegment;

@end

@implementation MISegmentTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.segment.layer.cornerRadius = 12;
    self.segment.layer.masksToBounds = YES;
    
    self.fiveSegment.layer.cornerRadius = 12;
    self.fiveSegment.layer.masksToBounds = YES;
//
    self.segment.tintColor = [UIColor clearColor];
    NSDictionary *dicOne = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor mainColor]};
    [self.segment setTitleTextAttributes:dicOne forState:UIControlStateNormal];

    NSDictionary *dicTwo = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.segment setTitleTextAttributes:dicTwo forState:UIControlStateSelected];
    self.segment.backgroundColor = [UIColor unSelectedColor];
    [self.segment setBackgroundImage:[UIImage imageNamed:@"mainColor"]
                                 forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];

    self.fiveSegment.tintColor = [UIColor clearColor];
    [self.fiveSegment setTitleTextAttributes:dicOne forState:UIControlStateNormal];
    [self.fiveSegment setTitleTextAttributes:dicTwo forState:UIControlStateSelected];
    self.fiveSegment.backgroundColor = [UIColor unSelectedColor];
    [self.fiveSegment setImage:[UIImage imageNamed:@"mainColor"] forSegmentAtIndex:2];
    [self.fiveSegment setBackgroundImage:[UIImage imageNamed:@"mainColor"]
                                                                                          forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
}

- (void)setupWithSelectIndex:(NSInteger)index
                  createType:(MIHomeworkCreateContentType)createType{
 
    
    if (createType == MIHomeworkCreateContentType_CommitCount) {
        
        self.titleLabel.text = @"可提交次数:";
        [self showFiveSegment:index];
    } else if (createType == MIHomeworkCreateContentType_ExaminationType) {
        
        self.titleLabel.text = @"考试类型:";
        [self showTwoSegment:index];
    } else if (createType == MIHomeworkCreateContentType_HomeworkDifficulty) {
        
        self.titleLabel.text = @"作业难度:";
        [self showFiveSegment:index];
    } else if (createType == MIHomeworkCreateContentType_StatisticalType) {
       
        self.titleLabel.text = @"统计类型:";
        [self showTwoSegment:index];
    } else if (createType == MIHomeworkCreateContentType_ExaminationType) {
        
        self.titleLabel.text = @"考试类型:";
        [self showTwoSegment:index];
    } else if (createType == MIHomeworkCreateContentType_CommitTime){
        
        self.titleLabel.text = @"选择提交时间:";
        [self showFiveSegment:index];
    }
}

- (void)showTwoSegment:(NSInteger)index{
    
    self.segment.hidden = NO;
    self.fiveSegment.hidden = YES;
    self.segment.selectedSegmentIndex = index;
}

- (void)showFiveSegment:(NSInteger)index{
    
    self.segment.hidden = YES;
    self.fiveSegment.hidden = NO;
    self.fiveSegment.selectedSegmentIndex = index;
}

- (IBAction)segmentAction:(id)sender {
    
    if (self.callback) {
        
        self.callback(self.segment.selectedSegmentIndex);
    }
}
- (IBAction)fiveSegmentAction:(id)sender {
  
    if (self.callback) {
        
        self.callback(self.fiveSegment.selectedSegmentIndex);
    }
}

@end
