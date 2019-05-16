//
//  EditStudentMarkView.h
//  MinnieStudent
//
//  Created by songzhen on 2019/5/7.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditStuLabelCallback)(void);

NS_ASSUME_NONNULL_BEGIN

@interface EditStudentMarkView : UIView

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) NSInteger stuLabel;

@property (nonatomic, copy) EditStuLabelCallback callback;

@end

NS_ASSUME_NONNULL_END
