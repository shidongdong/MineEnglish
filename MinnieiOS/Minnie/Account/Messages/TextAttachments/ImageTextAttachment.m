//
//  SRImageTextAttachment.m
//  SnailReader
//
//  Created by yebingwei on 2017/3/21.
//  Copyright © 2017年 com.netease. All rights reserved.
//

#import "ImageTextAttachment.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDWebImageDownloaderOperation.h>

NSString *const kNotificationOfTextViewImageLoadDidSuccess = @"kNotificationOfTextViewImageLoadDidSuccess";

@interface ImageTextAttachment()

@end

@implementation ImageTextAttachment

// 指定显示的缩略图
- (UIImage *)imageForBounds:(CGRect)imageBounds
              textContainer:(NSTextContainer *)textContainer
             characterIndex:(NSUInteger)charIndex
{
    if (self.thumbnail == nil) {
        if (self.image != nil) {
            self.thumbnail = [ImageTextAttachment thumbnailOfImage:self.image];
        } else if (self.placeholderImage != nil) {
            self.thumbnail = self.placeholderImage;
        }
    }
    
    return self.thumbnail;
}

- (void)downloadImage {
    if (self.imageUrl.length == 0) {
        return;
    }
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.imageUrl]
                                                          options:0
                                                         progress:nil
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                            if (image != nil) {
                                                                UIImage *finalImage = [self createAttachmentImageAfterImageDownloaded:image];

                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    self.image = finalImage;
                                                                    self.thumbnail = [self createThumnailWithAttachmentImage];
                                                                    
                                                                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfTextViewImageLoadDidSuccess object:self];
                                                                });
                                                            }
                                                        }];
}

- (UIImage *)createAttachmentImageAfterImageDownloaded:(UIImage *)image {
    return image;
}

- (UIImage *)createThumnailWithAttachmentImage {
    return [ImageTextAttachment thumbnailOfImage:self.image];
}

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer
                      proposedLineFragment:(CGRect)lineFrag
                             glyphPosition:(CGPoint)position
                            characterIndex:(NSUInteger)charIndex
{
    if (!CGSizeEqualToSize(self.attachmentSize, CGSizeZero)) {
        CGSize thumbnailSize = [ImageTextAttachment thumbnailSize:self.attachmentSize];
        return CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height);
    }

    return CGRectMake(0, 0, self.thumbnail.size.width, self.thumbnail.size.height);
}

- (void)dealloc {
}

+ (CGSize)thumbnailSize:(CGSize)originalSize {
    CGSize size = originalSize;
    
    if (size.width > 135.f || size.height > 180.f) {
        CGFloat width = 135.f;
        CGFloat height = width * size.height / size.width;
        
        if (height > 180.f) {
            height = 180.f;
            width = height * size.width / size.height;
        }
        size = CGSizeMake(width, height);
    }
    
    return size;
}

+ (UIImage *)thumbnailOfImage:(UIImage *)image {
    if (image == nil) {
        return nil;
    }
    
    CGSize size = [ImageTextAttachment thumbnailSize:image.size];
    UIImage *thumbnail = image;
    if (ABS(size.width-image.size.width) > 1.f) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
        [image drawInRect:CGRectMake(0.f, 0.f, size.width, size.height)];
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return thumbnail;
}


@end

