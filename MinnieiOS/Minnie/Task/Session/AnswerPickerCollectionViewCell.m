//
//  AnswerPickerCollectionViewCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2019/3/7.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import "AnswerPickerCollectionViewCell.h"

@interface AnswerPickerCollectionViewCell()

@property (strong, nonatomic) UIImageView *imageView;       // The photo / 照片
@property (strong, nonatomic) UIImageView *selectImageView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIButton *selectPhotoButton;
@end

@implementation AnswerPickerCollectionViewCell



- (void)selectPhotoButtonClick:(UIButton *)sender {
    if (self.didSelectPhotoBlock) {
        self.didSelectPhotoBlock(sender.isSelected);
    }
  //  self.selectImageView.image = sender.isSelected ? nil : nil;
}


- (void)layoutSubviews {
    [super layoutSubviews];
 
    _selectPhotoButton.frame = CGRectMake(self.tz_width - 44, 0, 44, 44);
   
    _selectImageView.frame = CGRectMake(self.tz_width - 27, 3, 24, 24);
    if (_selectImageView.image.size.width <= 27) {
        _selectImageView.contentMode = UIViewContentModeCenter;
    } else {
        _selectImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    _imageView.frame = CGRectMake(0, 0, self.tz_width, self.tz_height);
    
    [self.contentView bringSubviewToFront:_selectPhotoButton];
    [self.contentView bringSubviewToFront:_selectImageView];

    
}

#pragma mark - Lazy load

- (UIButton *)selectPhotoButton {
    if (_selectPhotoButton == nil) {
        UIButton *selectPhotoButton = [[UIButton alloc] init];
        [selectPhotoButton addTarget:self action:@selector(selectPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selectPhotoButton];
        _selectPhotoButton = selectPhotoButton;
    }
    return _selectPhotoButton;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        _imageView = imageView;

    }
    return _imageView;
}

- (UIImageView *)selectImageView {
    if (_selectImageView == nil) {
        UIImageView *selectImageView = [[UIImageView alloc] init];
        selectImageView.contentMode = UIViewContentModeCenter;
        selectImageView.clipsToBounds = YES;
        [self.contentView addSubview:selectImageView];
        _selectImageView = selectImageView;
    }
    return _selectImageView;
}


@end
