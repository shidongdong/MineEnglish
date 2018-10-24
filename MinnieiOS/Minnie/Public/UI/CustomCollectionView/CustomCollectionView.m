//
//  CustomCollectionView.m
//  PRIS_iPhone
//
//  Created by ios on 16/6/28.
//
//

#import "CustomCollectionView.h"

@implementation CustomCollectionView

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize intrinsicContentSize = self.contentSize;
    intrinsicContentSize.width = self.bounds.size.width;
    return intrinsicContentSize;
}

@end
