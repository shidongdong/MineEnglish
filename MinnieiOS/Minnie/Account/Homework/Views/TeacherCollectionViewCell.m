//
//  TagCollectionViewCell.m
//  X5Teacher
//
//  Created by yebw on 2017/12/20.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "TeacherCollectionViewCell.h"
#import "UIColor+HEX.h"

NSString * const TeacherCollectionViewCellId = @"TeacherCollectionViewCellId";

@interface TeacherCollectionViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UILabel *teacherLabel;

@end

@implementation TeacherCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgImageView.layer.cornerRadius = 16.f;
    self.bgImageView.layer.masksToBounds = YES;
}

- (void)setupWithTeacher:(Teacher *)teacher {
    self.teacherLabel.text = teacher.nickname;
}

- (void)setChoice:(BOOL)choice {
    _choice = choice;
    
    if (choice) {
        self.teacherLabel.textColor = [UIColor whiteColor];
        self.bgImageView.backgroundColor = [UIColor colorWithHex:0x00ce00];
        self.bgImageView.layer.borderWidth = 0;
    } else {
        self.teacherLabel.textColor = [UIColor colorWithHex:0xcccccc];
        self.bgImageView.backgroundColor = [UIColor whiteColor];
        self.bgImageView.layer.borderWidth = 0.5f;
        self.bgImageView.layer.borderColor = [UIColor colorWithHex:0xcccccc].CGColor;
    }
}

+ (CGSize)cellSizeWithTeacher:(Teacher *)teacher {
    static TeacherCollectionViewCell *tempCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempCell = [[[NSBundle mainBundle] loadNibNamed:@"TeacherCollectionViewCell" owner:nil options:nil] lastObject];
    });
    
    [tempCell setupWithTeacher:teacher];
    
    return [tempCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

@end

