//
//  CircleHomeworkFlag.h
//  Minnie
//
//  Created by 栋栋 施 on 2018/12/17.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CircleHomeworkFlag : MTLModel<MTLJSONSerializing>

@property(nonatomic,assign)NSInteger classNotice; //班级小红点：1表示有更新，0表示没有
@property(nonatomic,assign)NSInteger schoolNotice; //学校小红点：1表示有更新，0表示没有

@end


