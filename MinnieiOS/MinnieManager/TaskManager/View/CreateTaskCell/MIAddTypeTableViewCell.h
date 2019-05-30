//
//  MIAddTypeTableViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/29.
//  Copyright © 2019 minnieedu. All rights reserved.
//  添加文件类型

#import <UIKit/UIKit.h>

typedef void(^AddActionCallback)(void);

extern CGFloat const MIAddTypeTableViewCellHeight;

extern NSString * _Nullable const MIAddTypeTableViewCellId;


NS_ASSUME_NONNULL_BEGIN

@interface MIAddTypeTableViewCell : UITableViewCell

@property (nonatomic, copy) AddActionCallback addCallback;

@end

NS_ASSUME_NONNULL_END
