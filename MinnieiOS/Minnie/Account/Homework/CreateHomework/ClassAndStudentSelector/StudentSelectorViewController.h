//
//  StudentSelectorViewController.h
//  X5Teacher
//
//  Created by yebw on 2017/12/27.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^StudentSelectorViewControllerSelectCallback)(NSInteger);
typedef void(^StudentSelectorViewControllerPreviewCallback)(NSInteger);

@interface StudentSelectorViewController : BaseViewController

@property (nonatomic, copy) StudentSelectorViewControllerSelectCallback selectCallback;
@property (nonatomic, copy) StudentSelectorViewControllerPreviewCallback previewCallback;

@property (nonatomic, strong) NSMutableArray *selectedStudents;
@property (nonatomic, assign) BOOL reviewMode;

@property (nonatomic, assign) BOOL classStateMode;
@property (nonatomic, assign) BOOL inClass; // 学生是否属于班级（0未入学，1已入学）

- (void)unselectAll;

@end
