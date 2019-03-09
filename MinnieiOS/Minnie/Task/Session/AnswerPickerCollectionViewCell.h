//
//  AnswerPickerCollectionViewCell.h
//  Minnie
//
//  Created by 栋栋 施 on 2019/3/7.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Layout.h"
@interface AnswerPickerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, assign) BOOL bSelected;
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);

@end


