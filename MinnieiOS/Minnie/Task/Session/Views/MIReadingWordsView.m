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
        NSInteger playTime = self.wordsItem.playtime/1000;
        if (playTime == 0) {
            playTime = 2.0;
        }
        _wordsTimer = [NSTimer scheduledTimerWithTimeInterval:playTime target:self selector:@selector(playWords) userInfo:nil repeats:YES];
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
        self.englishLabel.text = tempWord.english;
    } else {
        
        [self stopPlayWords];
        if (self.readingWordsCallBack) {
            self.readingWordsCallBack();
        }
    }
    _currentWordIndex ++;
}

@end
