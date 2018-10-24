//
//  DeleteClassTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2018/2/3.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "DeleteClassTableViewCell.h"

NSString * const DeleteClassTableViewCellId = @"DeleteClassTableViewCellId";
CGFloat const DeleteClassTableViewCellHeight = 56.f;

@implementation DeleteClassTableViewCell

- (IBAction)deleteButtonPressed:(id)sender {
    if (self.callback != nil) {
        self.callback();
    }
}

@end
