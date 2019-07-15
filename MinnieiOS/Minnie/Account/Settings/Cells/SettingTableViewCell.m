//
//  SettingTableViewCell.m
//  X5
//
//  Created by yebw on 2017/8/28.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "SettingTableViewCell.h"

CGFloat const SettingTableViewCellHeight = 56.f;
NSString * const SettingTableViewCellId = @"SettingTableViewCellId";

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setupSelectedState:(BOOL)state{
    
    if (state) {
        self.backgroundColor = [UIColor selectedColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
