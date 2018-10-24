//
//  TeacherCollectionViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/2/4.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teacher.h"

extern NSString * const TeacherCollectionViewCellId;

@interface TeacherCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL choice;

- (void)setupWithTeacher:(Teacher *)teacher;

+ (CGSize)cellSizeWithTeacher:(Teacher *)teacher;

@end
