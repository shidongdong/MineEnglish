//
//  AchieverUpdateMedalDetailRequest.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/6.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "AchieverUpdateMedalDetailRequest.h"

@interface AchieverUpdateMedalDetailRequest()

@property(nonatomic,strong)UserMedalDetail * mData;
@property(nonatomic,assign)NSInteger mIndex; //1 2 3代表铜银金
@end

@implementation AchieverUpdateMedalDetailRequest

- (instancetype)initWithMedalData:(UserMedalDetail *)data atMedalIndex:(NSInteger)index{
    self = [super init];
    if (self != nil) {
        self.mData = data;
        self.mIndex = index;
    }
    return self;
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/medal/updateMedalFlag", ServerProjectName];
}

- (id)requestArgument {
    return @{@"id":@(self.mData.medalId),
             @"firstFlag":@(self.mData.firstFlag),
             @"sencondFlag":@(self.mData.sencondFlag),
             @"thirdFlag":@(self.mData.thirdFlag),
             @"medalType":self.mData.medalType,
             @"changeFlag":@(self.mIndex)
             };
}

@end
