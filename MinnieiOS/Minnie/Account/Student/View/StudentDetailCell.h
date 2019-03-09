//
//  StudentDetailCell.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/8.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StudentDetailCellDelegate <NSObject>

- (void)modifyStarAction;

@end

extern NSString * const StudentDetailCellId;

@interface StudentDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) id<StudentDetailCellDelegate>delegate;
- (void)setCellTitle:(NSString *)title withContent:(NSString *)content;

@end
