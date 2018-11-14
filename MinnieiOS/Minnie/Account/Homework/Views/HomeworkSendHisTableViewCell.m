//
//  HomeworkSendHisTableViewCell.m
//  Minnie
//
//  Created by 栋栋 施 on 2018/11/1.
//  Copyright © 2018年 minnieedu. All rights reserved.
//

#import "HomeworkSendHisTableViewCell.h"

#define KContainerViewTopSpace  10.0f
#define KContainerViewBottomSpace  22.0f

#define KTimeLabelSpace 30.0f

NSString * const HomeworkSendHisTableViewCellId = @"HomeworkSendHisTableViewCellId";

@interface HomeworkSendHisTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *homeworkTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentLabel;

@end

@implementation HomeworkSendHisTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (CGFloat)calculateCellHightForData:(HomeworkSendLog *)data
{
    NSInteger maxLines = data.homeworkTitles.count;
    
    NSString * textStr;
    
    if (data.classNames.count + data.studentNames.count > maxLines)
    {
        maxLines = data.classNames.count + data.studentNames.count;
        NSString * tmpStr1 = [HomeworkSendHisTableViewCell generateStringFromArray:data.classNames];
        NSString * tmpStr2 = [HomeworkSendHisTableViewCell generateStringFromArray:data.studentNames];
        if (tmpStr1.length > 0)
        {
            textStr = [NSString stringWithFormat:@"%@\n%@",tmpStr1,tmpStr2];
        }
        else
        {
            textStr = tmpStr2;
        }
    }
    else
    {
        textStr = [HomeworkSendHisTableViewCell generateStringFromArray:data.homeworkTitles];
    }
    //计算文字的高度
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [textStr boundingRectWithSize:CGSizeMake((ScreenWidth - 24 - 20) / 3,MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
    
    
    return KContainerViewTopSpace + KContainerViewBottomSpace + KTimeLabelSpace + rect.size.height;
}

- (void)setContentData:(HomeworkSendLog *)data
{
    self.timeLabel.text = data.createTime;
    self.teacherLabel.text = data.teacherName;
    self.homeworkTitleLabel.text = [HomeworkSendHisTableViewCell generateStringFromArray:data.homeworkTitles];
    NSString * classStr = [HomeworkSendHisTableViewCell generateStringFromArray:data.classNames];
    NSString * studentStr = [HomeworkSendHisTableViewCell generateStringFromArray:data.studentNames];
    if (classStr.length > 0)
    {
        self.studentLabel.text = [NSString stringWithFormat:@"%@\n%@",classStr,studentStr];
    }
    else
    {
        self.studentLabel.text = studentStr;
    }
    
    
}

+ (NSString *)generateStringFromArray:(NSArray<NSString *> *)strArray
{
    NSMutableString * appendString = [[NSMutableString alloc] init];
    for (int i = 0; i < strArray.count; i++)
    {
        NSString * tmpStr = [strArray objectAtIndex:i];
        [appendString appendString:tmpStr];
        if (i != strArray.count - 1)
        {
            [appendString appendString:@"\n"];
        }
    }
    return appendString;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
