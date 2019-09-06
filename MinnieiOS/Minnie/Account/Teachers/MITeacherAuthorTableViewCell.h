//
//  MITeacherAuthorTableViewCell.h
//  Minnie
//
//  Created by songzhen on 2019/8/13.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MIAuthorManagerType) {
    
    MIAuthorManagerNameType,                    // 姓名
    MIAuthorManagerPhoneNumType,                // 号码
    MIAuthorManagerTeacherType,                 // 教师类型
    MIAuthorManagerAuthorType,                  // 权限设置
    MIAuthorManagerRealTimeTaskType,            // 实时任务
    MIAuthorManagerRealTimeTaskPreviewType,     // 实时任务查看
    MIAuthorManagerTeacherEditType,             // 教师管理（新建/编辑/删除）
    MIAuthorManagerTeacherPreviewType,          // 教师查看
    MIAuthorManagerHomeworkType,                // 作业库管理
    MIAuthorManagerHomeworkPreviewType,         // 作业查看
    MIAuthorManagerActivityType,                // 活动管理
    MIAuthorManagerCampusType,                  // 校区管理（编辑）
    MIAuthorManagerClassPreviewType,            // 班级信息查看
    MIAuthorManagerStudentManagerType,          // 学生管理（编辑）
    MIAuthorManagerStudentPreviewType,          // 学生信息查看
    MIAuthorManagerGiftsType,                   // 礼品管理
    MIAuthorManagerGiftsExchangeType,           // 礼品兑换
    MIAuthorManagerMessageType,                 // 创建消息
    MIAuthorManagerPasswordType,                // 修改密码
    MIAuthorManagerDeleteType,                  // 删除
};

extern NSString * const MITeacherAuthorTableViewCellId;
extern CGFloat const MITeacherAuthorTableViewCellHeight;


typedef void(^MITeacherAuthorBtnBlock)(MIAuthorManagerType authorType);

typedef void(^MITeacherAuthorSwitchBlock)(MIAuthorManagerType authorType,BOOL state);

typedef void(^MITeacherAuthorInputBlock)(MIAuthorManagerType authorType, NSString *text);


@interface MITeacherAuthorTableViewCell : UITableViewCell

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,assign) TeacherAuthority authority;

@property (nonatomic,copy) MITeacherAuthorInputBlock inputBlock;

@property (nonatomic,copy) MITeacherAuthorBtnBlock authorBlock;

@property (nonatomic,copy) MITeacherAuthorSwitchBlock stateBlock;


/**
 type:  0 输入 text:内容文本
        1 展开
        2 switch state:
        3 查看
        4 删除
 */
- (void)setupTitle:(NSString *_Nullable)title
              text:(NSString *_Nullable)text
             image:(NSString *_Nullable)image
        authorType:(MIAuthorManagerType)authorType
              type:(NSInteger)type
             state:(BOOL)state;

@end

NS_ASSUME_NONNULL_END
