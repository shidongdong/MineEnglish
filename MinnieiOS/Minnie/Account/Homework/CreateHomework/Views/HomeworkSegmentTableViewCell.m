//
//  HomeworkSegmentTableViewCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/25.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "HomeworkSegmentTableViewCell.h"

NSString * const HomeworkSegmentTableViewCellId = @"HomeworkSegmentTableViewCellId";

@interface HomeworkSegmentTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UILabel *thirdTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *fourTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixTypeLabel;

@property (nonatomic, strong) UILabel * currentLabel;

@end


@implementation HomeworkSegmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.firstView.layer.cornerRadius = 12.0;
    self.secondView.layer.cornerRadius = 12.0;
    // Initialization code
}

- (IBAction)homeworkTypeClick:(UIButton *)sender {
    
    self.currentLabel.backgroundColor = [UIColor clearColor];
    switch (sender.tag)
    {
        case 100:
            self.firstTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentLabel = self.firstTypeLabel;
            break;
        case 101:
            self.secondTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentLabel = self.secondTypeLabel;
            break;
        case 102:
            self.thirdTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentLabel = self.thirdTypeLabel;
            break;
        case 103:
            self.fourTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentLabel = self.fourTypeLabel;
            break;
        case 104:
            self.fiveTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentLabel = self.fiveTypeLabel;
            break;
        case 105:
            self.sixTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentLabel = self.sixTypeLabel;
            break;
        default:
            break;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setContentData:(NSArray *)datas atDefultIndex:(NSInteger)index
//{
//    
//}

@end
