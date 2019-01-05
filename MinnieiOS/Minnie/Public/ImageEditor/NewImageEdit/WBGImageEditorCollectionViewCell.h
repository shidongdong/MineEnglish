//
//  WBGImageEditorCollectionViewCell.h
//  Minnie
//
//  Created by 栋栋 施 on 2019/1/5.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const WBGImageEditorCollectionViewCellId;

@interface WBGImageEditorCollectionViewCell : UICollectionViewCell

@property (weak,   nonatomic, readonly) IBOutlet UIScrollView *scrollView;
@property (weak,   nonatomic, readonly) IBOutlet UIImageView *imageView;

- (void)setupThumbImage:(UIImage *)thumbnailImage withOrignImageURLURL:(NSString *)originalImageUrl;

@end
