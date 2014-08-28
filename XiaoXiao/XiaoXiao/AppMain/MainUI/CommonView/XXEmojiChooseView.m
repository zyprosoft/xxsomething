//
//  XXEmojiChooseView.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXEmojiChooseView.h"

#define XXEmojiRowCount 4
#define XXEmojiColunmCount 7
#define XXEmojiHeight 26
#define XXEmojWdith 29

@interface XXEmojiImageView : UIButton
@property (nonatomic,strong)NSString *faceName;
@end
@implementation XXEmojiImageView
@end

@implementation XXEmojiChooseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSString *sourcePath = [[NSBundle mainBundle]pathForResource:@"xx_emoji_text" ofType:@"plist"];
        NSDictionary *faceDict = [NSDictionary dictionaryWithContentsOfFile:sourcePath];
        
        CGFloat itemLeftMargin = (frame.size.width-XXEmojWdith*XXEmojiColunmCount)/(XXEmojiColunmCount+1);
        CGFloat itemTopMargin = (frame.size.height-XXEmojiHeight*XXEmojiRowCount)/(XXEmojiRowCount+1);
        
        NSArray *emojisArray = [faceDict allKeys];
        [emojisArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSInteger rowIndex = idx/XXEmojiColunmCount;
            NSInteger cloumIndex =idx%XXEmojiColunmCount;
            
            CGFloat originX = itemLeftMargin*(cloumIndex+1)+cloumIndex*XXEmojWdith;
            CGFloat originY = itemTopMargin*(rowIndex+1)+rowIndex*XXEmojiHeight;
            
            CGRect itemRect = CGRectMake(originX,originY,XXEmojWdith,XXEmojiHeight);
            
            XXEmojiImageView *itemView = [[XXEmojiImageView alloc]init];
            itemView.frame = itemRect;
            
            itemView.faceName = [emojisArray objectAtIndex:idx];
            [itemView setBackgroundImage:[UIImage imageNamed:[faceDict objectForKey:[emojisArray objectAtIndex:idx]]] forState:UIControlStateNormal];
            
            [itemView addTarget:self action:@selector(didTapOnEmojiView:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:itemView];
            
        }];
        
    }
    return self;
}

- (void)didTapOnEmojiView:(XXEmojiImageView *)item
{
    if (_selectBlock) {
        _selectBlock(item.faceName);
    }
}

- (void)setEmojiViewDidSelectBlock:(XXEmojiViewDidTapSelectEmojiBlock)selectBlock
{
    _selectBlock = [selectBlock copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
