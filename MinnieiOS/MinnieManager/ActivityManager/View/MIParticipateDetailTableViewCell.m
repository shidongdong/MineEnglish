//
//  MIParticipateDetailTableViewCell.m
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import "MIParticipateDetailTableViewCell.h"

CGFloat const MIParticipateDetailTableViewCellHeight = 300.f;

NSString * const MIParticipateDetailTableViewCellId = @"MIParticipateDetailTableViewCellId";

@interface MIParticipateDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *uploadTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *qualityBtn;
@property (weak, nonatomic) IBOutlet UIButton *unqualityBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong , nonatomic) ActLogsInfo *logsInfo;

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
    
    self.qualityBtn.backgroundColor = [UIColor unSelectedColor];
    self.unqualityBtn.backgroundColor = [UIColor colorWithHex:0x00CE00];
}

- (void)setupWithModel:(ActLogsInfo *)model{
    self.logsInfo = model;
    self.videoTimeLabel.text = [NSString stringWithFormat:@"视频时长: %@",model.upTime];
    self.uploadTimeLabel.text = [NSString stringWithFormat:@"上传时间: %.2ld:%.2ld",model.actTimes/60,model.actTimes%60];
  
    // 0:待审核；1合格；2不合格
    if (model.isOk == 0) {
        self.qualityBtn.hidden = NO;
        self.unqualityBtn.hidden = NO;
        self.qualityBtn.enabled = YES;
        self.unqualityBtn.enabled = YES;
        
        self.qualityBtn.backgroundColor = [UIColor colorWithHex:0x00CE00];
        self.unqualityBtn.backgroundColor = [UIColor colorWithHex:0x00CE00];
    } else if (model.isOk == 1) {
        
        self.qualityBtn.hidden = NO;
        self.unqualityBtn.hidden = YES;
        self.qualityBtn.enabled = NO;
        self.qualityBtn.backgroundColor = [UIColor detailColor];
    } else {
        
        self.qualityBtn.hidden = YES;
        self.unqualityBtn.hidden = NO;
        self.unqualityBtn.enabled = NO;
        self.unqualityBtn.backgroundColor = [UIColor detailColor];
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
