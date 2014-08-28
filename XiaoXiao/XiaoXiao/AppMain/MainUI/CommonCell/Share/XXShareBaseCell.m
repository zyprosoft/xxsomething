//
//  XXShareBaseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXShareBaseCell.h"
#import "XXRecordButton.h"

@implementation XXShareBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
        backgroundImageView = [[UIImageView alloc]init];
        backgroundImageView.frame = CGRectMake(10,20,self.frame.size.width-20,self.frame.size.height-20);
        backgroundImageView.image = [[UIImage imageNamed:@"share_post_back_normal.png"]makeStretchForSharePostList];
        backgroundImageView.highlightedImage = [[UIImage imageNamed:@"share_post_back_selected.png"]makeStretchForSharePostList];
        backgroundImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:backgroundImageView];
        
        //head view
        CGFloat originX = _contentLeftMargin+10;
        CGFloat originY = _contentTopHeight+10;
        
        _headView = [[XXHeadView alloc]initWithFrame:CGRectMake(originX,originY,53,53)];
        [backgroundImageView addSubview:_headView];
        
        //user View
        originX = _headView.frame.origin.x+_headView.frame.size.width + 10;
        _userView = [[XXSharePostUserView alloc]initWithFrame:CGRectMake(originX,originY+4,200,44)];
        _userView.backgroundColor = [UIColor clearColor];
        [backgroundImageView addSubview:_userView];
        
        //time label
        CGFloat timrOriginX = _contentLeftMargin;
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:9];
        _timeLabel.frame = CGRectMake(self.frame.size.width-timrOriginX*2-5-80,originY,50,20);
        [backgroundImageView addSubview:_timeLabel];
        
        //head sep line
        _headLineSep = [[UIImageView alloc]init];
        _headLineSep.frame = CGRectMake(_contentLeftMargin+10,_headView.frame.origin.y+_headView.frame.size.height+5,backgroundImageView.frame.size.width-20,1);
        _headLineSep.backgroundColor = [XXCommonStyle xxThemeButtonBoardColor];
        [backgroundImageView addSubview:_headLineSep];
        
        //post content
        shareTextView = [[DTAttributedTextContentView alloc]init];
        shareTextView.frame = CGRectMake(10,_headLineSep.frame.origin.y+10+4+1,[XXSharePostStyle sharePostContentWidth],self.frame.size.height);
        shareTextView.delegate = self;
        shareTextView.backgroundColor = [UIColor clearColor];
        [backgroundImageView addSubview:shareTextView];
        
        //bottom line
        _bottomLineSep = [[UIImageView alloc]init];
        _bottomLineSep.frame = CGRectMake(originX,10,backgroundImageView.frame.size.width,1);
        _bottomLineSep.backgroundColor = [XXCommonStyle xxThemeButtonBoardColor];
        [backgroundImageView addSubview:_bottomLineSep];
        
        //comment button
        _commentButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
        _commentButton.frame = CGRectMake(_contentLeftMargin+5,12,(backgroundImageView.frame.size.width-20)/2,46);
        [_commentButton setNormalIconImage:@"share_post_comment.png" withSelectedImage:@"share_post_comment.png" withFrame:CGRectMake(35,15.5,18.5,15)];
        [_commentButton setTitle:@"评论" withFrame:CGRectMake(80,3,50,34)];
        [_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0,25,0,0)];
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_commentButton defaultStyle];
        _commentButton.layer.borderColor = [UIColor clearColor].CGColor;
        [_commentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        [backgroundImageView addSubview:_commentButton];
     
        //verline
        _bottomVerLineSep = [[UIImageView alloc]init];
        CGFloat bVerLineOriginx = _commentButton.frame.origin.x+_commentButton.frame.size.width+ 5;
        _bottomVerLineSep.frame = CGRectMake(bVerLineOriginx,_commentButton.frame.origin.y+5,1,_commentButton.frame.size.height);
        _bottomVerLineSep.backgroundColor = [XXCommonStyle xxThemeButtonBoardColor];
        [backgroundImageView addSubview:_bottomVerLineSep];
        
        //praise button
        _praiseButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
        _praiseButton.frame = CGRectMake(_commentButton.frame.origin.x+_commentButton.frame.size.width+5,12,(backgroundImageView.frame.size.width-20)/2,46);
        [_praiseButton setNormalIconImage:@"share_post_praise_normal.png" withSelectedImage:@"share_post_praise_selected.png" withFrame:CGRectMake(35,15.5,18.5,15)];
        _praiseButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_praiseButton setTitle:@"追捧" withFrame:CGRectMake(80,3,50,34)];
        [_praiseButton setTitleEdgeInsets:UIEdgeInsetsMake(0,25,0,0)];
        [_praiseButton defaultStyle];
        _praiseButton.layer.borderColor = [UIColor clearColor].CGColor;
        [_praiseButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_praiseButton addTarget:self action:@selector(praiseAction) forControlEvents:UIControlEventTouchUpInside];
        [backgroundImageView addSubview:_praiseButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (!_isDetailState) {
        [backgroundImageView setHighlighted:highlighted];
    }
}

- (void)setSharePostModel:(XXSharePostModel *)postModel
{
    //set head view
    [_headView setRoundHeadWithUserId:postModel.userId];
    [_userView setContentModel:postModel];
    _timeLabel.text = postModel.friendAddTime;
    _isDetailState = NO;
    NSString *title = [NSString stringWithFormat:@"追捧(%@)",postModel.praiseCount];
    NSString *commentTitle = [NSString stringWithFormat:@"评论(%@)",postModel.commentCount];
    [_commentButton setTitle:commentTitle withFrame:CGRectMake(80,3,50,34)];
    [_praiseButton setTitle:title withFrame:CGRectMake(80,3,50,34)];
    if (!_allImages) {
        _allImages = [[NSMutableArray alloc]init];
        DDLogVerbose(@"postImages:%@",postModel.postImages);
        NSArray *imagesArray = [postModel.postImages componentsSeparatedByString:@"|"];
        [imagesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *originLink = (NSString*)obj;
            NSRange originRange = [originLink rangeOfString:@"/source"];
            if(originRange.location != NSNotFound){
                NSString *bigImageLink = [originLink substringWithRange:NSMakeRange(originRange.location,originLink.length-originRange.location)];
                NSString *hostBigImageLink = [NSString stringWithFormat:@"%@%@",XXBase_Host_Url,bigImageLink];
                [_allImages addObject:hostBigImageLink];
            }
            
        }];
    }else{
        [_allImages removeAllObjects];
        NSArray *imagesArray = [postModel.postImages componentsSeparatedByString:@"|"];
        [imagesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *originLink = (NSString*)obj;
            NSRange originRange = [originLink rangeOfString:@"/source"];
            if (originRange.location != NSNotFound) {
                NSString *bigImageLink = [originLink substringWithRange:NSMakeRange(originRange.location,originLink.length-originRange.location)];
                NSString *hostBigImageLink = [NSString stringWithFormat:@"%@%@",XXBase_Host_Url,bigImageLink];
                [_allImages addObject:hostBigImageLink];
            }
        }];
    }
    DDLogVerbose(@"allBigImagesArray :%@",_allImages);

    
    [shareTextView setAttributedString:postModel.attributedContent];
    CGSize contentSize = [shareTextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:[XXSharePostStyle sharePostContentWidth]];
    DDLogVerbose(@"content Size:%f",contentSize.height);
    
    CGFloat backHeight = _contentTopHeight*2 + _headView.frame.size.height + _contentTopHeight + contentSize.height + 5 + _commentButton.frame.size.height + 50;
    
    backgroundImageView.frame = CGRectMake(backgroundImageView.frame.origin.x,backgroundImageView.frame.origin.y,backgroundImageView.frame.size.width,backHeight);
    
    shareTextView.frame = CGRectMake(shareTextView.frame.origin.x,shareTextView.frame.origin.y,shareTextView.frame.size.width,contentSize.height);
    
    //bottom line
    _bottomLineSep.frame = CGRectMake(0,shareTextView.frame.origin.y+shareTextView.frame.size.height+5+9,_bottomLineSep.frame.size.width,1);
    
    _commentButton.frame = CGRectMake(_commentButton.frame.origin.x,_bottomLineSep.frame.origin.y+_bottomLineSep.frame.size.height+4,_commentButton.frame.size.width,_commentButton.frame.size.height);
    CGFloat bVerLineOriginx = _commentButton.frame.origin.x+_commentButton.frame.size.width+5;
    _bottomVerLineSep.frame = CGRectMake(bVerLineOriginx,_commentButton.frame.origin.y+2,1,_commentButton.frame.size.height-4);
    _praiseButton.frame = CGRectMake(_bottomVerLineSep.frame.origin.x+1+5,_bottomLineSep.frame.origin.y+_bottomLineSep.frame.size.height+4,_praiseButton.frame.size.width,_praiseButton.frame.size.height);
    

}

+ (CGFloat)heightWithSharePostModel:(XXSharePostModel *)postModel forContentWidth:(CGFloat)contentWidth
{
    CGFloat height = [XXShareBaseCell heightForAttributedText:postModel.attributedContent forWidth:[XXSharePostStyle sharePostContentWidth]] + 10+10+10*2 + 5 + 5+9 + 50 + 50 + 15;
    
    return height;
}


#pragma mark - custom DTImageView
- (UIView*)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        
        // if the attachment has a hyperlinkURL then this is currently ignored
		DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
		imageView.delegate = self;
		
		// sets the image if there is one
        NSRange audioRange = [attachment.hyperLinkURL.absoluteString rangeOfString:XXMIMETypeAudioFormatte];
        if (audioRange.location!=NSNotFound) {
        }else{
            imageView.image = [(DTImageTextAttachment *)attachment image];
        }
        
        
		
		// url for deferred loading
		imageView.url = attachment.contentURL;
		        
		// if there is a hyperlink then add a link button on top of this image
		if (attachment.hyperLinkURL)
		{
			// NOTE: this is a hack, you probably want to use your own image view and touch handling
			// also, this treats an image with a hyperlink by itself because we don't have the GUID of the link parts
			imageView.userInteractionEnabled = YES;
			
            if (audioRange.location != NSNotFound) {
                XXRecordButton *recordButton = [[XXRecordButton alloc]initWithFrame:imageView.bounds];
                recordButton.URL = attachment.hyperLinkURL;
                _recordBtn = recordButton;
                DDLogVerbose(@"link url:%@",recordButton.URL.absoluteString);
                NSString *audioTime = [[attachment.hyperLinkURL.absoluteString componentsSeparatedByString:@"$"]objectAtIndex:1];
                recordButton.recordTimeLabel.text = audioTime;
                recordButton.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
                recordButton.GUID = attachment.hyperLinkGUID;
                [recordButton setBackgroundImage:[UIImage imageNamed:@"audio_normal.png"] forState:UIControlStateNormal];
                [recordButton setBackgroundImage:[UIImage imageNamed:@"audio_selected.png"] forState:UIControlStateSelected];
                [recordButton addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:recordButton];

            }else{
                DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imageView.bounds];
                button.URL = attachment.hyperLinkURL;
                button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
                button.GUID = attachment.hyperLinkGUID;
                // use normal push action for opening URL
                [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:button];
            }
			
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
	for (DTTextAttachment *oneAttachment in [shareTextView.layoutFrame textAttachmentsWithPredicate:pred])
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
		[shareTextView relayoutText];
	}
}


- (void)setAttributedText:(NSAttributedString *)attributedText
{
    //    DDLogVerbose(@"attributed Text:%@",attributedText);
    [shareTextView setAttributedString:attributedText];
        CGFloat heightForAttributedText = [XXShareBaseCell heightForAttributedText:attributedText forWidth:shareTextView.frame.size.width];
    [shareTextView setFrame:CGRectMake(shareTextView.frame.origin.x,shareTextView.frame.origin.y,shareTextView.frame.size.width,heightForAttributedText)];
    
}

+ (CGFloat)heightForAttributedText:(NSAttributedString *)attributedText forWidth:(CGFloat)width
{
    //    DDLogVerbose(@"%@",attributedText);
    
    DTAttributedTextContentView *testView = [[DTAttributedTextContentView alloc]init];
    [testView setAttributedString:attributedText];
    
    CGSize contentSize = [testView suggestedFrameSizeToFitEntireStringConstraintedToWidth:width];
    
    return contentSize.height;
}

#pragma mark - block
- (void)linkPushed:(DTLinkButton*)linkButton
{
    //图片
    NSRange imageRange = [linkButton.URL.absoluteString rangeOfString:XXMIMETypeImageFormatte];
    if (imageRange.location!=NSNotFound) {
        
        NSString *imageUrl = [linkButton.URL.absoluteString substringWithRange:NSMakeRange(imageRange.length,linkButton.URL.absoluteString.length-imageRange.length)];
        
        NSRange originRange = [imageUrl rangeOfString:@"/source"];
        NSString *bigImageLink = [imageUrl substringWithRange:NSMakeRange(originRange.location,imageUrl.length-originRange.location)];
        
        DDLogVerbose(@"link push big image link:%@",bigImageLink);
        NSString *hostBigImageLink = [NSString stringWithFormat:@"%@%@",XXBase_Host_Url,bigImageLink];

        NSURL *imageRealURL = [NSURL URLWithString:hostBigImageLink];
        
        __block NSInteger currentIndex = 0;
        DDLogVerbose(@"allImages:%@",_allImages);
        [_allImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([hostBigImageLink isEqualToString:obj]) {
                currentIndex = idx;
                *stop = YES;
            }
        }];
        
        if (_tapImageBlock) {
            _tapImageBlock(imageRealURL,(UIImageView*)linkButton.superview,_allImages,currentIndex);
        }
        
    }
    
    //音频
    NSString *subRealAudioString = [[linkButton.URL.absoluteString componentsSeparatedByString:@"$"]objectAtIndex:0];
    NSRange audioRange = [subRealAudioString rangeOfString:XXMIMETypeAudioFormatte];
    if (audioRange.location!=NSNotFound) {
        
        NSString *audioUrl = [subRealAudioString substringWithRange:NSMakeRange(audioRange.length,subRealAudioString.length-audioRange.length)];
        
        NSURL *audioRealURL = [NSURL URLWithString:audioUrl];
        
        if (_tapAudioBlock) {
            _tapAudioBlock(audioRealURL,self);
        }
    }
    
}

- (void)setTapOnAudioImageBlock:(XXShareTextViewDidTapOnAudioImageBlock)tapAudioBlock
{
    _tapAudioBlock = [tapAudioBlock copy];
}
- (void)setTapOnThumbImageBlock:(XXShareTextViewDidTapOnThumbImageBlock)tapImageBlock
{
    _tapImageBlock = [tapImageBlock copy];
}

#pragma mark - 创建最终要显示的内容
+ (NSAttributedString*)buildAttributedStringWithSharePost:(XXSharePostModel *)sharePost forContentWidth:(CGFloat)width
{
    XXShareStyle *shareStyle = [XXShareStyle shareStyleForSharePostType:sharePost.postType withContentWidth:width];
    NSString *cssTemplate = [XXShareTemplateBuilder buildCSSTemplateWithBundleFormatteFile:XXBaseTextTemplateCSS withShareStyle:shareStyle];
    NSString *htmlContent = [XXShareTemplateBuilder buildSharePostContentWithCSSTemplate:cssTemplate withSharePostModel:sharePost];
    NSData *htmlData = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc]initWithHTMLData:htmlData documentAttributes:nil];
}

#pragma mark - 详情
- (void)setSharePostModelForDetail:(XXSharePostModel *)postModel
{
    //no comment no praise
    _commentButton.hidden  = YES;
    _praiseButton.hidden = YES;
    _bottomVerLineSep.hidden = YES;
    _isDetailState = YES;
    
    //set head view
    [_headView setRoundHeadWithUserId:postModel.userId];
    [_userView setContentModel:postModel];
    _timeLabel.text = postModel.friendAddTime;
    if (!_allImages) {
        _allImages = [[NSMutableArray alloc]init];
        DDLogVerbose(@"postImages:%@",postModel.postImages);
        NSArray *imagesArray = [postModel.postImages componentsSeparatedByString:@"|"];
        [imagesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *originLink = (NSString*)obj;
            NSRange originRange = [originLink rangeOfString:@"/source"];
            if (originRange.location != NSNotFound) {
                NSString *bigImageLink = [originLink substringWithRange:NSMakeRange(originRange.location,originLink.length-originRange.location)];
                NSString *hostBigImageLink = [NSString stringWithFormat:@"%@%@",XXBase_Host_Url,bigImageLink];
                [_allImages addObject:hostBigImageLink];
            }
            
        }];
    }else{
        [_allImages removeAllObjects];
        NSArray *imagesArray = [postModel.postImages componentsSeparatedByString:@"|"];
        [imagesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *originLink = (NSString*)obj;
            NSRange originRange = [originLink rangeOfString:@"/source"];
            if (originRange.location != NSNotFound) {
                NSString *bigImageLink = [originLink substringWithRange:NSMakeRange(originRange.location,originLink.length-originRange.location)];
                NSString *hostBigImageLink = [NSString stringWithFormat:@"%@%@",XXBase_Host_Url,bigImageLink];
                [_allImages addObject:hostBigImageLink];
            }
        }];
    }
    
    [shareTextView setAttributedString:postModel.attributedContent];
    CGSize contentSize = [shareTextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:[XXSharePostStyle sharePostContentWidth]];
    DDLogVerbose(@"detail content Size height:%f",contentSize.height);
    
    CGFloat backHeight = _contentTopHeight*2 + _headView.frame.size.height + _contentTopHeight + contentSize.height + 27+10 ;
    
    backgroundImageView.frame = CGRectMake(backgroundImageView.frame.origin.x,backgroundImageView.frame.origin.y,backgroundImageView.frame.size.width,backHeight);
    backgroundImageView.image = [[UIImage imageNamed:@"share_post_detail_top.png"]makeStretchForSharePostDetail];
    
    shareTextView.frame = CGRectMake(shareTextView.frame.origin.x,shareTextView.frame.origin.y,shareTextView.frame.size.width,contentSize.height);
    
    //bottom line
    _bottomLineSep.frame = CGRectMake(0,shareTextView.frame.origin.y+shareTextView.frame.size.height+5,_bottomLineSep.frame.size.width,1);
    _bottomLineSep.hidden = YES;
    
}
+ (CGFloat)heightWithSharePostModelForDetail:(XXSharePostModel *)postModel forContentWidth:(CGFloat)contentWidth
{
    CGFloat height = [XXShareBaseCell heightForAttributedText:postModel.attributedContent forWidth:[XXSharePostStyle sharePostContentWidth]] + 10+10+50+10+27+3;
    DDLogVerbose(@"detail post height:%f",height);
    return height;
}

- (void)setTapOnCommentBlock:(XXShareTextViewDidTapOnCommentBlock)commentBlock
{
    _tapCommentBlock = [commentBlock copy];
}
- (void)setTapOnPraiseBlock:(XXShareTextViewDidTapOnPraiseBlock)praiseBlock
{
    _tapPraiseBlock = [praiseBlock copy];
}
- (void)commentAction
{
    if (_tapCommentBlock) {
        _tapCommentBlock(self);
    }
}
- (void)praiseAction
{
    if ([_headView.userId isEqualToString:[XXUserDataCenter currentLoginUser].userId]) {
        if (_tapPraiseBlock) {
            _tapPraiseBlock(self,_praiseButton.selected);
        }
    }else{
        _praiseButton.selected = !_praiseButton.selected;
        
        NSRange leftTagRange = [_praiseButton.titleLabel.text rangeOfString:@"("];
        NSRange rightTagRange = [_praiseButton.titleLabel.text rangeOfString:@")"];
        
        NSInteger length = rightTagRange.location-leftTagRange.location;
        NSString *countString = [_praiseButton.titleLabel.text substringWithRange:NSMakeRange(leftTagRange.location+1,length)];
        NSInteger count = 0;
        if (_praiseButton.selected) {
            count = [countString intValue]+1;
        }else{
            count = [countString intValue]-1;
        }
        NSString *newCountString = [NSString stringWithFormat:@"追捧(%d)",count];
        [_praiseButton setTitle:newCountString withFrame:_praiseButton.frame];
        
        if (_tapPraiseBlock) {
            _tapPraiseBlock(self,_praiseButton.selected);
        }
    }
    
}

- (void)startAudioPlay
{
    [_recordBtn startPlay];
}
- (void)startLoadingAudio
{
    [_recordBtn startLoading];
}
- (void)endAudioPlay
{
    [_recordBtn endPlay];
}
- (void)endLoadingAudio
{
    [_recordBtn endLoading];
}

@end
