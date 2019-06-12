//
//  MIReadingWordsView.m
//  Minnie
//
//  Created by songzhen on 2019/6/10.
//  Copyright © 2019 minnieedu. All rights reserved.
//
#import "MIReadingWordsView.h"
#import <AVFoundation/AVFoundation.h>


@interface MIReadingWordsView ()

@property (weak, nonatomic) IBOutlet UIView *wordsView;
@property (weak, nonatomic) IBOutlet UILabel *englishLabel;

@property (strong,nonatomic) NSTimer *wordsTimer;

@property (assign,nonatomic) NSInteger currentWordIndex;

@end


@implementation MIReadingWordsView

-(void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setWordsItem:(HomeworkItem *)wordsItem{
    
    _wordsItem = wordsItem;
    WordInfo *tempWord = _wordsItem.words.firstObject;
    self.englishLabel.text = tempWord.english;
}

- (void)startPlayWords{
  
    [self invalidateTimer];
    WordInfo *tempWord = _wordsItem.words.firstObject;
    self.englishLabel.text = tempWord.english;
    
    _currentWordIndex = 0;
    [self.wordsTimer fireDate];
}
- (void)stopPlayWords{
    
    [self invalidateTimer];
}

-(NSTimer *)wordsTimer{
    
    if (!_wordsTimer) {
    
        _wordsTimer = [NSTimer scheduledTimerWithTimeInterval:self.wordsItem.playTime target:self selector:@selector(playWords) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.wordsTimer forMode:NSDefaultRunLoopMode];
    }
    return _wordsTimer;
}


- (void)invalidateTimer{
    _currentWordIndex = 0;
    [self.wordsTimer invalidate];
    self.wordsTimer = nil;
}

- (void)playWords{
    
    if (_currentWordIndex < self.wordsItem.words.count) {
        WordInfo *tempWord = self.wordsItem.words[_currentWordIndex];
        [UIView animateWithDuration:0.5 animations:^{
            
            self.englishLabel.text = tempWord.english;
        }];
    } else {
        
        [self stopPlayWords];
        if (self.readingWordsCallBack) {
            self.readingWordsCallBack();
        }
    }
    _currentWordIndex ++;
}

@end
