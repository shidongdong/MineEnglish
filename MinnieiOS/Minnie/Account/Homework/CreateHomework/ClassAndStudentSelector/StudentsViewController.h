//
//  StudentsViewController.h
//  MinnieTeacher
//
//  Created by yebw on 2018/5/20.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StudentsViewControllerDelegate<NSObject>

- (void)studentsDidSelect:(NSArray<User *> *)students;

@end

@interface StudentsViewController : UIViewController

@property (nonatomic, weak) IBOutlet id<StudentsViewControllerDelegate> delegate;

@end
