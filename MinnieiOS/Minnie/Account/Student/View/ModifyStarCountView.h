//
//  ModifyStarCountView.h
//  MinnieStudent
//
//  Created by songzhen on 2019/5/14.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ModifyStarCountCallback)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ModifyStarCountView : UIView

@property (nonatomic, copy) ModifyStarCountCallback callback;


- (void)updateWithStarCount:(NSInteger)starCount
                  studentId:(NSInteger)studentId
                     reason:(NSString *)reason
                      isAdd:(BOOL)isAdd;

@end

NS_ASSUME_NONNULL_END
