//
//  MITeacherAuthorTableViewCell.m
//  Minnie
//
//  Created by songzhen on 2019/8/13.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MITeacherAuthorTableViewCell.h"

NSString * const MITeacherAuthorTableViewCellId = @"MITeacherAuthorTableViewCellId";
CGFloat const MITeacherAuthorTableViewCellHeight = 44.f;


@interface MITeacherAuthorTableViewCell (){
    
    NSInteger _type;
    MIAuthorManagerType _authorType;
}

@property (weak, nonatomic) IBOutlet UIView *inputView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;


@property (weak, nonatomic) IBOutlet UIView *selectView;

@property (weak, nonatomic) IBOutlet UILabel *selectTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *selectTextField;


@property (weak, nonatomic) IBOutlet UIView *switchView;
@property (weak, nonatomic) IBOutlet UILabel *switchTitleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *switchTitleLeadConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageV;

@property (weak, nonatomic) IBOutlet UIView *intoView;
@property (weak, nonatomic) IBOutlet UILabel *intoTitleView;


@property (weak, nonatomic) IBOutlet UILabel *deleteView;

@end

@implementation MITeacherAuthorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/**
 type:
 0 输入 text:内容文本
 1 展开
 2 switch state:on\off image:头像
 3 查看
 4 删除
 */
- (void)setupTitle:(NSString *_Nullable)title
              text:(NSString *_Nullable)text
              image:(NSString *_Nullable)image
        authorType:(MIAuthorManagerType)authorType
              type:(NSInteger)type
             state:(BOOL)state{
    
    _type = type;
    _authorType = authorType;
    
    self.inputView.hidden = YES;
    self.selectView.hidden = YES;
    self.switchView.hidden = YES;
    self.intoView.hidden = YES;
    self.deleteView.hidden = YES;
    
    if (type == 0) {
        
        self.inputView.hidden = NO;
        self.titleLabel.text = title;
        self.inputTextField.text = text;
    } else if (type == 1) {
        
        self.selectView.hidden = NO;
        self.selectTitleLabel.text = title;
        self.selectTextField.text = text;
        
    } else if (type == 2) {
        
        self.switchView.hidden = NO;
        self.switchTitleLabel.text = title;
        [self.switchBtn setOn:state];
        
        if (image == nil) {
            self.avatarImageV.hidden = YES;
            self.switchTitleLeadConstraint.constant = 12;
        } else {
            self.avatarImageV.hidden = NO;
            self.avatarImageV.layer.cornerRadius = 15.0;
            self.switchTitleLeadConstraint.constant = 54;
            [self.avatarImageV sd_setImageWithURL:[image imageURLWithWidth:30]
                                 placeholderImage:[UIImage imageNamed:@"attachment_placeholder"]];
        }
    } else if (type == 3) {
        
        self.intoView.hidden = NO;
        self.intoTitleView.text = title;
    } else {
        self.deleteView.hidden = NO;
        self.deleteView.text = title;
    }
}

- (IBAction)textFieldAction:(id)sender {

    if (_type == 0) {
        
        if (self.inputBlock) {
            self.inputBlock(_authorType, _inputTextField.text);
        }
    }
}

- (IBAction)switchAction:(id)sender {
    
    if (self.authority == TeacherAuthoritySuperManager) {
        self.switchBtn.on = YES;
    }
    if (_type == 2) {
        
        if (self.stateBlock) {
            self.stateBlock(_authorType, self.switchBtn.on);
        }
    }
}

- (IBAction)btnAction:(id)sender {
    
    if (self.authorBlock) {
        self.authorBlock(_authorType);
    }
}


@end
