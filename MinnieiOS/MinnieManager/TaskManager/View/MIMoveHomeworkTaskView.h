//
//  MIMoveHomeworkTaskView.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MoveHomeworkTaskCallback)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface MIMoveHomeworkTaskView : UIView

@property (nonatomic, copy) MoveHomeworkTaskCallback callback;


@property (nonatomic, assign) BOOL isMultiple;

@end

NS_ASSUME_NONNULL_END
