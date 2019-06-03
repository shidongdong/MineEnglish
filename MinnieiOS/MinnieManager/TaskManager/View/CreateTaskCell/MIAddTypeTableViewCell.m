//
//  MIAddTypeTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIAddTypeTableViewCell.h"

NSString * const MIAddTypeTableViewCellId = @"MIAddTypeTableViewCellId";
CGFloat const MIAddTypeTableViewCellHeight = 60.f;

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
}


- (void)setupWithCreateType:(MIHomeworkCreateContentType)createType{
    
    if (createType == MIHomeworkCreateContentType_Add) {
        
        [self.addButton setTitle:@"" forState:UIControlStateNormal];
        [self.addButton setImage:[UIImage imageNamed:@"ic_add_small"] forState:UIControlStateNormal];
        self.addButton.layer.borderColor = [UIColor mainColor].CGColor;
    } else if (createType == MIHomeworkCreateContentType_Delete) {
        [self.addButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.addButton setImage:[UIImage imageNamed:@" "] forState:UIControlStateNormal];
        self.addButton.layer.borderColor = [UIColor redColor].CGColor;
    }
}
- (IBAction)addBtnAction:(id)sender {
    
    if (self.addCallback) {
        self.addCallback();
    }
}

@end
