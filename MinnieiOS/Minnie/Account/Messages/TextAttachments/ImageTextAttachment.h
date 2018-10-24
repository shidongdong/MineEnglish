//
//  Created by yebingwei on 2017/3/21.
//

#import <UIKit/UIKit.h>

extern NSString *const kNotificationOfTextViewImageLoadDidSuccess;

/**
 书评编辑器的图片附件
 */
@interface ImageTextAttachment : NSTextAttachment

/**
 当最终图片没有准备好的时候的缺省图片
 */
@property (strong, nonatomic) UIImage *placeholderImage;

/**
 缩略图，显示的内容
 */
@property (strong, nonatomic) UIImage *thumbnail;

/**
 如果当前附件的图片已经上传成功了，该值不为空
 */
@property (copy, nonatomic) NSString *imageUrl;

/** 图片data（只gif图可能有） */
@property (strong, nonatomic) NSData *imageData;

/*
 没有最终图片的时候需要显示placeholderImage，但是placeholderImage很多时候是通用的，这里单独给一个设定附件展示大小的接口
 */
@property (assign, nonatomic) CGSize attachmentSize;

/**
 生成图片的缩略图

 @param image 原图
 @return 缩略图
 */
+ (UIImage *)thumbnailOfImage:(UIImage *)image;


/**
 下载图片
 */
- (void)downloadImage;

/**
 图片下载好后，创建图片

 @param image 下载好的图片
 */
- (UIImage *)createAttachmentImageAfterImageDownloaded:(UIImage *)image;

/**
 根据附件最终图片创建出一个缩略图，供集成用
 
 @return 缩略图
 */
- (UIImage *)createThumnailWithAttachmentImage;

@end
