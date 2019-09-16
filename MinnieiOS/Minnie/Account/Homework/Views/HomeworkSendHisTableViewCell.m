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
        NSString * tmpStr1 = [HomeworkSendHisTableViewCell generateStringFromArray:data.classNames withIndexShow:NO];
        NSString * tmpStr2 = [HomeworkSendHisTableViewCell generateStringFromArray:data.studentNames withIndexShow:NO];
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
        textStr = [HomeworkSendHisTableViewCell generateStringFromArray:data.homeworkTitles withIndexShow:YES];
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
    
    NSAttributedString *title = [HomeworkSendHisTableViewCell generateBoldStringFromArray:data.homeworkTitles withIndexShow:YES];
    self.homeworkTitleLabel.attributedText = title;
    
    NSString * classStr = [HomeworkSendHisTableViewCell generateStringFromArray:data.classNames withIndexShow:NO];
    NSString * studentStr = [HomeworkSendHisTableViewCell generateStringFromArray:data.studentNames withIndexShow:NO];
    if (classStr.length > 0)
    {
        self.studentLabel.text = [NSString stringWithFormat:@"%@\n%@",classStr,studentStr];
    }
    else
    {
        self.studentLabel.text = studentStr;
    }
    
    
}

// 索引加粗
+ (NSAttributedString *)generateBoldStringFromArray:(NSArray<NSString *> *)strArray withIndexShow:(BOOL)bShow{
   
    NSMutableString * appendString = [[NSMutableString alloc] init];
    NSMutableArray *indexArray = [NSMutableArray array];
    for (int i = 0; i < strArray.count; i++)
    {
        
        if (bShow)
        {
            
            NSString *currentIndexStr = [NSString stringWithFormat:@"%d",i+1];
            
            [appendString appendString:[NSString stringWithFormat:@"%@.",currentIndexStr]];
            [indexArray addObject:@(appendString.length - (currentIndexStr.length + 1))];
        }
        NSString * tmpStr = [strArray objectAtIndex:i];
        [appendString appendString:tmpStr];
        if (i != strArray.count - 1)
        {
            [appendString appendString:@"\n"];
        }
    }
    // 索引加粗
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:appendString];
    [attr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, appendString.length)];
    if (appendString.length) {
        
        for (NSNumber *index in indexArray) {
            
            NSString *currentIndexStr = [NSString stringWithFormat:@"%lu",(unsigned long)[indexArray indexOfObject:index]];

            if (index.intValue < appendString.length) {
                [attr setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} range:NSMakeRange(index.intValue, currentIndexStr.length + 1)];
            }
        }
    }
    return attr;
}
+ (NSString *)generateStringFromArray:(NSArray<NSString *> *)strArray withIndexShow:(BOOL)bShow
{
    NSMutableString * appendString = [[NSMutableString alloc] init];
    NSMutableArray *indexArray = [NSMutableArray array];
    for (int i = 0; i < strArray.count; i++)
    {
        if (bShow)
        {
            [appendString appendString:[NSString stringWithFormat:@"%d.",i + 1]];
            [indexArray addObject:@(i+1)];
        }
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
