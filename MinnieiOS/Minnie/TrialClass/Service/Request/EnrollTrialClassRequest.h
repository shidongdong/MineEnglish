//
//  EnrollTrialClassRequest.h
//  MinnieStudent
//
//  Created by yebw on 2018/4/14.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "BaseRequest.h"

// 报名试听课
@interface EnrollTrialClassRequest : BaseRequest

- (instancetype)initWithName:(NSString *)name
                       grade:(NSString *)grade
                      gender:(NSInteger)gender;

@end

