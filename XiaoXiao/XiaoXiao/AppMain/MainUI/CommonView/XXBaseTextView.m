//
//  XXBaseTextView.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXBaseTextView.h"

NSString *const XXEmojiCSSFormate = @"<img class=\"emoji\" src=\"%@\">";
NSString *const XXEmojiTagFormate = @"[]";

@implementation XXBaseTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



#pragma mark - Interface
+ (NSAttributedString*)formatteCommonTextToAttributedText:(NSString *)contentText
{
    NSString *commonCss = [XXShareTemplateBuilder buildCommonCSSTemplateWithBundleFormatteFile:XXCommonTextTemplateCSS withShareStyle:[XXShareStyle chatStyle]];
    NSString *htmlString = [XXShareTemplateBuilder buildCommonTextContentWithCSSTemplate:commonCss withConentText:contentText];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithHTMLData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    
    return attributedString;
}

#pragma mark - Interface
+ (NSAttributedString*)formatteCommonTextToAttributedText:(NSString *)contentText isFromSelf:(BOOL)isFromSelf
{
    XXShareStyle *chatStyle = [XXShareStyle chatStyle];
    if (isFromSelf) {
        chatStyle.contentTextAlign = XXTextAlignRight;
    }
    NSString *commonCss = [XXShareTemplateBuilder buildCommonCSSTemplateWithBundleFormatteFile:XXCommonTextTemplateCSS withShareStyle:chatStyle];
    NSString *htmlString = [XXShareTemplateBuilder buildCommonTextContentWithCSSTemplate:commonCss withConentText:contentText];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithHTMLData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    
    return attributedString;
}

+ (NSAttributedString*)formatteTextToAttributedText:(NSString *)contentText withHtmlTemplateFile:(NSString *)htmlTemplate withCSSTemplate:(NSString *)cssTemplate withShareStyle:(XXShareStyle *)aStyle
{
    NSString *css = [XXShareTemplateBuilder buildCommonCSSTemplateWithBundleFormatteFile:cssTemplate withShareStyle:aStyle];
    NSString *htmlString = [XXShareTemplateBuilder buildHtmlContentWithCSSTemplate:css withHtmlTemplateFile:htmlTemplate withConentText:contentText];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithHTMLData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    
    return attributedString;
}

- (void)setText:(NSString *)text
{
    self.attributedString = [XXBaseTextView formatteCommonTextToAttributedText:text];
}

- (void)setText:(NSString *)text withShareStyle:(XXShareStyle *)aStyle
{
    NSString *commonCss = [XXShareTemplateBuilder buildCommonCSSTemplateWithBundleFormatteFile:XXCommonTextTemplateCSS withShareStyle:aStyle];
    NSString *htmlString = [XXShareTemplateBuilder buildCommonTextContentWithCSSTemplate:commonCss withConentText:text];
    
    NSAttributedString *attridString = [[NSAttributedString alloc]initWithHTMLData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    
    self.attributedString = attridString;
}

+ (CGFloat)heightForAttributedText:(NSAttributedString *)attributedText forWidth:(CGFloat)width
{
    DTAttributedTextContentView *testView = [[DTAttributedTextContentView alloc]init];
    [testView setAttributedString:attributedText];
    
    CGSize contentSize = [testView suggestedFrameSizeToFitEntireStringConstraintedToWidth:width];
    
    return contentSize.height;
}
+ (CGSize)sizeForAttributedText:(NSAttributedString *)attributedText forWidth:(CGFloat)width
{
    DTAttributedTextContentView *testView = [[DTAttributedTextContentView alloc]init];
    [testView setAttributedString:attributedText];
    
    CGSize contentSize = [testView suggestedFrameSizeToFitEntireStringConstraintedToWidth:width];
    
    return contentSize;
}

#pragma mark - switch emoji text to image tag

+ (NSString*)emojiTextToImageName:(NSString *)emojiText
{
    NSDictionary *gifDict = [XXFileUitil loadDictionaryFromBundleForName:XXEmojiTextPlist];
    
    NSString *gifName = [gifDict objectForKey:emojiText];
    
    return gifName;
}

+ (NSString*)switchEmojiTextWithSourceText:(NSString *)source
{
    if (!source) {
        return nil;
    }
    NSString *leftEmojiTag = [XXEmojiTagFormate substringWithRange:NSMakeRange(0,1)];
    NSString *rightEmojiTag = [XXEmojiTagFormate substringWithRange:NSMakeRange(1,1)];
    NSString *leftImageTag = [XXEmojiCSSFormate substringWithRange:NSMakeRange(0,1)];
    
    NSMutableString *resultString = [NSMutableString string];
    NSArray *arrayByLeftTag = [source componentsSeparatedByString:leftEmojiTag];
    
    if (arrayByLeftTag.count > 1) {
        
        for (int i=0;i<arrayByLeftTag.count;i++) {
            
            NSString *string = [arrayByLeftTag objectAtIndex:i];
            
            if (i!=0) {
                
                NSRange rightTagRange = [string rangeOfString:rightEmojiTag];
                
                if (rightTagRange.location != NSNotFound) {
                    
                    NSArray *leftRangArray = [string componentsSeparatedByString:rightEmojiTag];
                    
                    if (leftRangArray.count > 1) {
                        
                        NSString *emojiString = [leftRangArray objectAtIndex:0];
                        
                        NSString *gifName = [XXBaseTextView emojiTextToImageName:emojiString];
                        
                        if (i>0) {
                            
                            [resultString appendFormat:XXEmojiCSSFormate,gifName];
                            
                            if ([leftRangArray objectAtIndex:1]!=nil||![[leftRangArray objectAtIndex:1] isEqualToString:@""]) {
                                [resultString appendString:[leftRangArray objectAtIndex:1]];
                            }
                            
                        }else {
                            
                            [resultString appendFormat:[XXEmojiCSSFormate substringWithRange:NSMakeRange(1,XXEmojiCSSFormate.length-1)],gifName];
                            
                            if ([leftRangArray objectAtIndex:1]!=nil||![[leftRangArray objectAtIndex:1] isEqualToString:@""]) {
                                [resultString appendString:leftImageTag];
                            }
                        }
                        
                    }
                    
                }else {
                    
                    [resultString appendFormat:@"%@",string];
                    
                }
                
            }else{
                [resultString appendFormat:@"%@",string];
            }
            
        }
        
    }else {
        
        [resultString appendString:source];
    }
    
    return resultString;
}


@end
