//
//  SharePostGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "SharePostGuideViewController.h"
#import "XXPhotoChooseViewController.h"
#import "XXPhotoReviewViewController.h"

@interface SharePostGuideViewController ()

@end

@implementation SharePostGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithSharePostType:(SharePostType)aType
{
    if (self = [super init]) {
        
        _currentPostType = aType;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"发说说";
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    
    CGFloat totalHeight = XXNavContentHeight-44;
    CGFloat totalWidth = self.view.frame.size.width;
    
    _postImagesArray = [[NSMutableArray alloc]init];
    _currentPostModel = [[XXSharePostModel alloc]init];
    _currentPostType = SharePostTypeText;
    _hasRecordNow = NO;
    
    //
    _photoBox = [[SharePostPhotoBox alloc]initWithFrame:CGRectMake(10,10,300,65)];
    _photoBox.layer.cornerRadius = 8.f;
    _photoBox.layer.borderWidth = 2.f;
    _photoBox.layer.borderColor = rgb(217, 217, 217, 1).CGColor;
    [self.view addSubview:_photoBox];
    
    //
    _useRecordButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    _useRecordButton.frame = CGRectMake(15,totalHeight-47-12,290,40);
    [_useRecordButton defaultStyle];
    
    [_useRecordButton setTitle:@"用录音描述" forState:UIControlStateNormal];
    [_useRecordButton setNormalIconImage:@"audio_type.png" withSelectedImage:@"audio_type.png" withFrame:CGRectMake(100,11,13.5,18)];
    [_useRecordButton setTitleEdgeInsets:UIEdgeInsetsMake(0,30,0,0)];
    [_useRecordButton setBackgroundImage:[UIImage imageNamed:@"input_box.png"] forState:UIControlStateNormal];
    [_useRecordButton addTarget:self action:@selector(changeSharePostType:) forControlEvents:UIControlEventTouchUpInside];
    _useRecordButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_useRecordButton setTitleColor:[XXCommonStyle xxThemeButtonGrayTitleColor] forState:UIControlStateNormal];
    [self.view addSubview:_useRecordButton];
    _useRecordButton.hidden = YES;
    
    //
    _useTextButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    _useTextButton.frame = CGRectMake(15,totalHeight-47-12,290,40);
    [_useTextButton defaultStyle];
    [_useTextButton setBackgroundImage:[UIImage imageNamed:@"input_box.png"] forState:UIControlStateNormal];
    [_useTextButton setNormalIconImage:@"text_type.png" withSelectedImage:@"text_type.png" withFrame:CGRectMake(100, 11.5,17,17)];
    [_useTextButton setTitleEdgeInsets:UIEdgeInsetsMake(0,30,0,0)];
    _useTextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_useTextButton setTitle:@"用文字描述" forState:UIControlStateNormal];
    [_useTextButton setTitleColor:[XXCommonStyle xxThemeButtonGrayTitleColor] forState:UIControlStateNormal];
    [_useTextButton addTarget:self action:@selector(changeSharePostType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_useTextButton];
    _useTextButton.hidden = YES;
    
    //
    _textInputView = [[UITextView alloc]init];
    _textInputView.frame = CGRectMake(13,98,274,54);
    _textInputView.font = [UIFont systemFontOfSize:12.5];
    _inputBackImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10,94,300,60)];
    _inputBackImgView.image = [[UIImage imageNamed:@"input_box.png"]makeStretchForSingleCornerCell];
    [self.view addSubview:_inputBackImgView];
    
    [self.view addSubview:_textInputView];
    _inputBackImgView.hidden = YES;
    _textInputView.hidden = YES;
    
    //record button
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordButton.frame = CGRectMake((totalWidth-112)/2,_photoBox.frame.origin.y+_photoBox.frame.size.height+115, 112, 112);
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"record_audio_normal.png"] forState:UIControlStateNormal];
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"record_audio_selected.png"]  forState:UIControlStateHighlighted];
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"record_audio_selected.png"] forState:UIControlStateSelected];
    [_recordButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(endRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordButton];
    _recordButton.hidden = YES;
    
    //_recording image view
    _recordingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(85,95,150,100)];
    _recordingImageView.image = [UIImage animatedImageWithAnimatedGIFData:[XXFileUitil loadDataFromBundleForName:@"recording.gif"]];
    [self.view addSubview:_recordingImageView];
    _recordingImageView.hidden = YES;
    
    //record play
    _recordBackImageView = [[UIImageView alloc]init];
    _recordBackImageView.frame = CGRectMake(85,_photoBox.frame.origin.y+_photoBox.frame.size.height+80,152,104);
    _recordBackImageView.image = [UIImage imageNamed:@"audio_finish_back.png"];
    _recordBackImageView.userInteractionEnabled = YES;
    [self.view addSubview:_recordBackImageView];
    if (_hasRecordNow&&_currentPostType==SharePostTypeAudio) {
        _recordBackImageView.hidden = NO;
    }else{
        _recordBackImageView.hidden = YES;
    }
    
    //play button
    _playRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playRecordButton.frame = CGRectMake(42,40,20,20);
    [_playRecordButton setBackgroundImage:[UIImage imageNamed:@"audio_play_stop.png"] forState:UIControlStateNormal];
    [_playRecordButton addTarget:self action:@selector(playRecord) forControlEvents:UIControlEventTouchUpInside];
    [_recordBackImageView addSubview:_playRecordButton];
    
    //playing audio button
    _playingAudioImgView = [[UIImageView alloc]init];
    _playingAudioImgView.frame = CGRectMake(42,40,12,20);
    _playingAudioImgView.image = [UIImage animatedImageWithAnimatedGIFData:[XXFileUitil loadDataFromBundleForName:@"audio_playing.gif"]];
    [_recordBackImageView addSubview:_playingAudioImgView];
    _playingAudioImgView.hidden = YES;
    
    //re record
    _reRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reRecordButton setTitle:@"重录" forState:UIControlStateNormal];
    [_reRecordButton addTarget:self action:@selector(restartRecord) forControlEvents:UIControlEventTouchUpInside];
    [_reRecordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _reRecordButton.frame = CGRectMake(102,33,35,35);
    _reRecordButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_recordBackImageView addSubview:_reRecordButton];
    
    //time Label
    _recordTimeLabel = [[UILabel alloc]init];
    _recordTimeLabel.frame = CGRectMake(50,65,20,20);
    _recordTimeLabel.backgroundColor = [UIColor clearColor];
    _recordTimeLabel.textColor = [XXCommonStyle xxThemeButtonGrayTitleColor];
    [_recordBackImageView addSubview:_recordTimeLabel];
    _recordBackImageView.hidden = YES;
    
    //
    [self configPhotoBoxAction];
    
    //
    [self initGuideButtons];
    
    //
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withNextStepAction:^{
        [self sharePostNow];
    } withTitle:@"发表"];
    
    //set audio delegate
    [[XXAudioManager shareManager]setDelegate:self];
}


//add guid
- (void)initGuideButtons
{
#define GuidButtonTag 445566
    
    //
    XXCustomButton *textButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    textButton.frame = CGRectMake(10,_photoBox.frame.origin.y+_photoBox.frame.size.height+30,150,47);
    [textButton setBackgroundImage:[UIImage imageNamed:@"segment_big_left.png"] forState:UIControlStateNormal];
    [textButton setNormalIconImage:@"text_type.png" withSelectedImage:@"text_type.png" withFrame:CGRectMake(40,15,17,17)];
    [textButton setTitle:@"文字描述" forState:UIControlStateNormal];
    textButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [textButton setTitleEdgeInsets:UIEdgeInsetsMake(0,30,0,0)];
    [textButton setTitleColor:[XXCommonStyle xxThemeButtonGrayTitleColor] forState:UIControlStateNormal];
    [textButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [textButton addTarget:self action:@selector(showTextEditType) forControlEvents:UIControlEventTouchUpInside];
    textButton.tag = GuidButtonTag;
    [self.view addSubview:textButton];
    
    //
    XXCustomButton *audioButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    audioButton.frame = CGRectMake(160,textButton.frame.origin.y,150,47);
    [audioButton setBackgroundImage:[UIImage imageNamed:@"segment_big_right.png"] forState:UIControlStateNormal];
    [audioButton setNormalIconImage:@"audio_type.png" withSelectedImage:@"audio_type.png" withFrame:CGRectMake(33,14,13.5,18)];
    [audioButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
    [audioButton setTitle:@"直接说" forState:UIControlStateNormal];
    [audioButton setTitleColor:[XXCommonStyle xxThemeButtonGrayTitleColor] forState:UIControlStateNormal];
    [audioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    audioButton.tag = GuidButtonTag+1;
    audioButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [audioButton addTarget:self action:@selector(showAudioEditType) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:audioButton];
    
    //seprator
    UIImageView *middleSepLine = [[UIImageView alloc]init];
    middleSepLine.frame = CGRectMake(self.view.frame.size.width/2-1,audioButton.frame.origin.y+1,1,45);
    middleSepLine.backgroundColor = [XXCommonStyle xxThemeGrayTitleColor];
    middleSepLine.tag = GuidButtonTag+2;
    [self.view addSubview:middleSepLine];
    
    _isGuideState = YES;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    if (!CGRectContainsPoint(_inputBackImgView.frame,point) && !CGRectContainsPoint(_photoBox.frame,point)) {
        
        if ([_textInputView isFirstResponder]) {
            [_textInputView resignFirstResponder];
        }
    }
    
}


- (void)showTextEditType
{
    _currentPostType = SharePostTypeText;
    _useRecordButton.hidden = NO;
    _useTextButton.hidden = YES;
    
    _textInputView.hidden = NO;
    [_textInputView becomeFirstResponder];
    _inputBackImgView.hidden = NO;
    
    _recordButton.hidden = YES;
    _recordBackImageView.hidden = YES;
    
    [[self.view viewWithTag:GuidButtonTag]removeFromSuperview];
    [[self.view viewWithTag:GuidButtonTag+1]removeFromSuperview];
    [[self.view viewWithTag:GuidButtonTag+2]removeFromSuperview];
    
    _isGuideState = NO;
}
- (void)showAudioEditType
{
    _currentPostType = SharePostTypeAudio;
    _useRecordButton.hidden = YES;
    _useTextButton.hidden = NO;
    
    _textInputView.hidden = YES;
    _inputBackImgView.hidden = YES;
    
    _recordButton.hidden = NO;
    
    [[self.view viewWithTag:GuidButtonTag]removeFromSuperview];
    [[self.view viewWithTag:GuidButtonTag+1]removeFromSuperview];
    [[self.view viewWithTag:GuidButtonTag+2]removeFromSuperview];
    
    _isGuideState = NO;

}

- (void)dealloc
{
    [[XXAudioManager shareManager]setDelegate:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[XXCommonUitil appMainTabController] setTabBarHidden:YES];
    CGRect naviRect = self.navigationController.view.frame;
    self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height+49);
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[XXAudioManager shareManager] audioManagerEndPlayNow];
    [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
    CGRect naviRect = self.navigationController.view.frame;
    self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height-49);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configPhotoBoxAction
{
    __block NSInteger needPhotoCount = 6-_currentSelectPhotoCount;
    XXPhotoChooseViewControllerFinishChooseBlock finishBlock = ^ (NSArray *resultImages){
        _currentSelectPhotoCount = _currentSelectPhotoCount+resultImages.count;
        needPhotoCount = 6-_currentSelectPhotoCount;
        [_postImagesArray addObjectsFromArray:resultImages];
        [_photoBox setImagesArray:_postImagesArray];
    };
    SharePhotoBoxDidTapOnAddBlock addBlock = ^{
        XXPhotoChooseViewController *chooseVC = [[XXPhotoChooseViewController alloc]initWithMutilPhotoChooseWithMaxChooseNumber:needPhotoCount  withFinishBlock:^(NSArray *resultImages) {
            finishBlock(resultImages);
        }];
        chooseVC.title = @"选择图片";
        [self.navigationController pushViewController:chooseVC animated:YES];
        [XXCommonUitil setCommonNavigationReturnItemForViewController:chooseVC];
    };
    [_photoBox setSharePhotoBoxAddNewBlock:^{
        addBlock();
    }];
    SharePhotoBoxDidChangeFrameBlock changeBlock = ^(CGRect newFrame){
        _photoBox.frame = newFrame;
        if (_isGuideState) {
            
            UIView *leftGuideBtn = [self.view viewWithTag:GuidButtonTag];
            UIView *rightGuideBtn= [self.view viewWithTag:GuidButtonTag+1];
            UIView *guideLine = [self.view viewWithTag:GuidButtonTag+2];
            
            leftGuideBtn.frame = CGRectMake(leftGuideBtn.frame.origin.x,_photoBox.frame.origin.y+_photoBox.frame.size.height+15,leftGuideBtn.frame.size.width,leftGuideBtn.frame.size.height);
            
            rightGuideBtn.frame = CGRectMake(rightGuideBtn.frame.origin.x,_photoBox.frame.origin.y+_photoBox.frame.size.height+15,rightGuideBtn.frame.size.width,rightGuideBtn.frame.size.height);
            guideLine.frame = CGRectMake(guideLine.frame.origin.x,_photoBox.frame.origin.y+_photoBox.frame.size.height+15,guideLine.frame.size.width,guideLine.frame.size.height);
            
            _textInputView.frame = CGRectMake(_textInputView.frame.origin.x,_photoBox.frame.origin.y+_photoBox.frame.size.height+15,_textInputView.frame.size.width,_textInputView.frame.size.height);
            _inputBackImgView.frame = CGRectMake(_inputBackImgView.frame.origin.x,_photoBox.frame.origin.y+_photoBox.frame.size.height+13,_inputBackImgView.frame.size.width,_inputBackImgView.frame.size.height);
        }else{
            if(_currentPostType==SharePostTypeText){
                _textInputView.frame = CGRectMake(_textInputView.frame.origin.x,_photoBox.frame.origin.y+_photoBox.frame.size.height+15,_textInputView.frame.size.width,_textInputView.frame.size.height);
            }else if(_currentPostType==SharePostTypeAudio){
                
            }
        }
        
    };
    [_photoBox setSharePhotoboxDidChangeFrameBlock:^(CGRect newFrame) {
        changeBlock(newFrame);
    }];
    SharePhotoBoxDidTapToReviewPhotoBlock reviewBlock = ^(NSInteger currentPhotoIndex){
        if (_postImagesArray.count==0) {
            return ;
        }
        XXPhotoReviewViewController *reviewController = [[XXPhotoReviewViewController alloc]initWithImagesArray:_postImagesArray withStartIndex:currentPhotoIndex];
        [reviewController setFinishReview:^(NSArray *resultImages) {
            [_photoBox setImagesArray:resultImages];
            [_postImagesArray removeAllObjects];
            [_postImagesArray addObjectsFromArray:resultImages];
        }];
        [self.navigationController pushViewController:reviewController animated:YES];
    };
    [_photoBox setSharePhotoBoxReviewPhotoBlock:^(NSInteger currentPhotoIndex) {
        reviewBlock(currentPhotoIndex);
    }];
}

- (void)restartRecord
{
    _recordButton.hidden = NO;
    _recordBackImageView.hidden = YES;
    _hasRecordNow = NO;
}

- (void)startRecord
{
    _hasRecordNow = NO;
    _textInputView.hidden = !_recordButton.hidden;
    _recordingImageView.hidden = NO;
    
    [[XXAudioManager shareManager]audioManagerStartRecordWithFinishRecordAction:^(NSString *audioSavePath, NSString *wavSavePath,NSString *timeLength) {
        _hasRecordNow = YES;
        _recordTimeLabel.text = timeLength;
        _recordAmrPath = audioSavePath;
        _recordWavPath = wavSavePath;
        _currentPostModel.postAudioTime = timeLength;
        _recordButton.hidden = YES;
        _recordBackImageView.hidden = !_recordButton;
    }];
}
- (void)endRecord
{
    _recordingImageView.hidden = YES;
    [[XXAudioManager shareManager]audioManagerEndRecord];
    [XXSimpleAudio playRefreshEffect];
}

- (void)playRecord
{
    DDLogVerbose(@"play record!");
    _playRecordButton.selected = YES;
    [[XXAudioManager shareManager]audioManagerPlayLocalWavWithPath:_recordWavPath];
}

- (void)changeSharePostType:(UIButton*)sender
{
    if (sender == _useTextButton) {
        
        _useTextButton.hidden = YES;
        _useRecordButton.hidden = NO;
        
        _currentPostType = SharePostTypeText;
        _textInputView.hidden = NO;
        _inputBackImgView.hidden = _textInputView.hidden;
        _recordButton.hidden = !_textInputView.hidden;
        _recordBackImageView.hidden = !_textInputView.hidden;
    }
    
    if (sender == _useRecordButton) {
        
        _useRecordButton.hidden = YES;
        _useTextButton.hidden  = NO;
        
        _currentPostType = SharePostTypeAudio;
        if (_hasRecordNow) {
            _recordBackImageView.hidden = NO;
            _recordButton.hidden = YES;
            _textInputView.hidden = YES;
            _inputBackImgView.hidden = _textInputView.hidden;

        }else{
            _recordButton.hidden = NO;
            _textInputView.hidden = YES;
            _inputBackImgView.hidden = _textInputView.hidden;

        }
        
    }
    
}

// share post now
- (void)sharePostNow
{
    DDLogVerbose(@"current Login user token:%@",[XXUserDataCenter currentLoginUserToken]);
    
    if (_isPosting) {
        return;
    }
    
    //only audio or text
    if (_postImagesArray.count==0) {
        
        _hud.labelText = @"正在发表...";
        [self.view bringSubviewToFront:_hud];
        _isPosting = YES;
        [_hud show:YES];
        
        //start upload audio if need or start post
        if (_currentPostType == SharePostTypeAudio) {
            
            _currentPostModel.postType = [XXSharePostTypeConfig postTypeWithImageCount:0 withIsAudioContent:YES];
            _currentPostModel.postAudioTime = _recordTimeLabel.text;
            
            //
            DDLogVerbose(@"record amr path:%@",_recordAmrPath);
            NSData *audioData = [NSData dataWithContentsOfFile:_recordAmrPath];
            DDLogVerbose(@"arm upload size :%d",audioData.length);
            [[XXMainDataCenter shareCenter]uploadFileWithData:audioData withFileName:@"audio.amr" withUploadProgressBlock:^(CGFloat progressValue) {
//                [SVProgressHUD showProgress:progressValue status:@"上传语音"];
            } withSuccessBlock:^(XXAttachmentModel *resultModel) {
                
                //upload audio success,begin share
                _currentPostModel.postAudio = resultModel.link;
                [[XXMainDataCenter shareCenter]requestPostShareWithConditionSharePost:_currentPostModel withSuccess:^(NSString *successMsg) {
                    [_hud setHidden:YES];
                    _isPosting = NO;
                    [SVProgressHUD showSuccessWithStatus:@"发表成功"];
                    if ([self.delegate respondsToSelector:@selector(sharePostGuideViewControllerFinishPostNow)]) {
                        [self.delegate sharePostGuideViewControllerFinishPostNow];
                    }
                } withFaild:^(NSString *faildMsg) {
                    [_hud setHidden:YES];
                    _isPosting = NO;
                    [SVProgressHUD showErrorWithStatus:faildMsg];
                }];
                
            } withFaildBlock:^(NSString *faildMsg) {
                [_hud setHidden:YES];
                _isPosting = NO;
                [SVProgressHUD showErrorWithStatus:faildMsg];
            }];
            
        }else{
            _currentPostModel.postAudio = @"";
            _currentPostModel.postContent = _textInputView.text;
            _currentPostModel.postAudioTime = @"0";
            _currentPostModel.postType = [XXSharePostTypeConfig postTypeWithImageCount:0 withIsAudioContent:NO];
            [[XXMainDataCenter shareCenter]requestPostShareWithConditionSharePost:_currentPostModel withSuccess:^(NSString *successMsg) {
                [_hud setHidden:YES];
                _isPosting = NO;

                [SVProgressHUD showSuccessWithStatus:@"发表成功"];
                if ([self.delegate respondsToSelector:@selector(sharePostGuideViewControllerFinishPostNow)]) {
                    [self.delegate sharePostGuideViewControllerFinishPostNow];
                }
            } withFaild:^(NSString *faildMsg) {
                [_hud setHidden:YES];
                _isPosting = NO;
                [SVProgressHUD showErrorWithStatus:faildMsg];
            }];
        }
        return;
    }

    
    _hud.labelText = @"正在发表...";
    _isPosting = YES;
    [self.view bringSubviewToFront:_hud];
    [_hud show:YES];
    
    //upload image or audio
    __block NSMutableArray *resultImageLinks = [NSMutableArray array];
    [_postImagesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        NSData *imageData = UIImageJPEGRepresentation(obj,kCGInterpolationHigh);
        [[XXMainDataCenter shareCenter]uploadFileWithData:imageData withFileName:@"content.jpg" withUploadProgressBlock:^(CGFloat progressValue) {
            
        } withSuccessBlock:^(XXAttachmentModel *resultModel) {
            
            [resultImageLinks addObject:resultModel.link];
            
            NSMutableString *postAllImages = [NSMutableString string];
            [resultImageLinks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if (idx!=resultImageLinks.count-1) {
                    [postAllImages appendFormat:@"%@|",obj];
                }else{
                    [postAllImages appendFormat:@"%@",obj];
                }
            }];
            DDLogVerbose(@"post all images:%@",postAllImages);
            _currentPostModel.postImages = postAllImages;

            //all image upload finish
            if (resultImageLinks.count == _postImagesArray.count) {
                
                //start upload audio if need or start post
                if (_currentPostType == SharePostTypeAudio) {
                    
                    _currentPostModel.postType = [XXSharePostTypeConfig postTypeWithImageCount:resultImageLinks.count withIsAudioContent:YES];
                    _currentPostModel.postAudioTime = _recordTimeLabel.text;
                    
                    //
                    DDLogVerbose(@"record amr path:%@",_recordAmrPath);
                    NSData *audioData = [NSData dataWithContentsOfFile:_recordAmrPath];
                    DDLogVerbose(@"arm upload size :%d",audioData.length);
                    [[XXMainDataCenter shareCenter]uploadFileWithData:audioData withFileName:@"audio.amr" withUploadProgressBlock:^(CGFloat progressValue) {
//                        [SVProgressHUD showProgress:progressValue status:@"上传语音"];
                    } withSuccessBlock:^(XXAttachmentModel *resultModel) {
                       
                        //upload audio success,begin share
                        _currentPostModel.postAudio = resultModel.link;
                        [[XXMainDataCenter shareCenter]requestPostShareWithConditionSharePost:_currentPostModel withSuccess:^(NSString *successMsg) {
                            [_hud setHidden:YES];
                            _isPosting = NO;
                            [SVProgressHUD showSuccessWithStatus:@"发表成功"];
                            if ([self.delegate respondsToSelector:@selector(sharePostGuideViewControllerFinishPostNow)]) {
                                [self.delegate sharePostGuideViewControllerFinishPostNow];
                            }
                        } withFaild:^(NSString *faildMsg) {
                            [_hud setHidden:YES];
                            _isPosting = NO;
                            [SVProgressHUD showErrorWithStatus:faildMsg];
                        }];
                        
                    } withFaildBlock:^(NSString *faildMsg) {
                        [_hud setHidden:YES];
                        _isPosting = NO;
                        [SVProgressHUD showErrorWithStatus:faildMsg];
                    }];
                    
                }else{
                    _currentPostModel.postAudio = @"";
                    _currentPostModel.postContent = _textInputView.text;
                    _currentPostModel.postAudioTime = @"0";
                    _currentPostModel.postType = [XXSharePostTypeConfig postTypeWithImageCount:resultImageLinks.count withIsAudioContent:NO];
                    [[XXMainDataCenter shareCenter]requestPostShareWithConditionSharePost:_currentPostModel withSuccess:^(NSString *successMsg) {
                        [_hud setHidden:YES];
                        _isPosting = NO;
                        [SVProgressHUD showSuccessWithStatus:@"发表成功"];
                        if ([self.delegate respondsToSelector:@selector(sharePostGuideViewControllerFinishPostNow)]) {
                            [self.delegate sharePostGuideViewControllerFinishPostNow];
                        }
                    } withFaild:^(NSString *faildMsg) {
                        [_hud setHidden:YES];
                        _isPosting = NO;
                        [SVProgressHUD showErrorWithStatus:faildMsg];
                    }];
                }
            }
            
        } withFaildBlock:^(NSString *faildMsg) {
            [_hud setHidden:YES];
            _isPosting = NO;
            [SVProgressHUD showErrorWithStatus:faildMsg];
        }];
        
    }];
    
    
    
}

#pragma mark
- (void)audioManagerDidStartPlay
{
    _playRecordButton.hidden = YES;
    _playingAudioImgView.hidden = NO;
}
- (void)audioManagerDidEndPlay
{
    _playingAudioImgView.hidden = YES;
    _playRecordButton.hidden = NO;
}
- (void)audioManagerDidCancelPlay
{
    _playingAudioImgView.hidden = YES;
    _playRecordButton.hidden = NO;
}


@end
