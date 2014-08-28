//
//  XXShareDetailViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-9.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXShareDetailViewController.h"
#import "OtherUserHomeViewController.h"
#import "XXLoadMoreCell.h"


@interface XXShareDetailViewController ()

@end

@implementation XXShareDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSharePost:(XXSharePostModel *)aSharePost
{
    if (self = [super init]) {
        
        //
        self.commentModelArray = [[NSMutableArray alloc]init];
        self.commentRowHeightArray = [[NSMutableArray alloc]init];
        
        [self.commentModelArray addObject:aSharePost];
        CGFloat postHeight = [XXShareBaseCell heightWithSharePostModelForDetail:aSharePost forContentWidth:[XXSharePostStyle sharePostContentWidth]];
        [self.commentRowHeightArray addObject:[NSNumber numberWithFloat:postHeight]];
        
    }
    return self;
}
- (void)dealloc
{
    [[XXAudioManager shareManager]audioManagerEndPlayNow];
    [[XXAudioManager shareManager]setDelegate:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    self.isReplyComment = NO;
    [[XXAudioManager shareManager]setDelegate:self];
    
    _currentPageIndex = 0;
    _pageSize = 15;
    _hiddenLoadMore = NO;
    
    CGFloat totalHeight = XXNavContentHeight -44;
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight-49);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    DDLogVerbose(@"self view frame :%@",NSStringFromCGRect(self.view.frame));
    //tool bar
    _chatToolBar = [[XXChatToolBar alloc]initWithFrame:CGRectMake(0,totalHeight-49,self.view.frame.size.width,49+216) forUse:XXChatToolBarComment];
    [self.view addSubview:_chatToolBar];
    
    //add replying noti view
    _replyingCommentNotiView = [[UIView alloc]init];
    _replyingCommentNotiView.frame = CGRectMake(_chatToolBar.frame.origin.x,_chatToolBar.frame.origin.y-30,_chatToolBar.frame.size.width,30);
    _replyingCommentNotiView.hidden = YES;
    _replyingCommentNotiView.backgroundColor = rgb(245,245,245,1);
    [self.view addSubview:_replyingCommentNotiView];
    
    //label
    _replyingWhosCommentLabel = [[UILabel alloc]init];
    _replyingWhosCommentLabel.frame = CGRectMake(20,5,150,20);
    _replyingWhosCommentLabel.font = [UIFont systemFontOfSize:13];
    _replyingWhosCommentLabel.backgroundColor = [UIColor clearColor];
    [_replyingCommentNotiView addSubview:_replyingWhosCommentLabel];
    
    //close btn
    _closeNotiViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeNotiViewButton.frame = CGRectMake(_replyingCommentNotiView.frame.size.width-40,6.5,14.5,14.5);
    [_closeNotiViewButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [_closeNotiViewButton addTarget:self action:@selector(closeReplyNotiView) forControlEvents:UIControlEventTouchUpInside];
    [_replyingCommentNotiView addSubview:_closeNotiViewButton];
    
    DDLogVerbose(@"toobar frame:%@",NSStringFromCGRect(_chatToolBar.frame));
    self.view.keyboardTriggerOffset = 49;
    
    WeakObj(_chatToolBar) weakToolBar = _chatToolBar;
    WeakObj(_replyingCommentNotiView) weakNotiView = _replyingCommentNotiView;
    [self.view addKeyboardNonpanningWithActionHandler:^(CGRect keyboardFrameInView) {
    
        DDLogVerbose(@"keyborad :%@",NSStringFromCGRect(keyboardFrameInView));
        CGRect toolBarFrame = weakToolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - 49;
        weakToolBar.frame = toolBarFrame;
        
        CGRect notiFrame = weakNotiView.frame;
        notiFrame.origin.y = keyboardFrameInView.origin.y - 49-30;
        weakNotiView.frame = notiFrame;
        
    }];
    [self configChatToolBar];
    //is self
    XXSharePostModel *basePost = [self.commentModelArray objectAtIndex:0];
    if ([basePost.userId isEqualToString:[XXUserDataCenter currentLoginUser].userId]) {
        _chatToolBar.hidden = YES;
        _tableView.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight);
    }
    
    //observe keyobard
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    if (!self.isReplyComment) {
        [self requestCommentListNow];
    }
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
    [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
    CGRect naviRect = self.navigationController.view.frame;
    self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height-49);
    
    //stop play audio
    [[XXAudioManager shareManager]audioManagerEndPlayNow];
}
#pragma mark - play audio now
- (void)playAudioNow
{
    _playingIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    XXSharePostModel *cPost = [self.commentModelArray objectAtIndex:0];
    NSString *realAudioUrl = [NSString stringWithFormat:@"%@",cPost.postAudio];
    DDLogVerbose(@"play audio now:%@",realAudioUrl);
    [[XXAudioManager shareManager]audioManagerPlayAudioForRemoteAMRUrl:realAudioUrl];
}

#pragma mark - comment cell delegate
- (void)commentCellDidTapOnAudioButton:(XXCommentCell *)commentCell
{
    _playingIndexPath = [_tableView indexPathForCell:commentCell];
    XXCommentModel *cPost = [self.commentModelArray objectAtIndex:_playingIndexPath.row];
    NSString *realAudioUrl = [NSString stringWithFormat:@"%@",cPost.postAudio];
    DDLogVerbose(@"play audio now:%@",realAudioUrl);
    [[XXAudioManager shareManager]audioManagerPlayAudioForRemoteAMRUrl:realAudioUrl];
}
- (void)commentCellDidCallReplyThisComment:(XXCommentCell *)commentCell
{
    if (_replyingCommentNotiView.hidden) {
        _replyingCommentNotiView.hidden = NO;
    }
    _chatToolBar.hidden = NO;
    _isReplyComment = YES;
    _playingIndexPath = [_tableView indexPathForCell:commentCell];
    XXCommentModel *cPost = [self.commentModelArray objectAtIndex:_playingIndexPath.row];
    self.originCommentId = cPost.commentId;
    self.originCommentUserName = cPost.userName;
    [_chatToolBar.inputTextView becomeFirstResponder];
    _replyingWhosCommentLabel.text = [NSString stringWithFormat:@"回复 %@ :",cPost.userName];
    
}

#pragma mark - white board
- (void)keyboardDidShow
{
    if (!_whiteBoard) {
        _whiteBoard = [[UIControl alloc]initWithFrame:self.view.bounds];
        _whiteBoard.alpha = 0;
        _whiteBoard.backgroundColor = [UIColor whiteColor];
        [_whiteBoard addTarget:self action:@selector(touchDownWhiteBoard) forControlEvents:UIControlEventTouchDown];
        [self.view insertSubview:_whiteBoard belowSubview:_chatToolBar];
        [UIView animateWithDuration:0.3 animations:^{
            _whiteBoard.alpha = 0.05;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _whiteBoard.alpha = 0.05;
        }];
        
    }
}
- (void)keyboardDidHidden
{
    if (_whiteBoard.alpha!=0.f) {
        [UIView animateWithDuration:0.3 animations:^{
            _whiteBoard.alpha = 0;
        }];
    }
}
- (void)touchDownWhiteBoard
{
    [_chatToolBar reginFirstResponse];
    [UIView animateWithDuration:0.3 animations:^{
        _whiteBoard.alpha = 0;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentModelArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *CellIdentifier = @"CellIdentifier ";
        XXShareBaseCell *cell = (XXShareBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[XXShareBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setTapOnAudioImageBlock:^(NSURL *audioUrl, XXShareBaseCell *cell){
                DDLogVerbose(@"audioUrl :%@",audioUrl);
                _playingIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [[XXAudioManager shareManager]audioManagerPlayAudioForRemoteAMRUrl:audioUrl.absoluteString];
            }];
            [cell setTapOnThumbImageBlock:^(NSURL *imageUrl, UIImageView *originImageView, NSArray *allImages, NSInteger currentIndex) {
                int count = allImages.count;
                // 1.封装图片数据
                NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
                for (int i = 0; i<count; i++) {
                    // 替换为中等尺寸图片
                    NSString *url = [allImages objectAtIndex:i];
                    MJPhoto *photo = [[MJPhoto alloc] init];
                    photo.url = [NSURL URLWithString:url]; // 图片路径
                    originImageView.frame = [self.view convertRect:originImageView.frame fromView:self.view];
                    photo.srcImageView = originImageView; // 来源于哪个UIImageView
                    [photos addObject:photo];
                }
                
                // 2.显示相册
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                browser.currentPhotoIndex = currentIndex; // 弹出相册时显示的第一张图片是？
                browser.photos = photos; // 设置所有的图片
                [browser show];
            }];
        }
        [cell setSharePostModelForDetail:[self.commentModelArray objectAtIndex:indexPath.row]];
        
        return cell;
    }else if (indexPath.row==self.commentModelArray.count-1){
        static NSString *CommentIdentifier = @"MoreIdentifier";
        XXLoadMoreCell *cell = (XXLoadMoreCell*)[tableView dequeueReusableCellWithIdentifier:CommentIdentifier];
        
        if (!cell) {
            cell = [[XXLoadMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentIdentifier];
        }
        [cell setTitle:[[self.commentModelArray objectAtIndex:indexPath.row]objectForKey:@"title"]];
        
        return cell;
    }else{
       static NSString *CommentIdentifier = @"CommentIdentifier";
        XXCommentCell *cell = (XXCommentCell*)[tableView dequeueReusableCellWithIdentifier:CommentIdentifier];
        
        if (!cell) {
            cell = [[XXCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentIdentifier];
            [cell setCellType:XXBaseCellTypeMiddel];
            cell.delegate = self;
        }
        
        [cell setCommentModel:[self.commentModelArray objectAtIndex:indexPath.row]];
        
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==self.commentModelArray.count-1) {
        return 46.f;
    }else{
        NSNumber *heightNumb = [self.commentRowHeightArray objectAtIndex:indexPath.row];
        return [heightNumb floatValue];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.commentModelArray.count>1&& indexPath.row== self.commentModelArray.count-1) {
        NSDictionary *stateDict = [self.commentModelArray objectAtIndex:indexPath.row];
        if ([[stateDict objectForKey:@"state"]boolValue]) {
            [self loadMoreResult];
        }
    }
}

#pragma mark - config comment bar
- (void)configChatToolBar
{
    WeakObj(self) weakSelf = self;
    WeakObj(_tableView) weakTable = _tableView;
    WeakObj(_chatToolBar) weakBar = _chatToolBar;
    
    XXSharePostModel *basePostModel = [self.commentModelArray objectAtIndex:0];
    WeakObj(_hud) weakHud = _hud;
    [_chatToolBar setChatToolBarDidRecord:^(NSString *recordUrl, NSString *amrUrl, NSString *timeLength) {
        
        DDLogVerbose(@"record time length:%@",timeLength);
        weakHud.labelText = @"正在发表...";
        [weakHud show:YES];
        NSData *amrFileData = [NSData dataWithContentsOfFile:amrUrl];
        [[XXMainDataCenter shareCenter]uploadFileWithData:amrFileData withFileName:@"comment.amr" withUploadProgressBlock:^(CGFloat progressValue) {
            
            
        } withSuccessBlock:^(XXAttachmentModel *resultModel) {
            
            XXCommentModel *newComment = [[XXCommentModel alloc]init];
            newComment.postAudioTime = timeLength;
            newComment.postAudio = resultModel.link;
            newComment.resourceId = basePostModel.postId;
            newComment.resourceType = @"posts";
            newComment.userName = [XXUserDataCenter currentLoginUser].nickName;
            newComment.sex = [XXUserDataCenter currentLoginUser].sex;
            newComment.schoolName = [XXUserDataCenter currentLoginUser].schoolName;
            newComment.grade = [XXUserDataCenter currentLoginUser].grade;
            newComment.userId = [XXUserDataCenter currentLoginUser].userId;
            if (weakSelf.isReplyComment) {
                newComment.rootCommentId = weakSelf.originCommentId;
                newComment.pCommentId = weakSelf.originCommentId;
                newComment.toUserName = weakSelf.originCommentUserName;
            }
            
            [[XXMainDataCenter shareCenter]requestPublishCommentWithConditionComment:newComment withSuccess:^(XXCommentModel *resultModel) {
                [SVProgressHUD showSuccessWithStatus:@"发表成功"];
                newComment.commentId = resultModel.commentId;
                
                CGFloat newCommentHeight = [XXCommentCell heightForCommentModel:newComment forWidth:weakSelf.view.frame.size.width];
                [weakSelf.commentModelArray insertObject:newComment atIndex:1];
                [weakSelf.commentRowHeightArray insertObject:[NSNumber numberWithFloat:newCommentHeight] atIndex:1];
                NSArray *insertRow = @[[NSIndexPath indexPathForItem:1 inSection:0]];
                [weakTable insertRowsAtIndexPaths:insertRow withRowAnimation:UITableViewRowAnimationTop];
                
                [weakHud hide:YES];
                
            } withFaild:^(NSString *faildMsg) {
                [SVProgressHUD showErrorWithStatus:faildMsg];
            }];
            
        } withFaildBlock:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:faildMsg];
        }];
        
    }];
    
    //send text comment
    [_chatToolBar setChatToolBarTapSend:^(NSString *textContent) {
       
        XXCommentModel *newComment = [[XXCommentModel alloc]init];
        newComment.postAudioTime = @"0";
        newComment.postContent = textContent;
        newComment.resourceId = basePostModel.postId;
        newComment.resourceType = @"posts";
        newComment.userName = [XXUserDataCenter currentLoginUser].nickName;
        newComment.sex = [XXUserDataCenter currentLoginUser].sex;
        newComment.schoolName = [XXUserDataCenter currentLoginUser].schoolName;
        newComment.grade = [XXUserDataCenter currentLoginUser].grade;
        newComment.userId = [XXUserDataCenter currentLoginUser].userId;
        newComment.friendAddTime = [XXCommonUitil getTimeStrStyle3:[NSDate date]];
        if (weakSelf.isReplyComment) {
            newComment.rootCommentId = weakSelf.originCommentId;
            newComment.pCommentId = weakSelf.originCommentId;
            newComment.toUserName = weakSelf.originCommentUserName;
        }
        
        weakHud.labelText = @"正在发表...";
        [weakHud show:YES];
        [weakSelf.view bringSubviewToFront:weakHud];
        
        [[XXMainDataCenter shareCenter]requestPublishCommentWithConditionComment:newComment withSuccess:^(XXCommentModel *resultModel) {
            [SVProgressHUD showSuccessWithStatus:@"发表成功"];
            newComment.commentId = resultModel.commentId;
            
            //content style
            XXShareStyle *contentStyle = [[XXShareStyle alloc]init];
            contentStyle.contentFontFamily = @"Hevica";
            contentStyle.contentFontSize = 12.5;
            contentStyle.contentFontWeight = XXFontWeightNormal;
            contentStyle.contentLineHeight = 1.6;
            contentStyle.contentTextAlign = XXTextAlignLeft;
            contentStyle.contentTextColor = [XXCommonStyle commonPostContentTextColor];
            contentStyle.emojiSize = 13;
            
            newComment.contentAttributedString = [XXBaseTextView formatteTextToAttributedText:newComment.postContent withHtmlTemplateFile:@"xxbase_common_template.html" withCSSTemplate:@"xxbase_comment_style.css" withShareStyle:contentStyle];
            newComment.userHeadContent = [XXSharePostUserView useHeadAttributedStringWithCommnetModel:newComment];


            [weakBar clearContentText];
            CGFloat newCommentHeight = [XXCommentCell heightForCommentModel:newComment forWidth:weakSelf.view.frame.size.width];
            [weakSelf.commentModelArray insertObject:newComment atIndex:1];
            [weakSelf.commentRowHeightArray insertObject:[NSNumber numberWithFloat:newCommentHeight] atIndex:1];
            NSArray *insertRow = @[[NSIndexPath indexPathForItem:1 inSection:0]];
            [weakTable insertRowsAtIndexPaths:insertRow withRowAnimation:UITableViewRowAnimationTop];
            
            [weakHud hide:YES];
            
        } withFaild:^(NSString *faildMsg) {
            [weakHud hide:YES];
            [SVProgressHUD showErrorWithStatus:faildMsg];
            
        }];

    }];
}

#pragma mark - override api
- (void)detailModelArrayAndRowHeightNow
{
    
}

- (void)requestCommentListNow
{
    XXConditionModel *condition = [[XXConditionModel alloc]init];
    condition.pageIndex = StringInt(_currentPageIndex);
    condition.pageSize = StringInt(_pageSize);
    XXSharePostModel *basePost = [self.commentModelArray objectAtIndex:0];
    condition.postId = basePost.postId;
    condition.resType = @"posts";
    
    [[XXMainDataCenter shareCenter]requestCommentListWithCondition:condition withSuccess:^(NSArray *resultList) {
        if (self.commentModelArray.count>1) {
            [self.commentModelArray removeLastObject];
        }
        [self.commentModelArray addObjectsFromArray:resultList];
        [resultList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CGFloat commentHeight = [XXCommentCell heightForCommentModel:obj forWidth:_tableView.frame.size.width];
            NSNumber *commentHeightNumb = [NSNumber numberWithFloat:commentHeight];
            [self.commentRowHeightArray addObject:commentHeightNumb];
        }];
        if (resultList.count<_pageSize) {
            if (self.commentModelArray.count==1) {
                NSDictionary *loadmoreDict = @{@"state":@"0",@"title":@"还没有人评论"};
                [self.commentModelArray addObject:loadmoreDict];
            }else{
                NSDictionary *loadmoreDict = @{@"state":@"0",@"title":@"没有更多评论"};
                [self.commentModelArray addObject:loadmoreDict];
            }
            
        }else{
            NSDictionary *loadmoreDict = @{@"state":@"1",@"title":@"点击加载更多评论"};
            [self.commentModelArray addObject:loadmoreDict];
        }
        [_tableView reloadData];
        
    } withFaild:^(NSString *faildMsg) {
        if (self.commentModelArray.count==1) {
            NSDictionary *loadmoreDict = @{@"state":@"1",@"title":@"点击加载更多评论"};
            [self.commentModelArray addObject:loadmoreDict];
            [_tableView reloadData];
        }
        [SVProgressHUD showErrorWithStatus:faildMsg];
    }];
}
- (void)refresh
{
    
}
- (void)loadMoreResult
{
    
}

#pragma mark - audio manager delegate
- (void)audioManagerDidCancelPlay
{
    if (_playingIndexPath.row==0) {
        XXShareBaseCell *playingCell = (XXShareBaseCell*)[_tableView cellForRowAtIndexPath:_playingIndexPath];
        [playingCell endAudioPlay];
    }else{
        XXCommentCell *playingCell = (XXCommentCell*)[_tableView cellForRowAtIndexPath:_playingIndexPath];
        [playingCell endAudioPlay];
    }
    
}
- (void)audioManagerDidStartPlay
{
    if (_playingIndexPath.row==0) {
        XXShareBaseCell *playingCell = (XXShareBaseCell*)[_tableView cellForRowAtIndexPath:_playingIndexPath];
        [playingCell startAudioPlay];
    }else{
        XXCommentCell *playingCell = (XXCommentCell*)[_tableView cellForRowAtIndexPath:_playingIndexPath];
        [playingCell startAudioPlay];
    }
    
}
- (void)audioManagerDidEndPlay
{
    if (_playingIndexPath.row==0) {
        XXShareBaseCell *playingCell = (XXShareBaseCell*)[_tableView cellForRowAtIndexPath:_playingIndexPath];
        [playingCell endAudioPlay];
    }else{
        XXCommentCell *playingCell = (XXCommentCell*)[_tableView cellForRowAtIndexPath:_playingIndexPath];
        [playingCell endAudioPlay];
    }
}
- (void)audioManagerDidStartDownload
{
    if (_playingIndexPath.row==0) {
        XXShareBaseCell *playingCell = (XXShareBaseCell*)[_tableView cellForRowAtIndexPath:_playingIndexPath];
        [playingCell startLoadingAudio];
    }else{
        XXCommentCell *playingCell = (XXCommentCell*)[_tableView cellForRowAtIndexPath:_playingIndexPath];
        [playingCell startLoadingAudio];
    }
}
- (void)audioManagerDidFinishDownload
{
    if (_playingIndexPath.row==0) {
        XXShareBaseCell *playingCell = (XXShareBaseCell*)[_tableView cellForRowAtIndexPath:_playingIndexPath];
        [playingCell endLoadingAudio];
    }else{
        XXCommentCell *playingCell = (XXCommentCell*)[_tableView cellForRowAtIndexPath:_playingIndexPath];
        [playingCell endLoadingAudio];
    }
}
- (void)audioManagerDidDownloadFaild
{
    if (_playingIndexPath.row==0) {
        XXShareBaseCell *playingCell = (XXShareBaseCell*)[_tableView cellForRowAtIndexPath:_playingIndexPath];
        [playingCell endLoadingAudio];
    }else{
        XXCommentCell *playingCell = (XXCommentCell*)[_tableView cellForRowAtIndexPath:_playingIndexPath];
        [playingCell endLoadingAudio];
    }
}

#pragma mark - 
- (void)closeReplyNotiView
{
    _isReplyComment = NO;
    _replyingCommentNotiView.hidden = YES;
    //is self
    [_chatToolBar.inputTextView resignFirstResponder];
    XXSharePostModel *basePost = [self.commentModelArray objectAtIndex:0];
    if ([basePost.userId isEqualToString:[XXUserDataCenter currentLoginUser].userId]) {
        _chatToolBar.hidden = YES;
        _tableView.frame = CGRectMake(0,0,self.view.frame.size.width,XXNavContentHeight-44);
    }
}

@end
