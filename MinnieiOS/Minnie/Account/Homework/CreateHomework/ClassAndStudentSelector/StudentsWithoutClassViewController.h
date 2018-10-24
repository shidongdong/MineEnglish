//
//  StudentsWithoutClassViewController.h
//  MinnieTeacher
//
//  Created by yebw on 2018/5/20.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StudentsWithoutClassViewControllerDelegate<NSObject>

- (void)studentsDidSelect:(NSArray<User *> *)students;

@end

@interface StudentsWithoutClassViewController : UIViewController

@property (nonatomic, weak) IBOutlet id<StudentsWithoutClassViewControllerDelegate> delegate;

@end
