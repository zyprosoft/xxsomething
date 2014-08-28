//
//  XXChatToolBar.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXChatToolBar.h"
#import "UIButton+XXStyle.h"

static inline UIViewAnimationOptions AnimationOptionsForCurve(UIViewAnimationCurve curve)
{
	return (curve << 16 | UIViewAnimationOptionBeginFromCurrentState);
}

@implementation XXChatToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame forUse:(XXChatToolBarType)barType
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        _barType = barType;
        _controlHeight = 35;
        
        _textButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
        _textButton.frame = CGRectMake(6,6,37,37);
        [_textButton defaultStyle];
        _textButton.layer.borderWidth = 2.f;
        [_textButton setNormalIconImage:@"chat_bar_text.png" withSelectedImage:@"chat_bar_text.png" withFrame:CGRectMake(6,10,25,17)];
        [_textButton addTarget:self action:@selector(switchInputMode:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_textButton];
        
        _audioButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
        _audioButton.frame = _textButton.frame;
        [_audioButton defaultStyle];
        _audioButton.layer.borderWidth = 2.f;
        [_audioButton addTarget:self action:@selector(switchInputMode:) forControlEvents:UIControlEventTouchUpInside];
        [_audioButton setNormalIconImage:@"chat_bar_audio.png" withSelectedImage:@"chat_bar_audio.png" withFrame:CGRectMake(8,5,20.5,27)];
        [self addSubview:_audioButton];
        
        _recordButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
        _recordButton.frame = CGRectMake(46,6, 187, 37);
        [_recordButton defaultStyle];
        _recordButton.layer.borderWidth = 2.0f;
        _recordButton.layer.cornerRadius = 4.0f;
        [_recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
        [_recordButton setTitle:@"松开结束" forState:UIControlStateSelected];
        [_recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_recordButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(endRecord) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_recordButton];
        _recordButton.hidden = YES;
        
        //input text view
        _inputBackImageView = [[UIImageView alloc]init];
        _inputBackImageView.frame = CGRectMake(46,6,187,37);
        _inputBackImageView.backgroundColor = [UIColor whiteColor];
        _inputBackImageView.layer.borderColor = [XXCommonStyle xxThemeButtonBoardColor].CGColor;
        _inputBackImageView.layer.borderWidth = 2.f;
        _inputBackImageView.layer.cornerRadius = 4.0f;
        [self addSubview:_inputBackImageView];
        
        //input text
        _inputTextView = [[UITextView alloc]init];
        _inputTextView.frame = CGRectMake(46,10,187,31);
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.font = [UIFont systemFontOfSize:12.5];
        _inputTextView.delegate = self;
        _inputTextView.backgroundColor = [UIColor clearColor];
        [self addSubview:_inputTextView];
        
        //emoji
        _emojiButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
        _emojiButton.frame = CGRectMake(236,6,37,37);
        [_emojiButton defaultStyle];
        _emojiButton.layer.borderWidth = 2.0f;
        [_emojiButton setNormalIconImage:@"chat_bar_emoji.png" withSelectedImage:@"chat_bar_emoji.png" withFrame:CGRectMake(7.25,7.25,22.5,22.5)];
        [_emojiButton setBackgroundImage:[_emojiButton buttonImageFromColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]] forState:UIControlStateSelected];
        
        [_emojiButton addTarget:self action:@selector(tapOnEmoji) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_emojiButton];
        
        //image
        _imageButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
        _imageButton.frame = CGRectMake(276, 6, 37, 37);
        [_imageButton defaultStyle];
        _imageButton.layer.borderWidth = 2.0f;
        [_imageButton setNormalIconImage:@"chat_bar_image.png" withSelectedImage:@"chat_bar_image.png" withFrame:CGRectMake(7.5,9.5,22,18)];
        [_imageButton addTarget:self action:@selector(tapOnImageButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imageButton];
        
        //emoji choose view
        _emojiChooseView = [[XXEmojiChooseView alloc]initWithFrame:CGRectMake(0,_controlHeight,frame.size.width,216)];
        WeakObj(_inputTextView) weakInput = _inputTextView;
        [_emojiChooseView setEmojiViewDidSelectBlock:^(NSString *emoji) {
            NSString *oldString = weakInput.text;
            weakInput.text = [NSString stringWithFormat:@"%@[%@]",oldString,emoji];
        }];
        [self addSubview:_emojiChooseView];
        
        [self adjustFrameForCurrentType];
        
        //self observe keyborad
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
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
- (XXChatToolBarState)barState
{
    return _state;
}
- (void)setBarState:(XXChatToolBarState)state
{
    _state = state;
}
- (void)setMoveState:(BOOL)state
{
    _isMoved = state;
}
- (BOOL)movedState
{
    return _isMoved;
}
- (void)tapOnEmoji
{
    
    if (_state==XXChatToolBarStateAudio) {
        
        [self switchInputMode:_textButton];
        [_inputTextView resignFirstResponder];
        _state = XXChatToolBarStateEmoji;
        _isMoved = NO;
        
        [self animationShowEmojiPanel];
        
        if (_emojiBlock) {
            _emojiBlock(_isMoved);
        }
        _emojiButton.selected = YES;
        
    }else if(_state==XXChatToolBarStateText) {
        [self switchInputMode:_textButton];
        [_inputTextView resignFirstResponder];
        _isMoved = NO;
        _state = XXChatToolBarStateEmoji;
        
        [self animationShowEmojiPanel];
        
        if (_emojiBlock) {
            _emojiBlock(_isMoved);
        }
        _emojiButton.selected = YES;

    }else if (_state==XXChatToolBarStateEmoji){
        
        [_inputTextView becomeFirstResponder];
        _state = XXChatToolBarStateText;
        _emojiButton.selected = NO;

    }

}
- (void)setChatToolBarEmoji:(XXChatToolBarDidChooseEmoji)emojiBlock
{
    _emojiBlock = [emojiBlock copy];
}

- (void)switchInputMode:(UIButton*)sender
{
    if (sender == _textButton) {
        _inputBackImageView.hidden = NO;
        _inputTextView.hidden = NO;
        _recordButton.hidden = YES;
        _textButton.hidden = YES;
        _audioButton.hidden = NO;
        _state = XXChatToolBarStateText;
        [_inputTextView becomeFirstResponder];
        _isMoved = YES;
        
    }
    if (sender == _audioButton) {
        _inputBackImageView.hidden = YES;
        _inputTextView.hidden = YES;
        [_inputTextView resignFirstResponder];
        _recordButton.hidden = NO;
        _textButton.hidden = NO;
        _audioButton.hidden = YES;
        _state = XXChatToolBarStateAudio;
        _isMoved = NO;
        
    }
    _emojiButton.selected = NO;
    
}

- (void)adjustFrameForCurrentType
{
    switch (_barType) {
        case XXChatToolBarShare:
        {
            
        }
            break;
        case XXChatToolBarDefault:
        {
            
        }
            break;
        case XXChatToolBarComment:
        {
            _imageButton.hidden = YES;
            CGRect oldInputRect = _inputBackImageView.frame;
            CGRect oldInpuTextRect = _inputTextView.frame;
            CGRect oldEmojiButtonRect = _emojiButton.frame;
            
            _inputBackImageView.frame = CGRectMake(_inputBackImageView.frame.origin.x,oldInputRect.origin.y,_inputBackImageView.frame.size.width+44,_inputBackImageView.frame.size.height);
            
            _inputTextView.frame = CGRectMake(_inputTextView.frame.origin.x,oldInpuTextRect.origin.y,_inputTextView.frame.size.width+40,_inputTextView.frame.size.height);
            _recordButton.frame = _inputBackImageView.frame;
            
            _emojiButton.frame = CGRectMake(_emojiButton.frame.origin.x+44,oldEmojiButtonRect.origin.y,_emojiButton.frame.size.width,_emojiButton.frame.size.height);
        }
            break;
        default:
            break;
    }
}

#pragma mark - record
- (void)startRecord
{
    [[XXAudioManager shareManager]audioManagerStartRecordWithFinishRecordAction:^(NSString *audioSavePath, NSString *wavSavePath, NSString *timeLength) {
        
        if(_recordBlock){
            _recordBlock(wavSavePath,audioSavePath,timeLength);
        }
        
    }];
}
- (void)endRecord
{
    [[XXAudioManager shareManager]audioManagerEndRecord];
}
- (void)setChatToolBarDidRecord:(XXChatToolBarDidRecord)recordBlock
{
    _recordBlock = [recordBlock copy];
}
- (void)setChatToolBarTapSend:(XXChatToolBarDidTapSend)sendBlock
{
    _sendBlock = [sendBlock copy];
}

- (void)reginFirstResponse
{
    [_inputTextView resignFirstResponder];
}
#pragma mark - textView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_state==XXChatToolBarStateEmoji) {
        _emojiButton.selected = !_emojiButton.selected;
    }
    _state = XXChatToolBarStateText;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        if (_barType != XXChatToolBarDefault) {
            [textView resignFirstResponder];
        }
        if (_sendBlock) {
            _sendBlock(_inputTextView.text);
            _inputTextView.text = @"";
        }
        return NO;
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
}

#pragma mark - keyboard noti
- (void)animationShowEmojiPanel
{
    if (!_isMoved) {
        [UIView animateWithDuration:0.3
                              delay:0.0f
                            options:UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             CGRect selfFrame = self.frame;
                             selfFrame.origin.y = selfFrame.origin.y-216;
                             self.frame = selfFrame;
                             _isMoved = YES;
                         }
                         completion:nil];
    }
    
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGRect keyboardEndFrameWindow = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double keyboardTransitionDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve keyboardTransitionAnimationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect keyboardEndFrameView = [self convertRect:keyboardEndFrameWindow fromView:nil];
    
    [UIView animateWithDuration:keyboardTransitionDuration
                          delay:0.0f
                        options:AnimationOptionsForCurve(keyboardTransitionAnimationCurve)
                     animations:^{
                         
                         if (!_isMoved) {
                             CGRect toolBarFrame = self.frame;
                             toolBarFrame.origin.y = keyboardEndFrameView.origin.y - 49;
                             self.frame = toolBarFrame;
                         }
                     }
                     completion:nil];
}
- (void)keyboardDidShow
{

}
- (void)keyboardWillHidden:(NSNotification*)notification
{
    CGRect keyboardEndFrameWindow = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double keyboardTransitionDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve keyboardTransitionAnimationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect keyboardEndFrameView = [self convertRect:keyboardEndFrameWindow fromView:nil];
    
    [UIView animateWithDuration:keyboardTransitionDuration
                          delay:0.0f
                        options:AnimationOptionsForCurve(keyboardTransitionAnimationCurve)
                     animations:^{
                         
                         if (_state!=XXChatToolBarStateEmoji) {
                             
                             CGRect toolBarFrame = self.frame;
                             toolBarFrame.origin.y = keyboardEndFrameView.origin.y - 49;
                             self.frame = toolBarFrame;
                             
                         }
                         
                     }
                     completion:nil];
}
- (void)keyboardDidHidden
{
    
}
- (void)keyboardWillChangeFrame:(NSNotification*)notification
{
    CGRect keyboardEndFrameWindow = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double keyboardTransitionDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve keyboardTransitionAnimationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect keyboardEndFrameView = [self convertRect:keyboardEndFrameWindow fromView:nil];
    
    [UIView animateWithDuration:keyboardTransitionDuration
                          delay:0.0f
                        options:AnimationOptionsForCurve(keyboardTransitionAnimationCurve)
                     animations:^{
                         CGRect toolBarFrame = self.frame;
                         toolBarFrame.origin.y = keyboardEndFrameView.origin.y - 49;
                         self.frame = toolBarFrame;
                     }
                     completion:nil];
}
- (void)keyboardDidChange:(NSNotification*)noti
{
    
}

- (void)clearContentText
{
    _inputTextView.text = @"";
}

- (void)tapOnImageButton
{
    if ([self.delegate respondsToSelector:@selector(chatToolBarDidTapOnImageButton)]) {
        [self.delegate chatToolBarDidTapOnImageButton];
    }
}

@end
