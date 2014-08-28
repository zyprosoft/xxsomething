//
//  MyShareListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "MyShareListViewController.h"
#import "XXMyShareBaseCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "XXPraiseDetailViewController.h"
#import "XXShareDetailViewController.h"

@interface MyShareListViewController ()

@end

@implementation MyShareListViewController

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
    [_refreshControl beginRefreshing];
    [self refresh];
    
    //
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withIconImage:@"my_post.png" withNextStepAction:^{
        SharePostGuideViewController *postGuideVC = [[SharePostGuideViewController alloc]initWithSharePostType:SharePostTypeText];
        postGuideVC.delegate = self;
        [self.navigationController pushViewController:postGuideVC animated:YES];
    }];
}

#pragma mark - share post vc delegate
- (void)sharePostGuideViewControllerFinishPostNow
{
    [self.navigationController popViewControllerAnimated:YES];
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier ";
    XXMyShareBaseCell  *cell = (XXMyShareBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXMyShareBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setDeleteShareBlock:^(XXMyShareBaseCell *tapOnCell) {
            NSIndexPath *deletePath = [tableView indexPathForCell:tapOnCell];
            [self deleteActionAtIndexPath:deletePath];
        }];
        [cell setTapOnPraiseBlock:^(XXShareBaseCell *cell, BOOL selectState) {
            
            NSIndexPath *tapIndex = [tableView indexPathForCell:cell];
            XXSharePostModel *tapPostModel = [self.sharePostModelArray objectAtIndex:tapIndex.row];
            
            XXPraiseDetailViewController *praiseDetail = [[XXPraiseDetailViewController alloc]initWithSharePostModel:tapPostModel];
            praiseDetail.title = @"追捧详情";
            [self.navigationController pushViewController:praiseDetail animated:YES];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:praiseDetail];
        
        }];
        [cell setTapOnCommentBlock:^(XXShareBaseCell *cell) {
            NSIndexPath *tapIndex = [tableView indexPathForCell:cell];
            XXShareDetailViewController *shareDetail = [[XXShareDetailViewController alloc]initWithSharePost:[self.sharePostModelArray objectAtIndex:tapIndex.row]];
            shareDetail.title = @"故事详情";
            shareDetail.isReplyComment = NO;
            [self.navigationController pushViewController:shareDetail animated:YES];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:shareDetail];
        }];
        [cell setTapOnAudioImageBlock:^(NSURL *audioUrl, XXShareBaseCell *cell) {
            NSIndexPath *tapIndex = [tableView indexPathForCell:cell];
            XXShareDetailViewController *shareDetail = [[XXShareDetailViewController alloc]initWithSharePost:[self.sharePostModelArray objectAtIndex:tapIndex.row]];
            shareDetail.title = @"故事详情";
            shareDetail.isReplyComment = NO;
            [self.navigationController pushViewController:shareDetail animated:YES];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:shareDetail];
            [shareDetail performSelector:@selector(playAudioNow) withObject:nil afterDelay:0.5];
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
    [cell setSharePostModel:[self.sharePostModelArray objectAtIndex:indexPath.row]];
    
    return cell;

}

#pragma mark - deleteAction
- (void)deleteActionAtIndexPath:(NSIndexPath*)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除这条说说？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    _tapPath = indexPath;
    
}

#pragma mark - tease me cell delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (_tapPath) {
            
            XXSharePostModel *postModel = [self.sharePostModelArray objectAtIndex:_tapPath.row];
            XXConditionModel *conditionModel = [[XXConditionModel alloc]init];
            conditionModel.postId = postModel.postId;
            [[XXMainDataCenter shareCenter]requestDeletePostWithCondition:conditionModel withSuccess:^(NSString *successMsg) {
                [SVProgressHUD showSuccessWithStatus:successMsg];
                [self.sharePostModelArray removeObjectAtIndex:_tapPath.row];
                [self.sharePostRowHeightArray removeObjectAtIndex:_tapPath.row];
                
                [_shareListTable deleteRowsAtIndexPaths:@[_tapPath] withRowAnimation:UITableViewRowAnimationTop];
                
            } withFaild:^(NSString *faildMsg) {
                [SVProgressHUD showErrorWithStatus:faildMsg];
            }];
        }
    }
}


- (void)requestShareListNow
{
    XXConditionModel *condtion = [[XXConditionModel alloc]init];
    condtion.pageIndex = [NSString stringWithFormat:@"%d",_currentPageIndex];
    condtion.pageSize = [NSString stringWithFormat:@"%d",_pageSize];
    condtion.userId = [XXUserDataCenter currentLoginUser].userId;
    condtion.schoolId = [XXUserDataCenter currentLoginUser].schoolId;
    
    [[XXMainDataCenter shareCenter]requestSharePostListWithCondition:condtion withSuccess:^(NSArray *resultList) {
        
        if (resultList.count<_pageSize) {
            _hiddenLoadMore = YES;
            if (resultList.count==0&&self.sharePostModelArray.count==0) {
                [SVProgressHUD showErrorWithStatus:@"你还没有讲过你的故事"];
            }
        }
        if (_isRefresh) {
            [self.sharePostModelArray removeAllObjects];
            [self.sharePostRowHeightArray removeAllObjects];
            _isRefresh = NO;
            [XXSimpleAudio playRefreshEffect];
        }
        [resultList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            XXSharePostModel *postModel = (XXSharePostModel*)obj;
            CGFloat heightForModel = [XXShareBaseCell heightWithSharePostModel:postModel forContentWidth:[XXSharePostStyle sharePostContentWidth]];
            [self.sharePostRowHeightArray addObject:[NSNumber numberWithFloat:heightForModel]];
            
        }];
        [self.sharePostModelArray addObjectsFromArray:resultList];
        [_refreshControl endRefreshing];
        [_shareListTable reloadData];
        
    } withFaild:^(NSString *faildMsg) {
        [SVProgressHUD showErrorWithStatus:faildMsg];
        if (_isRefresh) {
            _isRefresh = NO;
            [_refreshControl endRefreshing];
        }
        [_shareListTable reloadData];
    }];
}
- (void)refresh
{
    _currentPageIndex = 0;
    _isRefresh = YES;
    _hiddenLoadMore = NO;
    [self requestShareListNow];
}
- (void)loadMoreResult
{
    _currentPageIndex ++;
    [self requestShareListNow];
}


@end
