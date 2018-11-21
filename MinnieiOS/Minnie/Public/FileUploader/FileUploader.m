//
//  FileUploader.m
//  AVFileDemo
//
//  Created by yebw on 2018/3/30.
//  Copyright © 2018年 netease. All rights reserved.
//

#import "FileUploader.h"

@implementation FileUploader

+(FileUploader *)shareInstance
{
    static FileUploader * obj;
    static dispatch_once_t done;
    dispatch_once(&done, ^{
        obj = [[FileUploader alloc] init];
    });
    return obj;
}

- (void)uploadData:(NSData *)data
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
    self.file = [AVFile fileWithData:data name:name];
    [self.file uploadWithProgress:progressBlock completionHandler:^(BOOL succeeded, NSError * _Nullable error) {
        if (completionBlock != nil) {
            completionBlock(self.file.url, error);
        }
    }];
    
}

- (void)cancleUploading
{
    [self.file cancelUploading];
}


- (void)uploadDataWithLocalFilePath:(NSString *)localFilePath
                      progressBlock:(void (^)(NSInteger))progressBlock
                    completionBlock:(void (^)(NSString * _Nullable, NSError * _Nullable))completionBlock {
    if (localFilePath.length == 0) {
        return;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:localFilePath]) {
        return;
    }
    
    self.file = [AVFile fileWithLocalPath:localFilePath
                                       error:nil];
    [self.file uploadWithProgress:progressBlock completionHandler:^(BOOL succeeded, NSError * _Nullable error) {
        if (completionBlock != nil) {
            completionBlock(self.file.url, error);
        }
    }];
}

@end
