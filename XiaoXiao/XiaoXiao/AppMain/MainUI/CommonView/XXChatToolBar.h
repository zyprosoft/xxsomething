//
//  XXChatToolBar.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXCustomButton.h"
#import "XXEmojiChooseView.h"

typedef enum{
    
    XXChatToolBarDefault=0,
    XXChatToolBarComment,
    XXChatToolBarShare,
    
}XXChatToolBarType;

typedef enum {
    
    XXChatToolBarInputText = 0,
    XXChatToolBarInputAudio,
    
}XXChatToolBarInputModel;

typedef enum {
 
    XXChatToolBarStateText = 0,
    XXChatToolBarStateAudio,
    XXChatToolBarStateEmoji,
    XXChatToolBarStateImage,
    
}XXChatToolBarState;

typedef void (^XXChatToolBarDidChooseInputMode) (XXChatToolBarInputModel inputModel);
typedef void (^XXChatToolBarDidChooseImage) (void);
typedef void (^XXChatToolBarDidChooseEmoji) (BOOL isMoved);
typedef void (^XXChatToolBarDidRecord) (NSString *recordUrl,NSString* amrUrl,NSString *timeLength);
typedef void (^XXChatToolBarDidTapSend) (NSString *textContent);

@protocol XXChatToolBarDelegate <NSObject>
- (void)chatToolBarDidTapOnImageButton;
@end
@interface XXChatToolBar : UIView<UITextViewDelegate>
{
    UIImageView*_inputBackImageView;
    UITextView *_inputTextView;
    XXCustomButton *_emojiButton;
    XXCustomButton *_audioButton;
    XXCustomButton *_recordButton;
    XXCustomButton *_textButton;
    XXCustomButton *_imageButton;
    
    XXChatToolBarType _barType;
    XXChatToolBarState _state;
    BOOL              _isMoved;
    
    XXChatToolBarDidRecord _recordBlock;
    XXChatToolBarDidTapSend _sendBlock;
    
    XXChatToolBarDidChooseEmoji _emojiBlock;
    
    CGFloat        _controlHeight;
    XXEmojiChooseView *_emojiChooseView;
}
@property (nonatomic,weak)id<XXChatToolBarDelegate> delegate;
@property (nonatomic,strong)UITextView *inputTextView;

- (XXChatToolBarState)barState;
- (BOOL)movedState;
- (void)setBarState:(XXChatToolBarState)state;
- (void)setMoveState:(BOOL)state;

- (id)initWithFrame:(CGRect)frame forUse:(XXChatToolBarType)barType;

- (void)setChatToolBarDidRecord:(XXChatToolBarDidRecord)recordBlock;

- (void)setChatToolBarTapSend:(XXChatToolBarDidTapSend)sendBlock;

- (void)setChatToolBarEmoji:(XXChatToolBarDidChooseEmoji)emojiBlock;

- (void)reginFirstResponse;

- (void)clearContentText;


@end
