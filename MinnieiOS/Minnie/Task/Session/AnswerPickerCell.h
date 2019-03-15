//
//  AnswerPickerCell.h
//  Minnie
//
//  Created by 栋栋 施 on 2019/3/9.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkAnswerItem.h"

extern NSString * const AnswerPickerImageCellId;
extern NSString * const AnswerPickerVideoCellId;
extern NSString * const AnswerPickerAudioCellId;

@interface AnswerPickerCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL,HomeworkAnswerItem *);
@property (nonatomic, assign)BOOL  bSelected;
- (void)setContentData:(HomeworkAnswerItem *)item;

@end


