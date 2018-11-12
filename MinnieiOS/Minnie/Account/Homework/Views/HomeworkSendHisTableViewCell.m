//
//  HomeworkSendHisTableViewCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/1.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "HomeworkSendHisTableViewCell.h"

#define KContainerViewTopSpace  10.0f
#define KContainerViewBottomSpace  10.0f

#define KTimeLabelSpace 30.0f

NSString * const HomeworkSendHisTableViewCellId = @"HomeworkSendHisTableViewCellId";

@interface HomeworkSendHisTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation HomeworkSendHisTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (CGFloat)calculateCellHightForData:(id)data
{
    return KContainerViewTopSpace + KContainerViewBottomSpace + KTimeLabelSpace;
}

- (void)setContentData:(id)data
{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
