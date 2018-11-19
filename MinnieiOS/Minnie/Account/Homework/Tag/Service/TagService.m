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
#import "FormTagsRequest.h"
#import "CreateFormTagRequest.h"
#import "DeleteFormTagsRequest.h"

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

+ (BaseRequest *)requestFormTagsWithCallback:(RequestCallback)callback
{
    FormTagsRequest *request = [[FormTagsRequest alloc] init];
    request.objectKey = @"list";
    request.callback = callback;
    [request start];
    return request;
}

+ (BaseRequest *)createFormTag:(NSString *)formtag
                      callback:(RequestCallback)callback
{
    CreateFormTagRequest *request = [[CreateFormTagRequest alloc] initWithFormTag:tag];
    
    request.callback = callback;
    
    [request start];
    
    return request;
}

+ (BaseRequest *)deleteFormTags:(NSArray<NSString *>*)formtags callback:(RequestCallback)callback
{
    DeleteFormTagsRequest *request = [[DeleteFormTagsRequest alloc] initWithFormTags:tags];
    
    request.callback = callback;
    
    [request start];
    
    return request;
}

@end


