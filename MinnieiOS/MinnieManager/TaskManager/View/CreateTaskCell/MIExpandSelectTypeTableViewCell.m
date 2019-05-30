//
//  MIExpandSelectTypeTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIExpandSelectTypeTableViewCell.h"

NSString * const MIExpandSelectTypeTableViewCellId = @"MIExpandSelectTypeTableViewCellId";
CGFloat const MIExpandSelectTypeTableViewCellHeight = 103.f;

@interface MIExpandSelectTypeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgContentView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dropImageV;

@property (weak, nonatomic) IBOutlet UIView *leftContent;
@property (weak, nonatomic) IBOutlet UIView *rightContent;


@property (weak, nonatomic) IBOutlet UIView *centerLineView;
@property (weak, nonatomic) IBOutlet UILabel *leftContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftDropImageV;
@property (weak, nonatomic) IBOutlet UILabel *rightContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightDropImageV;

@end

@implementation MIExpandSelectTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgContentView.layer.cornerRadius = 12.0;
    self.bgContentView.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    self.bgContentView.layer.borderWidth = 0.5;
    
    self.leftContent.layer.cornerRadius = 12.0;
    self.leftContent.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    self.leftContent.layer.borderWidth = 0.5;
    
    self.rightContent.layer.cornerRadius = 12.0;
    self.rightContent.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    self.rightContent.layer.borderWidth = 0.5;
    // Initialization code
}

- (void)setupWithLeftText:(NSString *_Nullable)leftText
                rightText:(NSString *_Nullable)rightText
               createType:(MIHomeworkCreateContentType)createType{
    
    if (createType == MIHomeworkCreateContentType_TimeLimit) {
       
        NSInteger sec = leftText.integerValue;
        self.titleLabel.text = @"选择时限:";
        NSInteger secIndex = sec % 60;
        NSInteger minIndex = sec / 60;
        NSString *text = [NSString stringWithFormat:@"%ld分%02ld秒",minIndex,secIndex];
        [self showOneSelectedText:text];
        
    } else if (createType == MIHomeworkCreateContentType_WordsTimeInterval) {
        
        CGFloat sec = leftText.floatValue;
        self.titleLabel.text = @"播放时间间隔:";
        [self showOneSelectedText:[NSString stringWithFormat:@"%.1f秒",sec]];
    } else if (createType == MIHomeworkCreateContentType_Localtion) {
      
        self.titleLabel.text = @"位置:";
        [self showTwoSelectedLeftText:leftText rightText:rightText];
    } else if (createType == MIHomeworkCreateContentType_VideoTimeLimit) {
        
        self.titleLabel.text = @"视频时限:";
        [self showOneSelectedText:leftText];
    } else if (createType == MIHomeworkCreateContentType_ActivityEndTime) {
        
        self.titleLabel.text = @"活动结束时间:";
        [self showOneSelectedText:leftText];
    } else if (createType == MIHomeworkCreateContentType_ActivityStartTime) {
        
        self.titleLabel.text = @"活动开始时间:";
        [self showOneSelectedText:leftText];
    }
}

- (void)showOneSelectedText:(NSString *)text{
   
    self.leftContent.hidden = YES;
    self.rightContent.hidden = YES;
    self.bgContentView.hidden = NO;
    self.centerLineView.hidden = YES;
    self.timeLabel.text = text;
}

- (void)showTwoSelectedLeftText:(NSString *_Nullable)leftText
                      rightText:(NSString *_Nullable)rightText{
    
    self.leftContent.hidden = NO;
    self.rightContent.hidden = NO;
    self.bgContentView.hidden = YES;
    self.centerLineView.hidden = NO;
    self.leftContentLabel.text = leftText;
    self.rightContentLabel.text = rightText;
}

- (IBAction)expandBtnAction:(id)sender {
    
    if (self.expandCallback) {
        self.expandCallback();
    }
}
- (IBAction)leftExpandBtnAction:(id)sender {
    if (self.leftExpandCallback) {
        self.leftExpandCallback();
    }
}
- (IBAction)rightExpandBtnAction:(id)sender {
    if (self.rightExpandCallback) {
        self.rightExpandCallback();
    }
}

@end
