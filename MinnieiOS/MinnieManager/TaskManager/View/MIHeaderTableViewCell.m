//
//  HeaderTableViewCell.m
//  Manager
//
//  Created by songzhen on 2019/5/27.
//  Copyright © 2019 songzhen. All rights reserved.
//

#import "MIHeaderTableViewCell.h"

@interface MIHeaderTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation MIHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerViewDidCellClicked:)]) {
        [self.delegate headerViewDidCellClicked:_section];
    }
}

- (IBAction)addBtnClicked:(id)sender {
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerViewAddClicked:)]) {
        [self.delegate headerViewAddClicked:_section];
    }
}

- (void)setTypeModel:(MIFirLevelFolderModel *)typeModel{
    _typeModel = typeModel;
    if (_typeModel.isOpen) {
        self.titleLabel.textColor = [UIColor mainColor];
        [self.addBtn setImage:[UIImage imageNamed:@"ic_add_blue"] forState:UIControlStateNormal];
    } else {
        self.titleLabel.textColor = [UIColor normalColor];
        [self.addBtn setImage:[UIImage imageNamed:@"ic_add_black"] forState:UIControlStateNormal];
    }
    if (_typeModel.folderArray.count == 0) {
        self.addBtn.hidden = YES;
    } else {
        self.addBtn.hidden = NO;
    }
    self.titleLabel.text = _typeModel.title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
