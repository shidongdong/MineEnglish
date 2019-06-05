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

@end

@implementation MIParticipateDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.qualityBtn.layer.masksToBounds = YES;
    self.qualityBtn.layer.cornerRadius = 10.0;
    
    self.unqualityBtn.layer.masksToBounds = YES;
    self.unqualityBtn.layer.cornerRadius = 10.0;
    
    self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.layer.cornerRadius = 20.0;
}

- (void)setupWithModel:(MIParticipateModel *_Nullable)model{
    
    [self.bgImageView sd_setImageWithURL:[@"http://file.zhengminyi.com/mBa6QMBfbOttwEAqplMNPoD.mp4" videoCoverUrlWithWidth:90.f height:90.f] placeholderImage:[UIImage imageNamed:@"attachment_placeholder"]];
}

- (IBAction)playVideoAction:(id)sender {
    
    if (self.playVideoCallback) {
        self.playVideoCallback();
    }
}

- (IBAction)unqualifiedAction:(id)sender {
    
}
- (IBAction)qualifiedAction:(id)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
