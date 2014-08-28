//
//  SharePostGuideViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharePostPhotoBox.h"
#import "XXCustomButton.h"
#import "XXAudioManager.h"
#import "XXBaseViewController.h"

typedef enum {
   
    SharePostTypeText = 0,
    SharePostTypeAudio,
    SharePostTypeImage,
    
}SharePostType;

@protocol SharePostGuideViewControllerDelegate <NSObject>

- (void)sharePostGuideViewControllerFinishPostNow;

@end
@interface SharePostGuideViewController :XXBaseViewController  <XXAudioManagerDelegate>
{
    SharePostPhotoBox *_photoBox;
    SharePostType      _currentPostType;

    UIButton          *_recordButton;
    UIButton          *_recordingButton;
    UIImageView       *_recordBackImageView;
    UIImageView       *_playingAudioImgView;
    UIImageView       *_recordingImageView;
    UIButton          *_playRecordButton;
    UIButton          *_reRecordButton;
    UILabel           *_recordTimeLabel;

    XXCustomButton    *_useRecordButton;
    XXCustomButton    *_useTextButton;
    UITextView        *_textInputView;
    UIImageView       *_inputBackImgView;
    BOOL               _isGuideState;
    
    NSInteger          _currentSelectPhotoCount;
    NSMutableArray    *_postImagesArray;
    XXSharePostModel  *_currentPostModel;
    NSString          *_recordWavPath;
    NSString          *_recordAmrPath;
    BOOL               _hasRecordNow;
    
    //
    UIImageView       *_typeChooseBackImageView;
    XXCustomButton    *_recordChooseButton;
    XXCustomButton    *_textChooseButton;
    
    BOOL               _isPosting;
    
}
@property (nonatomic,weak)id<SharePostGuideViewControllerDelegate> delegate;

- (id)initWithSharePostType:(SharePostType)aType;

@end
