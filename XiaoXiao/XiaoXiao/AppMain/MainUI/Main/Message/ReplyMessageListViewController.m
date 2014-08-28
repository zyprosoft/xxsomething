//
//  ReplyMessageListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "ReplyMessageListViewController.h"
#import "XXCommentViewController.h"

@interface ReplyMessageListViewController ()

@end

@implementation ReplyMessageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _isRefresh = YES;
    [_refreshControl beginRefreshing];
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXCommentModel *commentModel = [_messagesArray objectAtIndex:indexPath.row];
    XXSharePostModel *aPost = [[XXSharePostModel alloc]init];
    aPost.postId = commentModel.resourceId;
    aPost.userId = commentModel.userId;
    XXCommentViewController *commentVC = [[XXCommentViewController alloc]initWithSharePost:aPost withOriginComment:commentModel];
    commentVC.title = @"评论详情";
    commentVC.isReplyComment = YES;
    [self.superNav pushViewController:commentVC animated:YES];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:commentVC];
}

#pragma mark - override api
- (void)requestMessageListNow
{
    XXConditionModel *condition = [[XXConditionModel alloc]init];
    condition.pageSize = StringInt(_pageSize);
    condition.pageIndex = StringInt(_currentPageIndex);
    condition.desc = @"0";
    [[XXMainDataCenter shareCenter]requestReplyMeListWithCondition:condition withSuccess:^(NSArray *resultList) {
        
        if (_isRefresh) {
            [XXSimpleAudio playRefreshEffect];
            [_messagesArray removeAllObjects];
            [_refreshControl endRefreshing];
        }
        [_messagesArray addObjectsFromArray:resultList];
        
        [_messageListTable reloadData];
    } withFaild:^(NSString *faildMsg) {
        [_messageListTable reloadData];
        [_refreshControl endRefreshing];
    }];
}
- (void)refresh
{
    _currentPageIndex = 0;
    _isRefresh = YES;
    [_refreshControl beginRefreshing];
    [self requestMessageListNow];
}
- (void)loadMoreResult
{
    
}

#pragma mark - message cell delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self deletePathAction];
    }
    _tapOnCellPath = nil;
}
- (void)deletePathAction
{
    XXCommentModel *commentModel = [_messagesArray objectAtIndex:_tapOnCellPath.row];
    _hud.labelText = @"正在删除...";
    [self.view bringSubviewToFront:_hud];
    [_hud show:YES];
    [[XXMainDataCenter shareCenter]requestDeleteCommentWithComment:commentModel withSuccess:^(NSArray *resultList) {
        [_hud hide:YES];
        [_messagesArray removeObject:commentModel];
        [_messageListTable reloadData];
    } withFaild:^(NSString *faildMsg) {
        [_hud hide:YES];
        [SVProgressHUD showErrorWithStatus:faildMsg];
    }];
    
}
- (void)messageBaseCellDidCallLongTapDelete:(XXMessageBaseCell *)cell
{
    if (_tapOnCellPath != nil) {
        return;
    }
    _tapOnCellPath = [_messageListTable indexPathForCell:cell];
    NSString *contentMsg = [NSString stringWithFormat:@"是否删除此评论"];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:contentMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

@end
