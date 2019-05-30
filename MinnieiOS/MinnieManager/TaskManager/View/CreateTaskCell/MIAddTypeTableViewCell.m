//
//  MIAddTypeTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIAddTypeTableViewCell.h"

NSString * const MIAddTypeTableViewCellId = @"MIAddTypeTableViewCellId";
CGFloat const MIAddTypeTableViewCellHeight = 78.f;

@interface MIAddTypeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation MIAddTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.addButton.layer.cornerRadius = 12.f;
    self.addButton.layer.masksToBounds = NO;
    
    self.addButton.layer.borderWidth = 1.f;
    self.addButton.layer.borderColor = [UIColor colorWithHex:0x0098FE].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addBtnAction:(id)sender {
    
    if (self.addCallback) {
        self.addCallback();
    }
}

@end
