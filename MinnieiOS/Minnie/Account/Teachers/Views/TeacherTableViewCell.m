//
//  TeacherTableViewCell.m
//  X5Teacher
//
//  Created by yebw on 2017/12/19.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "TeacherTableViewCell.h"

NSString * const TeacherTableViewCellId = @"TeacherTableViewCellId";
CGFloat const TeacherTableViewCellHeight = 44.f;


@interface TeacherTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorityLabel;
@end

@implementation TeacherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setupWithTeacher:(Teacher *)teacher {
    self.nameLabel.text = teacher.nickname;
    
    NSString *type = nil;
    if (teacher.type == TeacherTypeTeacher) {
        type = @"教师";
    } else if (teacher.type == TeacherTypeAssistant) {
        type = @"助教";
    }
    self.typeLabel.text = type;
    
    NSString *authority = nil;
    if (teacher.authority == TeacherAuthoritySuperManager) {
        authority = @"超级管理员";
    } else if (teacher.authority == TeacherAuthorityManager) {
        authority = @"管理员";
    } else if (teacher.authority == TeacherAuthorityTeacher) {
        authority = @"普通教师";
    }
    self.authorityLabel.text = authority;
}

@end

