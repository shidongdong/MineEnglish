//
//  AVIMWordsMessage.m
//  Minnie
//
//  Created by songzhen on 2019/6/12.
//  Copyright © 2019 minnieedu. All rights reserved.
//
#define kAVIMMessageWordType
#import "AVIMWordsMessage.h"

@interface AVIMWordsMessage ()
<
AVIMTypedMessageSubclassing
>

@end

@implementation AVIMWordsMessage

+ (AVIMMessageMediaType)classMediaType {
    return kAVIMMessageMediaTypeAudio;
}


@end
