//
//  Award.h
//  X5
//
//  Created by yebw on 2017/9/14.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Award : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger awardId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) NSUInteger price;
@property (nonatomic, assign) NSUInteger count;

@end
