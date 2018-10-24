//
//  DeleteClassTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/2/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "FinishClassTableViewCell.h"

NSString * const FinishClassTableViewCellId = @"FinishClassTableViewCellId";
CGFloat const FinishClassTableViewCellHeight = 56.f;

@implementation FinishClassTableViewCell

- (IBAction)finishButtonPressed:(id)sender {
    if (self.callback != nil) {
        self.callback();
    }
}

@end
