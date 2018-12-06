//
//  FileUploader.h
//  AVFileDemo
//
//  Created by yebw on 2018/3/30.
//  Copyright © 2018年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

typedef NS_ENUM(NSInteger, UploadFileType) {
    UploadFileTypeImage,
    UploadFileTypeAudio,      //语音对话
    UploadFileTypeVideo,
    UploadFileTypeAudio_Mp3,   //MP3音频文件
};

@interface FileUploader : NSObject

@property(nonatomic,strong)AVFile * file;

+ (FileUploader *)shareInstance;

- (void)uploadData:(NSData *)data
              type:(UploadFileType)type
     progressBlock:(void (^)(NSInteger))progressBlock
   completionBlock:(void (^)(NSString * _Nullable, NSError * _Nullable))completionBlock;

- (void)uploadDataWithLocalFilePath:(NSString *)localFilePath
                      progressBlock:(void (^)(NSInteger))progressBlock
                    completionBlock:(void (^)(NSString * _Nullable, NSError * _Nullable))completionBlock;

//取消上传
- (void)cancleUploading;

@end
