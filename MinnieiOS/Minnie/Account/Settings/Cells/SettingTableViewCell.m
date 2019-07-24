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

@interface SettingTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *rightLineView;

@end

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setupSelectedState:(BOOL)state{
    
    if (state) {
        self.rightLineView.hidden = NO;
        self.backgroundColor = [UIColor selectedColor];
    } else {
        self.rightLineView.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
