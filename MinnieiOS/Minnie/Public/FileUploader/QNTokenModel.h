//
//  QNTokenModel.h
//  Minnie
//
//  Created by 栋栋 施 on 2019/3/1.
//  Copyright © 2019年 minnieedu. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface QNTokenModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,assign)NSInteger expires;
@property(nonatomic,strong)NSString * upToken;

@end


