//
//  MISegmentTypeTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MISegmentTypeTableViewCell.h"

CGFloat const MISegmentTypeTableViewCellHeight = 84.f;

NSString * const MISegmentTypeTableViewCellId = @"MISegmentTypeTableViewCellId";

@interface MISegmentTypeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIButton *btn4;

@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint5;

@property (weak, nonatomic) IBOutlet UIView *bgConstraint;


@property (assign,nonatomic) MIHomeworkCreateContentType createType;

@property (strong,nonatomic) NSArray *btnArray;


@property (assign,nonatomic) NSInteger btnNum;

@end

@implementation MISegmentTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    self.bgView.layer.cornerRadius = 12;
//    self.bgView.layer.masksToBounds = YES;
    self.bgView.clipsToBounds = YES;
    self.btnArray = @[self.btn1,self.btn2,self.btn3,self.btn4,self.btn5];
}

- (void)setupWithSelectIndex:(NSInteger)index
                  createType:(MIHomeworkCreateContentType)createType{
    
    if (index > 0) {
        index--;
    }
    self.createType = createType;
    
    self.constraint1.constant = self.constraint1.constant - 10;
    self.constraint2.constant = self.constraint2.constant - 10;
    self.constraint3.constant = self.constraint3.constant - 10;
    self.constraint4.constant = self.constraint4.constant - 10;
    self.constraint5.constant = self.constraint5.constant - 10;
    if (self.createType == MIHomeworkCreateContentType_CommitCount) {
        
        self.btnNum =4;
        self.titleLabel.text = @"可提交次数:";
        [self.btn1 setTitle:@"1次" forState:UIControlStateNormal];
        [self.btn2 setTitle:@"2次" forState:UIControlStateNormal];
        [self.btn3 setTitle:@"3次" forState:UIControlStateNormal];
        [self.btn4 setTitle:@"4次" forState:UIControlStateNormal];
    } else if (self.createType == MIHomeworkCreateContentType_ExaminationType) {
        
        self.btnNum =2;
        self.titleLabel.text = @"考试类型:";
        [self.btn1 setTitle:@"周测" forState:UIControlStateNormal];
        [self.btn2 setTitle:@"正式考试" forState:UIControlStateNormal];
    } else if (self.createType == MIHomeworkCreateContentType_HomeworkDifficulty) {
        self.btnNum =5;
        // 1-5
        self.titleLabel.text = @"选择星级:";
        [self.btn1 setTitle:@"1星" forState:UIControlStateNormal];
        [self.btn2 setTitle:@"2星" forState:UIControlStateNormal];
        [self.btn3 setTitle:@"3星" forState:UIControlStateNormal];
        [self.btn4 setTitle:@"4星" forState:UIControlStateNormal];
        [self.btn5 setTitle:@"5星" forState:UIControlStateNormal];
    } else if (self.createType == MIHomeworkCreateContentType_StatisticalType) {
       // 作业类型：普通1、附件2、初始化0
        self.btnNum =2;
        self.titleLabel.text = @"统计类型:";
        [self.btn1 setTitle:@"普通" forState:UIControlStateNormal];
        [self.btn2 setTitle:@"附加" forState:UIControlStateNormal];
    } else if (self.createType == MIHomeworkCreateContentType_CommitTime){
        // 1-4
        self.btnNum =4;
        self.titleLabel.text = @"提交时间:";
        [self.btn1 setTitle:@"1天" forState:UIControlStateNormal];
        [self.btn2 setTitle:@"2天" forState:UIControlStateNormal];
        [self.btn3 setTitle:@"3天" forState:UIControlStateNormal];
        [self.btn4 setTitle:@"4天" forState:UIControlStateNormal];
    }
    [self setBtn:self.btnNum selectIndex:index];
}

- (IBAction)btnAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 8000;
    [self setBtn:self.btnNum selectIndex:index];
    if (self.callback) {
        self.callback(index + 1);
    }
}

- (void)setBtn:(NSInteger)num selectIndex:(NSInteger)selectIndex{

    for (NSInteger i = 0; i < 5; i++) {
       UIButton *btn = self.btnArray[i];
        if (i < num) {
            btn.hidden = NO;
            
            if (selectIndex == i) {
                btn.selected = YES;
                if (self.createType == MIHomeworkCreateContentType_HomeworkDifficulty) {
                    [btn setBackgroundColor:[UIColor colorWithHex:0x00CE00]];
                } else {
                    [btn setBackgroundColor:[UIColor mainColor]];
                }
            } else {
                btn.selected = NO;
                [btn setBackgroundColor:[UIColor bgColor]];
            }
        } else {
            btn.hidden = YES;
        }
    }
}


@end
