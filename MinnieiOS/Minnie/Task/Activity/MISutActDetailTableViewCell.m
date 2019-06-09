//
//  MISutActDetailTableViewCell.m
//  MinnieStudent
//
//  Created by songzhen on 2019/6/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//


CGFloat const MISutActDetailTableViewCellHeight = 142.f;

NSString * const MISutActDetailTableViewCellId = @"MISutActDetailTableViewCellId";


#import "MISutActDetailTableViewCell.h"




@interface MISutActDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *rankImageV;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (weak, nonatomic) IBOutlet UIImageView *playImageV;
@property (weak, nonatomic) IBOutlet UILabel *stuNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeadConstraint;

@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@property (nonatomic,strong) ActivityRankInfo *rankInfo;

@property (nonatomic,strong) ActLogsInfo *logsInfo;

@end

@implementation MISutActDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setupRanInfo:(ActLogsInfo *)logsInfo{
    
    self.logsInfo = logsInfo;
    
    self.rankLabel.hidden = YES;
    self.rankImageV.hidden = YES;
    self.stateBtn.hidden = NO;
    
    [self.playImageV sd_setImageWithURL:[logsInfo.actUrl videoCoverUrlWithWidth:112 height:112] completed:nil];
    [self.iconImageV sd_setImageWithURL:[@"http://res.zhengminyi.com/FtlXAfzMJPI6YyO3fiQQUcVw9LQT" imageURLWithWidth:32] completed:nil];
    self.stuNameLabel.text = @"😃😁😸哈哈哈";
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%.2ld分%.2ld秒",self.rankInfo.actTimes/60,self.rankInfo.actTimes%60];
    self.imageLeadConstraint.constant = 12;
    
    NSString *stateStr;
    [self.stateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (logsInfo.isOk == 0) {
        stateStr = @"待审核";
        self.stateBtn.backgroundColor = [UIColor whiteColor];
        [self.stateBtn setTitleColor:[UIColor detailColor] forState:UIControlStateNormal];
    } else if (logsInfo.isOk == 1) {
        stateStr = @"合格";
        self.stateBtn.backgroundColor = [UIColor mainColor];
    } else if (logsInfo.isOk == 2) {
        stateStr = @"不合格";
        self.stateBtn.backgroundColor = [UIColor colorWithHex:0x00CE00];
    }
    [self.stateBtn setTitle:stateStr forState:UIControlStateNormal];
    
}
- (void)setupRanInfo:(ActivityRankInfo *)rankInfo index:(NSInteger)index{
    
    self.stateBtn.hidden = YES;
    self.rankInfo = rankInfo;
    self.rankLabel.text = [NSString stringWithFormat:@"%lu",index];
    if (index < 4) {
        self.rankLabel.textColor = [UIColor whiteColor];
        self.rankImageV.hidden = NO;
        self.rankImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"第%lu名",index]];
    } else {
        self.rankImageV.hidden = YES;
        self.rankLabel.textColor = [UIColor blackColor];
    }
    
    [self.playImageV sd_setImageWithURL:[self.rankInfo.actUrl videoCoverUrlWithWidth:112 height:112] completed:nil];
    [self.iconImageV sd_setImageWithURL:[self.rankInfo.avatar imageURLWithWidth:32] completed:nil];
    self.stuNameLabel.text = self.rankInfo.nickName;
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%.2ld分%.2ld秒",self.rankInfo.actTimes/60,self.rankInfo.actTimes%60];
    self.imageLeadConstraint.constant = 56;

}
- (IBAction)playBtnAction:(id)sender {
    
    if (self.rankInfo.actUrl.length) {
     
        if (self.videoCallback) {
            self.videoCallback(self.rankInfo.actUrl);
        }
    }
    if (self.logsInfo.actUrl.length) {
        
        if (self.videoCallback) {
            self.videoCallback(self.logsInfo.actUrl);
        }
    }
}

@end
