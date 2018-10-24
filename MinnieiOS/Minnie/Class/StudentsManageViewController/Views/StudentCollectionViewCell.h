//
//  StudentCollectionViewCell.h
//  X5
//
//  Created by yebw on 2017/9/4.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

typedef void(^StudentSelectCallback)(NSUInteger userId, BOOL selected);

extern NSString * const StudentCollectionViewCellId;

@interface StudentCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) StudentSelectCallback deleteCallback;

+ (CGSize)size;

- (void)setupWithUser:(User *)user;

- (void)updateWithDeleteMode:(BOOL)deleteMode selected:(BOOL)selected;

@end

