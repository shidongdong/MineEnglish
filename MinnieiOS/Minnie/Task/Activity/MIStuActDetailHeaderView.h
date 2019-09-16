//
//  MIStuActDetailHeaderView.h
//  MinnieStudent
//
//  Created by songzhen on 2019/6/9.
//  Copyright © 2019 minnieedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MIStuActDetailHeaderViewImageCallback)(NSString *, UIImageView *, NSInteger);
typedef void(^MIStuActDetailHeaderViewVideoCallback)(NSString *);
typedef void(^MIStuActDetailHeaderViewAudioCallback)(NSString *, NSString *);


@interface MIStuActDetailHeaderView : UIView

@property (nonatomic,strong) ActivityInfo *actInfo;

@property (nonatomic, copy) MIStuActDetailHeaderViewImageCallback imageCallback;
@property (nonatomic, copy) MIStuActDetailHeaderViewVideoCallback videoCallback;
@property (nonatomic, copy) MIStuActDetailHeaderViewAudioCallback audioCallback;



@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+ (CGFloat)heightWithActInfo:(ActivityInfo *)actInfo;

@end

NS_ASSUME_NONNULL_END
