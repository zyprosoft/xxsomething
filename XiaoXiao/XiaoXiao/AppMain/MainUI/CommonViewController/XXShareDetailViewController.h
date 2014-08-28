//
//  XXShareDetailViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-9.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXCommentCell.h"
#import "XXChatToolBar.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "XXBaseViewController.h"

@interface XXShareDetailViewController : XXBaseViewController<UITableViewDelegate,UITableViewDataSource,XXAudioManagerDelegate,XXCommentCellDelegate>
{
    UITableView *_tableView;
    NSInteger   _currentPageIndex;
    NSInteger   _pageSize;
    BOOL        _hiddenLoadMore;
    
    XXChatToolBar *_chatToolBar;
    UIControl        *_whiteBoard;
    
    NSIndexPath  *_playingIndexPath;
    
    UIView       *_replyingCommentNotiView;
    UILabel      *_replyingWhosCommentLabel;
    UIButton     *_closeNotiViewButton;
}
@property (nonatomic,strong)NSMutableArray *commentModelArray;
@property (nonatomic,strong)NSMutableArray *commentRowHeightArray;
@property (nonatomic,strong)NSString       *originCommentId;
@property (nonatomic,strong)NSString       *originCommentUserName;
@property (nonatomic,assign)BOOL            isReplyComment;

- (id)initWithSharePost:(XXSharePostModel*)aSharePost;

- (void)requestCommentListNow;
- (void)refresh;
- (void)loadMoreResult;

- (void)playAudioNow;

@end
