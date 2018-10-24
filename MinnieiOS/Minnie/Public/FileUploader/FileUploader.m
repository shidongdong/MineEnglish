//
//  FileUploader.m
//  AVFileDemo
//
//  Created by yebw on 2018/3/30.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "FileUploader.h"

@implementation FileUploader

+ (void)uploadData:(NSData *)data
              type:(UploadFileType)type
     progressBlock:(void (^)(NSInteger))progressBlock
   completionBlock:(void (^)(NSString * _Nullable, NSError * _Nullable))completionBlock {
    if (data.length == 0) {
        return;
    }
    
    NSString *extension = nil;
    if (type == UploadFileTypeAudio) {
        extension = @"aac";
    } else if (type == UploadFileTypeImage) {
        extension = @"jpg";
    } else if (type == UploadFileTypeVideo) {
        extension = @"mp4";
    }

    NSString *name = [[NSUUID UUID].UUIDString stringByAppendingPathExtension:extension];
    AVFile *file = [AVFile fileWithData:data name:name];
    [file uploadWithProgress:progressBlock completionHandler:^(BOOL succeeded, NSError * _Nullable error) {
        if (completionBlock != nil) {
            completionBlock(file.url, error);
        }
    }];
}

+ (void)uploadDataWithLocalFilePath:(NSString *)localFilePath
                      progressBlock:(void (^)(NSInteger))progressBlock
                    completionBlock:(void (^)(NSString * _Nullable, NSError * _Nullable))completionBlock {
    if (localFilePath.length == 0) {
        return;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:localFilePath]) {
        return;
    }
    
    AVFile *file = [AVFile fileWithLocalPath:localFilePath
                                       error:nil];
    [file uploadWithProgress:progressBlock completionHandler:^(BOOL succeeded, NSError * _Nullable error) {
        if (completionBlock != nil) {
            completionBlock(file.url, error);
        }
    }];
}

@end
