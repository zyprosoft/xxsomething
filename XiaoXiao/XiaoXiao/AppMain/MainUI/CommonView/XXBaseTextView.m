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
        
        contentAttributedView = [[DTAttributedTextContentView alloc]init];
        contentAttributedView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        contentAttributedView.delegate = self;
        [self addSubview:contentAttributedView];
        
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

#pragma mark - custom DTImageView
- (UIView*)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        
        // if the attachment has a hyperlinkURL then this is currently ignored
		DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
		imageView.delegate = self;
		
		// sets the image if there is one
		imageView.image = [(DTImageTextAttachment *)attachment image];
		
		// url for deferred loading
		imageView.url = attachment.contentURL;
		
		// if there is a hyperlink then add a link button on top of this image
		if (attachment.hyperLinkURL)
		{
			// NOTE: this is a hack, you probably want to use your own image view and touch handling
			// also, this treats an image with a hyperlink by itself because we don't have the GUID of the link parts
			imageView.userInteractionEnabled = YES;
			
			DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imageView.bounds];
			button.URL = attachment.hyperLinkURL;
			button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
			button.GUID = attachment.hyperLinkGUID;
			
			// use normal push action for opening URL
			[button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
			
			// demonstrate combination with long press
			UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
			[button addGestureRecognizer:longPress];
			
			[imageView addSubview:button];
		}
		
		return imageView;
        
    }else{
        return nil;
    }
}

#pragma mark DTLazyImageViewDelegate

- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
	NSURL *url = lazyImageView.url;
	CGSize imageSize = size;
	
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
	
	BOOL didUpdate = NO;
	
	// update all attachments that matchin this URL (possibly multiple images with same size)
	for (DTTextAttachment *oneAttachment in [contentAttributedView.layoutFrame textAttachmentsWithPredicate:pred])
	{
		// update attachments that have no original size, that also sets the display size
		if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
		{
			oneAttachment.originalSize = imageSize;
			
			didUpdate = YES;
		}
	}
	
	if (didUpdate)
	{
		// layout might have changed due to image sizes
		[contentAttributedView relayoutText];
	}
}

#pragma mark - Interface
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [contentAttributedView setAttributedString:attributedText];
}

- (void)setText:(NSString *)text
{
    
}

+ (CGFloat)heightForAttributedText:(NSAttributedString *)attributedText forWidth:(CGFloat)width
{
    DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:attributedText];
    
    CGRect maxRect = CGRectMake(0,0, width, CGFLOAT_HEIGHT_UNKNOWN);
    NSRange entireString = NSMakeRange(0, [attributedText length]);
    DTCoreTextLayoutFrame *layoutFrame = [layouter layoutFrameWithRect:maxRect range:entireString];
    
    CGSize sizeNeeded = [layoutFrame frame].size;
    
    return sizeNeeded.height;
}

+ (CGFloat)widthForAttributedText:(NSAttributedString *)attributedText forHeight:(CGFloat)height
{
    DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:attributedText];
    
    CGRect maxRect = CGRectMake(0,0, CGFLOAT_WIDTH_UNKNOWN, height);
    NSRange entireString = NSMakeRange(0, [attributedText length]);
    DTCoreTextLayoutFrame *layoutFrame = [layouter layoutFrameWithRect:maxRect range:entireString];
    
    CGSize sizeNeeded = [layoutFrame frame].size;
    
    return sizeNeeded.width;
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
