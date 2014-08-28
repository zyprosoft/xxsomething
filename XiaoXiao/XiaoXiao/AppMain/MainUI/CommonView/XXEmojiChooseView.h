//
//  XXEmojiChooseView.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XXEmojiViewDidTapSelectEmojiBlock) (NSString *emoji);
@interface XXEmojiChooseView : UIView
{
    XXEmojiViewDidTapSelectEmojiBlock _selectBlock;
}
- (id)initWithDefaultConfig;
- (id)initWithFrame:(CGRect)frame withEmojisArray:(NSArray*)emojisArray;
- (void)setEmojiViewDidSelectBlock:(XXEmojiViewDidTapSelectEmojiBlock)selectBlock;
@end
