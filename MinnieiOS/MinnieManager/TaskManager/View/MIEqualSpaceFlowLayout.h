//
//  MIEqualSpaceFlowLayout.h
//  MinnieManager
//
//  Created by songzhen on 2019/6/5.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  MIEqualSpaceFlowLayoutDelegate<UICollectionViewDelegateFlowLayout>

@end

NS_ASSUME_NONNULL_BEGIN

@interface MIEqualSpaceFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id<MIEqualSpaceFlowLayoutDelegate> delegate;

- (id)initWithCollectionViewWidth:(CGFloat)collectionViewWidth;

@end


NS_ASSUME_NONNULL_END
