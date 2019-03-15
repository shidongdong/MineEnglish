//
//  AnswerPickerCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2019/3/9.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import "AnswerPickerCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
NSString * const AnswerPickerImageCellId = @"AnswerPickerImageCellId";
NSString * const AnswerPickerVideoCellId = @"AnswerPickerVideoCellId";
NSString * const AnswerPickerAudioCellId = @"AnswerPickerAudioCellId";

@interface AnswerPickerCell()


@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *bigTalkBtn;
@property (weak, nonatomic) IBOutlet UIButton *smallTalkBtn;
@property (nonatomic,strong) HomeworkAnswerItem * mItem;

@end

@implementation AnswerPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)selectPressed:(UIButton *)sender {

    self.bSelected = !self.bSelected;
    
    if (self.bSelected)
    {
        [self.selectBtn setImage:[UIImage imageNamed:@"photo_sel_photoPickerVc"] forState:UIControlStateNormal];
    }
    else
    {
        [self.selectBtn setImage:[UIImage imageNamed:@"photo_def_photoPickerVc"] forState:UIControlStateNormal];
    }
    
    if (self.didSelectPhotoBlock)
    {
        self.didSelectPhotoBlock(self.bSelected,self.mItem);
    }
    
}


- (void)setBSelected:(BOOL)bSelected
{
    _bSelected = bSelected;
    if (bSelected)
    {
        [self.selectBtn setImage:[UIImage imageNamed:@"photo_sel_photoPickerVc"] forState:UIControlStateNormal];
    }
    else
    {
        [self.selectBtn setImage:[UIImage imageNamed:@"photo_def_photoPickerVc"] forState:UIControlStateNormal];
    }
}

- (void)setContentData:(HomeworkAnswerItem *)item
{
    self.mItem = item;
    
    if ([item.type isEqualToString:HomeworkAnswerItemTypeVideo])
    {
        [self.contentImageView sd_setImageWithURL:[item.videoUrl videoCoverUrlWithWidth:90.f height:90.f] placeholderImage:[UIImage imageNamed:@"attachment_placeholder"]];
        
    }
    else if ([item.type isEqualToString:HomeworkAnswerItemTypeImage])
    {
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl]];
    }
    else
    {
        if (item.audioCoverUrl.length > 0)
        {
            [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:item.audioCoverUrl]];
            self.bigTalkBtn.hidden = YES;
            self.smallTalkBtn.hidden = NO;
        }
        else
        {
            self.bigTalkBtn.hidden = NO;
            self.smallTalkBtn.hidden = YES;
        }
    }
}

@end
