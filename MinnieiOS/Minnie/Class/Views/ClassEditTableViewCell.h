//
//  ClassEditTableViewCell.h
//  X5Teacher
//
//  Created by yebw on 2018/1/28.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clazz.h"

extern NSString * const ClassEditTableViewCellId;
extern CGFloat const ClassEditTableViewCellHeight;

typedef void(^ClassEditTableViewCellNameChangedCallback)(NSString *);
typedef void(^ClassEditTableViewCellLocationChangedTeacherCallback)(NSString *);
typedef void(^ClassEditTableViewCellSelectTeacherCallback)(void);
typedef void(^ClassEditTableViewCellSelectStartTimeCallback)(void);
typedef void(^ClassEditTableViewCellSelectEndTimeCallback)(void);
typedef void(^ClassEditTableViewCellSelectStudentsCountCallback)(void);
typedef void(^ClassEditTableViewCellSelectClassTypeCallback)(void);
typedef void(^ClassEditTableViewCellSelectClassLevelCallback)(void);

@interface ClassEditTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField *classNameTextField; // 班级名称
@property (nonatomic, weak) IBOutlet UITextField *classLocationTextField; // 班级地点
@property (nonatomic, weak) IBOutlet UITextField *classTeacherTextField; // 班级老师
@property (nonatomic, weak) IBOutlet UITextField *classStudentsTextField; // 班级学生规模
@property (nonatomic, weak) IBOutlet UITextField *classTypeTextField; // 课堂类型
@property (nonatomic, weak) IBOutlet UIButton *startTimeButton;
@property (nonatomic, weak) IBOutlet UIButton *endTimeButton;
@property (weak, nonatomic) IBOutlet UITextField *classLevelTextField; //课堂等级

@property (nonatomic, copy) ClassEditTableViewCellNameChangedCallback nameChangedCallback;
@property (nonatomic, copy) ClassEditTableViewCellLocationChangedTeacherCallback locationChangedCallback;
@property (nonatomic, copy) ClassEditTableViewCellSelectTeacherCallback selectTeacherCallback;
@property (nonatomic, copy) ClassEditTableViewCellSelectStartTimeCallback selectStartTimeCallback;
@property (nonatomic, copy) ClassEditTableViewCellSelectEndTimeCallback selectEndTimeCallback;
@property (nonatomic, copy) ClassEditTableViewCellSelectClassTypeCallback selectStudentsCountCallback;
@property (nonatomic, copy) ClassEditTableViewCellSelectClassTypeCallback selectClassTypeCallback;
@property (nonatomic, copy) ClassEditTableViewCellSelectClassLevelCallback selectClassLevelCallback;

- (void)setupWithClass:(Clazz *)clazz;

@end
