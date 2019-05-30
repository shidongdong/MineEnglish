//
//  MITitleTypeTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/30.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MITitleTypeTableViewCell.h"

CGFloat const MITitleTypeTableViewCellHeight = 37.f;

NSString * const MITitleTypeTableViewCellId = @"MITitleTypeTableViewCellId";


@interface MITitleTypeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MITitleTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setTitle:(NSString *)title{
    
    _title = title;
    self.titleLabel.text = _title;
}

@end
