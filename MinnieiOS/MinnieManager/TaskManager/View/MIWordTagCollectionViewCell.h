//
//  MIWordTagCollectionViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/6/6.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * _Nullable const MIWordTagCollectionViewCellId;

NS_ASSUME_NONNULL_BEGIN

@interface MIWordTagCollectionViewCell : UICollectionViewCell

// sting wordInfo
- (void)setupWithText:(id)text isEditState:(BOOL)isEditState isLast:(BOOL)isLast;

+ (CGSize)cellSizeWithTag:(id)tag;

@end

NS_ASSUME_NONNULL_END
