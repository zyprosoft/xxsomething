//
//  XXBaseTextView.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXBaseTextView : UIView<DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>
{
    DTAttributedTextContentView *contentAttributedView;
}

- (void)setAttributedText:(NSAttributedString*)attributedText;

//限定宽度内所需最大高度
+ (CGFloat)heightForAttributedText:(NSAttributedString*)attributedText forWidth:(CGFloat)width;

//限定高度内所需最大宽度
+ (CGFloat)widthForAttributedText:(NSAttributedString*)attributedText forHeight:(CGFloat)height;

@end
