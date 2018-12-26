//
//  HomeworkSegmentTableViewCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/10/25.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "HomeworkSegmentTableViewCell.h"

NSString * const HomeworkSegmentTableViewCellId = @"HomeworkSegmentTableViewCellId";
CGFloat const HomeworkTypeTableViewCellHeight = 200.f;


@interface HomeworkSegmentTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UILabel *thirdTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *fourTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sevenTypeLabel;

@property (nonatomic, strong) UILabel * currentCateLabel;
@property (nonatomic, strong) UILabel * currentStyleLabel;
@end


@implementation HomeworkSegmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.firstView.layer.cornerRadius = 12.0;
    self.secondView.layer.cornerRadius = 12.0;
    
    self.firstTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
    self.firstTypeLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    self.currentCateLabel = self.firstTypeLabel;
    
    self.fourTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
    self.fourTypeLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    self.currentStyleLabel = self.fourTypeLabel;
    
    
    // Initialization code
}

- (IBAction)homeworkTypeClick:(UIButton *)sender {
    
    if (sender.tag < 103)
    {
        self.currentCateLabel.backgroundColor = [UIColor clearColor];
        self.currentCateLabel.textColor = [UIColor colorWithHex:0x999999];
    }
    else
    {
        self.currentStyleLabel.backgroundColor = [UIColor clearColor];
        self.currentStyleLabel.textColor = [UIColor colorWithHex:0x999999];
    }
    
    switch (sender.tag)
    {
        case 100:
            self.firstTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentCateLabel = self.firstTypeLabel;
            break;
        case 101:
            self.secondTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentCateLabel = self.secondTypeLabel;
            break;
        case 102:
            self.thirdTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentCateLabel = self.thirdTypeLabel;
            break;
        case 103:
            self.fourTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentStyleLabel = self.fourTypeLabel;
            break;
        case 104:
            self.fiveTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentStyleLabel = self.fiveTypeLabel;
            break;
        case 105:
            self.sixTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentStyleLabel = self.sixTypeLabel;
            break;
        case 106:
            self.sevenTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentStyleLabel = self.sevenTypeLabel;
            break;
        default:
            break;
    }
    
    if (sender.tag < 103)
    {
        self.currentCateLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    }
    else
    {
        self.currentStyleLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    }
    
    if (self.selectCallback)
    {
        self.selectCallback(sender.tag - 100);
    }
    
}

- (void)updateHomeworkCategoryType:(NSInteger)category withStyleType:(NSInteger)style
{
    self.currentCateLabel.backgroundColor = [UIColor clearColor];
    self.currentCateLabel.textColor = [UIColor colorWithHex:0x999999];
    
    self.currentStyleLabel.backgroundColor = [UIColor clearColor];
    self.currentStyleLabel.textColor = [UIColor colorWithHex:0x999999];
    
    switch (category) {
        case 0:
            self.firstTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentCateLabel = self.firstTypeLabel;
            break;
        case 1:
            self.secondTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentCateLabel = self.secondTypeLabel;
            break;
        case 2:
            self.thirdTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentCateLabel = self.thirdTypeLabel;
            break;
    }
    
    switch (style) {
        case 0:
            self.fourTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentStyleLabel = self.fourTypeLabel;
            break;
        case 1:
            self.fiveTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentStyleLabel = self.fiveTypeLabel;
            break;
        case 2:
            self.sixTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentStyleLabel = self.sixTypeLabel;
            break;
        case 3:
            self.sevenTypeLabel.backgroundColor = [UIColor colorWithHex:0x0098FE];
            self.currentStyleLabel = self.sevenTypeLabel;
            break;

    }
    self.currentCateLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    self.currentStyleLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
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
