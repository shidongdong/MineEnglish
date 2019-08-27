//
//  MISelectImageCollectionViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/8/26.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString * _Nullable const MISelectImageCollectionViewCellId;


NS_ASSUME_NONNULL_BEGIN

@interface MISelectImageCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) void(^deleteCallBack)(NSInteger index);

@property (nonatomic,copy) void(^imageCallBack)(NSInteger index);

- (void)setupImage:(NSString *)image index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
