//
//  XXShareBaseCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXSharePostModel.h"
#import "AGMedallionView.h"
#import "XXSharePostUserView.h"
#import "XXCustomButton.h"
#import "XXHeadView.h"
#import "XXRecordButton.h"

@class XXShareBaseCell;
@class DTLinkButton;

typedef void (^XXShareTextViewDidTapOnThumbImageBlock) (NSURL *imageUrl,UIImageView *originImageView,NSArray *allImages,NSInteger currentIndex);
typedef void (^XXShareTextViewDidTapOnAudioImageBlock) (NSURL *audioUrl,XXShareBaseCell *cell);
typedef void (^XXShareTextViewDidTapOnCommentBlock) (XXShareBaseCell *cell);
typedef void (^XXShareTextViewDidTapOnPraiseBlock) (XXShareBaseCell *cell,BOOL selectState);

//用于加入到超链接中，以实现放大图片，播放音频类型判断 ,例如 ：  xxshare_image:http://www.test.com/1.png xxshare_audio:http://www.test.com/a.amr
#define XXMIMETypeImageFormatte @"xxshare_image:"
#define XXMIMETypeAudioFormatte @"xxshare_audio:"
#define XXSharePostJSONTypeKey  @"xxshare_post_type"
#define XXSharePostJSONImageKey @"xxshare_post_images"
#define XXSharePostJSONAudioKey @"xxshare_post_audio"
#define XXSharePostJSONContentKey @"xxshare_post_content"
#define XXSharePostJSONAudioTime @"xxshare_post_audio_time"

//分享内容规则
/*
 *
 {
 xxshare_post_type:XXSharePostType;         //定义分享内容模板，如 一个图片带一个音频，两个图片带一个音频
 xxshare_post_images:xx.png|xxx.png|xxx.png;//定义分享的图片的链接, | 隔开，区分图片
 xxshare_post_audio:xx.caf;                 //定义音频地址
 xxshare_post_content:@"test share content";//定义分享的文字内容
 
 xxshare_post_audio_time:@"7";               //定义分享录音得长度,如7秒，以秒数为单位
 }
 *
 */

@interface XXShareBaseCell : UITableViewCell<DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>
{
    UIImageView *backgroundImageView;
    DTAttributedTextContentView *shareTextView;
    XXSharePostUserView *_userView;
    
    //头像
    XXHeadView *_headView;
    UILabel         *_timeLabel;
    XXCustomButton  *_praiseButton;
    XXCustomButton  *_commentButton;
    UIImageView     *_headLineSep;
    UIImageView     *_bottomLineSep;
    UIImageView     *_bottomVerLineSep;
    
    //refrence for record
    XXRecordButton *_recordBtn;
    
    //config
    CGFloat         _headViewSize;
    CGFloat         _contentLeftMargin;
    CGFloat         _contentTopHeight;
    CGFloat         _bottomViewFontSize;
    BOOL            _isDetailState;
    
    //images
    NSMutableArray        *_allImages;
    
    XXShareTextViewDidTapOnAudioImageBlock _tapAudioBlock;
    XXShareTextViewDidTapOnThumbImageBlock _tapImageBlock;
    XXShareTextViewDidTapOnCommentBlock _tapCommentBlock;
    XXShareTextViewDidTapOnPraiseBlock _tapPraiseBlock;
}

- (void)setSharePostModel:(XXSharePostModel*)postModel;
- (void)setSharePostModelForDetail:(XXSharePostModel*)postModel;//详情页面使用

+ (CGFloat)heightWithSharePostModel:(XXSharePostModel*)postModel forContentWidth:(CGFloat)contentWidth;
+ (CGFloat)heightWithSharePostModelForDetail:(XXSharePostModel*)postModel forContentWidth:(CGFloat)contentWidth;//详情页面使用

//限定宽度内所需最大高度
+ (CGFloat)heightForAttributedText:(NSAttributedString*)attributedText forWidth:(CGFloat)width;

- (void)setTapOnAudioImageBlock:(XXShareTextViewDidTapOnAudioImageBlock)tapAudioBlock;
- (void)setTapOnThumbImageBlock:(XXShareTextViewDidTapOnThumbImageBlock)tapImageBlock;
- (void)setTapOnCommentBlock:(XXShareTextViewDidTapOnCommentBlock)commentBlock;
- (void)setTapOnPraiseBlock:(XXShareTextViewDidTapOnPraiseBlock)praiseBlock;

+ (NSAttributedString*)buildAttributedStringWithSharePost:(XXSharePostModel*)sharePost forContentWidth:(CGFloat)width;

- (void)startAudioPlay;
- (void)endAudioPlay;
- (void)startLoadingAudio;
- (void)endLoadingAudio;

@end
