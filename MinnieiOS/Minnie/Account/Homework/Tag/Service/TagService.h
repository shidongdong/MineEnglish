//
//  TagService.h
//  X5Teacher
//
//  Created by yebw on 2017/12/20.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "Result.h"

@interface TagService : NSObject

+ (BaseRequest *)requestTagsWithCallback:(RequestCallback)callback;

+ (BaseRequest *)createTag:(NSString *)tag
                  callback:(RequestCallback)callback;

+ (BaseRequest *)deleteTags:(NSArray<NSString *>*)tags callback:(RequestCallback)callback;

@end

