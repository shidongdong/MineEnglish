//
//  MISecondReaTimeTaskTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/7/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MISecondReaTimeTaskTableViewCell.h"

CGFloat const MISecondReaTimeTaskTableViewCellHeight = 50;
NSString * const MISecondReaTimeTaskTableViewCellId = @"MISecondReaTimeTaskTableViewCellId";


@interface MISecondReaTimeTaskTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *IcomImagV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation MISecondReaTimeTaskTableViewCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.IcomImagV.layer.cornerRadius = 16;
    self.IcomImagV.layer.masksToBounds = YES;
}
- (void)setupTitle:(NSString *)title icon:(NSString *)icon selectState:(BOOL)state{
    
    self.titleLabel.text = title;
    [self.IcomImagV sd_setImageWithURL:[icon imageURLWithWidth:32] placeholderImage:[UIImage imageNamed:@"attachment_placeholder"]];
    if (state) {
        self.backgroundColor = [UIColor mainColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor detailColor];
    }
}
@end
