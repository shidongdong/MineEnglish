//
//  MIParticipateDetailTableViewCell.h
//  MinnieManager
//
//  Created by songzhen on 2019/5/31.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityInfo.h"

typedef void(^MIPlayVideoCallback)(NSString *_Nullable videoUrl);

typedef void(^MIQualifiedCallback)(NSInteger isOk, ActLogsInfo * _Nullable logInfo);

extern CGFloat const MIParticipateDetailTableViewCellHeight;

extern NSString * _Nullable const MIParticipateDetailTableViewCellId;


NS_ASSUME_NONNULL_BEGIN

@interface MIParticipateDetailTableViewCell : UITableViewCell

@property (nonatomic, copy) MIPlayVideoCallback playVideoCallback;
@property (nonatomic, copy) MIQualifiedCallback qualifiedCallback;

- (void)setupWithModel:(ActLogsInfo *)model index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
