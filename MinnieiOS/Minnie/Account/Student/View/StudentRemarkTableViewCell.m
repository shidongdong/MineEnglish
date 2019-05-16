//
//  StudentRemarkTableViewCell.m
//  MinnieStudent
//
//  Created by songzhen on 2019/5/14.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "StudentRemarkTableViewCell.h"

NSString * const StudentRemarkCellId = @"StudentRemarkTableViewCellId";

@interface StudentRemarkTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *starCountBtn;

@end

@implementation StudentRemarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.starCountBtn.layer.cornerRadius = 10;
    self.starCountBtn.layer.borderWidth = 1.0;
    self.starCountBtn.layer.borderColor = [UIColor colorWithHex:0x333333].CGColor;
    
    self.contentLabel.numberOfLines = 0;
}


- (void)setCellTitle:(NSString *)title withContent:(NSString *)content{
    
    self.titleLabel.text = title;
   
    if (content.length) {
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 5;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:content];
        [att setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSParagraphStyleAttributeName:style} range:NSMakeRange(0, content.length)];
        self.contentLabel.attributedText = att;
    }
}

- (IBAction)starCountAction:(id)sender {
    
    if (self.callback) {
        
        self.callback();
    }
}

+ (CGFloat)cellHeightWithTitle:(NSString *)title withContent:(NSString *)content{
    
    static StudentRemarkTableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StudentRemarkTableViewCell" owner:nil options:nil] lastObject];
    });
    [cell setCellTitle:title withContent:content];
    CGSize size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
