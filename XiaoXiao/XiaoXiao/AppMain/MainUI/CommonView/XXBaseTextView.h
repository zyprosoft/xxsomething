//
//  XXBaseTextView.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const XXEmojiCSSFormate;
extern NSString *const XXEmojiTagFormate;

@interface XXBaseTextView : UIView<DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>
{
    DTAttributedTextContentView *contentAttributedView;
}
@property (nonatomic,assign)NSInteger fontSize;
@property (nonatomic,assign)NSInteger lineHeight;
@property (nonatomic,assign)NSInteger emojiSize;

- (void)setAttributedText:(NSAttributedString*)attributedText;

- (void)setText:(NSString*)text;

//限定宽度内所需最大高度
+ (CGFloat)heightForAttributedText:(NSAttributedString*)attributedText forWidth:(CGFloat)width;

//限定高度内所需最大宽度
+ (CGFloat)widthForAttributedText:(NSAttributedString*)attributedText forHeight:(CGFloat)height;

+ (NSString*)emojiTextToImageName:(NSString*)emojiText;
+ (NSString*)switchEmojiTextWithSourceText:(NSString*)source;

@end
