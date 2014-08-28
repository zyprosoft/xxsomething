//
//  XXBaseTextView.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXShareStyle.h"

@interface XXBaseTextView : DTAttributedTextContentView
{
}

+ (NSAttributedString*)formatteCommonTextToAttributedText:(NSString*)contentText;

+ (NSAttributedString*)formatteCommonTextToAttributedText:(NSString*)contentText isFromSelf:(BOOL)isFromSelf;

+ (NSAttributedString*)formatteTextToAttributedText:(NSString*)contentText withHtmlTemplateFile:(NSString*)htmlTemplate withCSSTemplate:(NSString*)cssTemplate withShareStyle:(XXShareStyle*)aStyle;

- (void)setText:(NSString*)text;

- (void)setText:(NSString*)text withShareStyle:(XXShareStyle*)aStyle;

//限定宽度内所需最大高度
+ (CGFloat)heightForAttributedText:(NSAttributedString*)attributedText forWidth:(CGFloat)width;
+ (CGSize)sizeForAttributedText:(NSAttributedString*)attributedText forWidth:(CGFloat)width;

+ (NSString*)emojiTextToImageName:(NSString*)emojiText;
+ (NSString*)switchEmojiTextWithSourceText:(NSString*)source;

@end
