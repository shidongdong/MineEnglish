//
//  CircleHomeworksRequest.h
//  X5
//
//  Created by yebw on 2017/11/11.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "BaseRequest.h"
#import <UIKit/UIKit.h>

@interface CircleHomeworksRequest : BaseRequest

- (BaseRequest *)initWithUserId:(NSUInteger)userId;

- (BaseRequest *)initWithClassId:(NSUInteger)classId;

- (BaseRequest *)initWithNextUrl:(NSString *)nextUrl;

@end
