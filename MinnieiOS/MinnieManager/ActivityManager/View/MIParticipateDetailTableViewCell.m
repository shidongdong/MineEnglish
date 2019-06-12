//
//  MIParticipateDetailTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIParticipateDetailTableViewCell.h"

CGFloat const MIParticipateDetailTableViewCellHeight = 320.f;

NSString * const MIParticipateDetailTableViewCellId = @"MIParticipateDetailTableViewCellId";

@interface MIParticipateDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *uploadTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *qualityBtn;
@property (weak, nonatomic) IBOutlet UIButton *unqualityBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong , nonatomic) ActLogsInfo *logsInfo;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@end

@implementation MIParticipateDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _logsInfo = [[ActLogsInfo alloc] init];
    
    self.qualityBtn.layer.masksToBounds = YES;
    self.qualityBtn.layer.cornerRadius = 10.0;
    
    self.unqualityBtn.layer.masksToBounds = YES;
    self.unqualityBtn.layer.cornerRadius = 10.0;
    
    self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.layer.cornerRadius = 20.0;
    
}

- (void)setupWithModel:(ActLogsInfo *)model index:(NSInteger)index{
    
    self.logsInfo = model;
    self.rankLabel.text = [NSString stringWithFormat:@"%.2ld",index];
    
    self.videoTimeLabel.text = [NSString stringWithFormat:@"视频时长:%.2ld分%.2ld秒",model.actTimes/60,model.actTimes%60];
    self.uploadTimeLabel.text = [NSString stringWithFormat:@"上传时间: %@",model.upTime];
    
    self.qualityBtn.layer.borderColor = [UIColor clearColor].CGColor;
    self.unqualityBtn.layer.borderColor = [UIColor clearColor].CGColor;
    // 0:待审核；1合格；2不合格
    if (model.isOk == 0) {
        
        self.qualityBtn.hidden = NO;
        self.unqualityBtn.hidden = NO;
        self.qualityBtn.enabled = YES;
        self.unqualityBtn.enabled = YES;
        
        self.qualityBtn.layer.borderWidth = 0.5;
        self.qualityBtn.layer.borderColor = [UIColor mainColor].CGColor;
        self.unqualityBtn.layer.borderWidth = 0.5;
        self.unqualityBtn.layer.borderColor = [UIColor mainColor].CGColor;
        
        [self.unqualityBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        
        self.qualityBtn.backgroundColor = [UIColor mainColor];
        self.unqualityBtn.backgroundColor = [UIColor whiteColor];
        
        
    } else if (model.isOk == 1) {
        
        self.qualityBtn.hidden = NO;
        self.unqualityBtn.hidden = YES;
        self.qualityBtn.enabled = NO;
        self.qualityBtn.backgroundColor = [UIColor colorWithHex:0x00CE00];
    } else {
        
        self.qualityBtn.hidden = YES;
        self.unqualityBtn.hidden = NO;
        self.unqualityBtn.enabled = NO;
        self.unqualityBtn.backgroundColor = [UIColor colorWithHex:0x00CE00];
    }
    [self.bgImageView sd_setImageWithURL:[model.actUrl videoCoverUrlWithWidth:90.f height:90.f] placeholderImage:[UIImage imageNamed:@"attachment_placeholder"]];
}

- (IBAction)playVideoAction:(id)sender {
    
    if (self.playVideoCallback) {
        self.playVideoCallback(self.logsInfo.actUrl);
    }
}

- (IBAction)unqualifiedAction:(id)sender {
    if (self.qualifiedCallback) {
        self.qualifiedCallback(NO,self.logsInfo);
    }
}
- (IBAction)qualifiedAction:(id)sender {
    if (self.qualifiedCallback) {
        self.qualifiedCallback(YES,self.logsInfo);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
