//
//  FileUploaderService.h
//  Minnie
//
//  Created by 栋栋 施 on 2019/3/1.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
@interface FileUploaderService : NSObject

+ (BaseRequest *)askForQNUploadTokenWithCallback:(RequestCallback)callback;


@end


