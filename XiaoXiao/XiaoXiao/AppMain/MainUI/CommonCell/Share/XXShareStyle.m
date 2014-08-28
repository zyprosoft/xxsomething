//
//  XXShareStyle.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXShareStyle.h"

//DTCoreText默认图片之间的间隔大概
#define DTCoreTextInnerImageMargin 4

//3，4，5，6 的图片大小是一样的

@implementation XXShareStyle

+ (NSInteger)thumbImageWidthForContentWidth:(CGFloat)width withSharePostType:(XXSharePostType)sharePostType
{
    NSInteger thumbImageSize = 0;    
    switch (sharePostType) {
        case XXSharePostTypeImageAudio0:
            break;
        case XXSharePostTypeImageAudio1:
        {
            CGFloat singleThumbLeftRighMargin = [XXSharePostStyle sharePostSingleThumbLeftMargin];
            thumbImageSize = width-2*singleThumbLeftRighMargin;
        }
            break;
        case XXSharePostTypeImageAudio2:
        {
            CGFloat twoThumbLeftRgihtMargin = [XXSharePostStyle sharePostTwoThumbLeftMargin];
            thumbImageSize = (width-2*twoThumbLeftRgihtMargin)/2;
        }
            break;
        case XXSharePostTypeImageAudio3:
            thumbImageSize = (width-2*DTCoreTextInnerImageMargin)/3;
            break;
        case XXSharePostTypeImageAudio4:
            thumbImageSize = (width-2*DTCoreTextInnerImageMargin)/3;
            break;
        case XXSharePostTypeImageAudio5:
            thumbImageSize = (width-2*DTCoreTextInnerImageMargin)/3;
            break;
        case XXSharePostTypeImageAudio6:
            thumbImageSize = (width-2*DTCoreTextInnerImageMargin)/3;
            break;
        case XXSharePostTypeImageText0:
            break;
        case XXSharePostTypeImageText1:
        {
            CGFloat singleThumbLeftRighMargin = [XXSharePostStyle sharePostSingleThumbLeftMargin];
            thumbImageSize = width-2*singleThumbLeftRighMargin;
        }
            break;
        case XXSharePostTypeImageText2:
        {
            CGFloat twoThumbLeftRgihtMargin = [XXSharePostStyle sharePostTwoThumbLeftMargin];
            thumbImageSize = (width-2*twoThumbLeftRgihtMargin)/2;
        }
            break;
        case XXSharePostTypeImageText3:
            thumbImageSize = (width-2*DTCoreTextInnerImageMargin)/3;
            break;
        case XXSharePostTypeImageText4:
            thumbImageSize = (width-2*DTCoreTextInnerImageMargin)/3;
            break;
        case XXSharePostTypeImageText5:
            thumbImageSize = (width-2*DTCoreTextInnerImageMargin)/3;
            break;
        case XXSharePostTypeImageText6:
            thumbImageSize = (width-2*DTCoreTextInnerImageMargin)/3;
            break;
        default:
            break;
    }
    
    return thumbImageSize;
}

+ (XXShareStyle*)shareStyleForSharePostType:(XXSharePostType)sharePostType withContentWidth:(CGFloat)contentWidth
{
    XXShareStyle *shareStyle = [[XXShareStyle alloc]init];
    shareStyle.contentFontFamily = [XXSharePostStyle sharePostContentFontFamily];
    shareStyle.contentFontSize = [XXSharePostStyle sharePostContentFontSize];
    shareStyle.contentFontWeight = [XXSharePostStyle sharePostContentFontWeight];
    shareStyle.contentLineHeight = [XXSharePostStyle sharePostContentLineHeight];
    shareStyle.contentTextAlign = [XXSharePostStyle sharePostContentTextAlign];
    shareStyle.contentTextColor = [XXSharePostStyle sharePostContentTextColor];
    shareStyle.emojiSize = [XXSharePostStyle sharePostEmojiSize];
    shareStyle.audioImageWidth = [XXSharePostStyle sharePostAudioImageWidth];
    shareStyle.audioImageHeight = [XXSharePostStyle sharePostAudioImageHeight];
    
    //计算thumbImage的大小
    shareStyle.thumbImageSize = [self thumbImageWidthForContentWidth:contentWidth withSharePostType:sharePostType];
    
    return shareStyle;
    
}

+ (XXShareStyle*)commonStyle
{
    XXShareStyle *shareStyle = [[XXShareStyle alloc]init];
    shareStyle.contentFontFamily = [XXCommonStyle commonPostContentFontFamily];
    shareStyle.contentFontSize = [XXCommonStyle commonPostContentFontSize];
    shareStyle.contentFontWeight = [XXCommonStyle commonPostContentFontWeight];
    shareStyle.contentLineHeight = [XXCommonStyle commonPostContentLineHeight];
    shareStyle.contentTextAlign = [XXCommonStyle commonPostContentTextAlign];
    shareStyle.contentTextColor = [XXCommonStyle commonPostContentTextColor];
    shareStyle.emojiSize = [XXCommonStyle commonPostEmojiSize];
    
    return shareStyle;
}

+ (XXShareStyle*)chatStyle
{
    XXShareStyle *shareStyle = [[XXShareStyle alloc]init];
    shareStyle.contentFontFamily = [XXChatStyle contentFontFamily];
    shareStyle.contentFontSize = [XXChatStyle contentFontSize];
    shareStyle.contentFontWeight = [XXChatStyle contentFontWeight];
    shareStyle.contentLineHeight = [XXChatStyle contentLineHeight];
    shareStyle.contentTextAlign = [XXChatStyle contentTextAlign];
    shareStyle.contentTextColor = [XXChatStyle contentTextColor];
    shareStyle.emojiSize = [XXChatStyle emojiSize];
    
    return shareStyle;
}
@end
