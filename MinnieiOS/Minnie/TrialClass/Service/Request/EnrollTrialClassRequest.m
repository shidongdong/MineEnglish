//
//  EnrollTrialClassRequest.m
//  MinnieStudent
//
//  Created by yebw on 2018/4/14.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "EnrollTrialClassRequest.h"

@interface EnrollTrialClassRequest()

@property (nonatomic, assign) NSInteger classId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, assign) NSInteger gender;

@end

@implementation EnrollTrialClassRequest

- (instancetype)initWithName:(NSString *)name
                       grade:(NSString *)grade
                      gender:(NSInteger)gender {
    self = [super init];
    if (self != nil) {
        _name = name;
        _grade = grade;
        _gender = gender;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@/class/enroll", ServerProjectName];
}

- (id)requestArgument {
    return @{@"nickname":self.name,
             @"grade":self.grade,
             @"gender":@(self.gender)};
}

@end


