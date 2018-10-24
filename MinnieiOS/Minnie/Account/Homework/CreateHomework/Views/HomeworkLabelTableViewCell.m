//
//  HomeworkLabelTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/1/24.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "HomeworkLabelTableViewCell.h"

NSString * const HomeworkLabelTableViewCellId = @"HomeworkLabelTableViewCellId";
CGFloat const HomeworkLabelTableViewCellHeight = 37.f;

@interface HomeworkLabelTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *tipLabel;

@end

@implementation HomeworkLabelTableViewCell

- (void)setupWithText:(NSString *)text {
    self.tipLabel.text = text;
}
@end

