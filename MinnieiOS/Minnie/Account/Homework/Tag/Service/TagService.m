//
//  TagService.m
//  X5Tag
//
//  Created by yebw on 2017/12/19.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "TagService.h"
#import "TagsRequest.h"
#import "CreateTagRequest.h"
#import "DeleteTagRequest.h"

@implementation TagService

+ (BaseRequest *)requestTagsWithCallback:(RequestCallback)callback {
    TagsRequest *request = [[TagsRequest alloc] init];
    
    request.objectKey = @"list";
    
    request.callback = callback;
    
    [request start];
    
    return request;
}

+ (BaseRequest *)createTag:(NSString *)tag
                  callback:(RequestCallback)callback {
    CreateTagRequest *request = [[CreateTagRequest alloc] initWithTag:tag];
    
    request.callback = callback;
    
    [request start];
    
    return request;
}

+ (BaseRequest *)deleteTags:(NSArray<NSString *>*)tags callback:(RequestCallback)callback {
    DeleteTagRequest *request = [[DeleteTagRequest alloc] initWithTags:tags];
    
    request.callback = callback;
    
    [request start];
    
    return request;
}

@end


