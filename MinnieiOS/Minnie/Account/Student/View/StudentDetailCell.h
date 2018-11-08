//
//  StudentDetailCell.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/8.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const StudentDetailCellId;

@interface StudentDetailCell : UITableViewCell

- (void)setCellTitle:(NSString *)title withContent:(NSString *)content;

@end
