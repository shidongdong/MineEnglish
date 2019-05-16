//
//  StudentDetailCell.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/8.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StudentDetailCellDelegate <NSObject>

- (void)modifyStarAction:(UIButton *)btn;

@end

extern NSString * const StudentDetailCellId;

@interface StudentDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

@property (weak, nonatomic) IBOutlet UIImageView *markImageV;

@property (weak, nonatomic) id<StudentDetailCellDelegate>delegate;

- (void)setCellTitle:(NSString *)title withContent:(NSString *)content;

- (void)setModifybtnTitle:(NSString *)title tag:(NSInteger)tag;

@end
