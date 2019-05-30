//
//  MITitleTypeTableViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/30.
//  Copyright © 2019 minnieedu. All rights reserved.
//  标题类型

#import <UIKit/UIKit.h>

extern CGFloat const MITitleTypeTableViewCellHeight;

extern NSString * _Nullable const MITitleTypeTableViewCellId;


NS_ASSUME_NONNULL_BEGIN

@interface MITitleTypeTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString * title;

@end

NS_ASSUME_NONNULL_END
