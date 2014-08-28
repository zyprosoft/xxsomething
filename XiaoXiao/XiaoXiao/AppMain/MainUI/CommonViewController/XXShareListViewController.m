//
//  XXShareListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXShareListViewController.h"
#import "XXShareDetailViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "XXPraiseDetailViewController.h"

@interface XXShareListViewController ()

@end

@implementation XXShareListViewController
@synthesize sharePostModelArray,sharePostRowHeightArray;

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
    self.sharePostRowHeightArray = [[NSMutableArray alloc]init];
    self.sharePostModelArray = [[NSMutableArray alloc]init];
    _currentPageIndex = 0;
    _pageSize = 15;
    _hiddenLoadMore = NO;
    
    CGFloat totalHeight = XXNavContentHeight -44-49;
    _shareListTable = [[UITableView alloc]init];
    _shareListTable.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight);
    _shareListTable.delegate = self;
    _shareListTable.dataSource = self;
    _shareListTable.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    _shareListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_shareListTable];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_shareListTable addSubview:_refreshControl];
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
    return self.sharePostModelArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier ";
    XXShareBaseCell *cell = (XXShareBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[XXShareBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //config cell
        [cell setTapOnPraiseBlock:^(XXShareBaseCell *cell, BOOL selectState) {
            
            NSIndexPath *tapIndex = [tableView indexPathForCell:cell];
            XXSharePostModel *tapPostModel = [self.sharePostModelArray objectAtIndex:tapIndex.row];
            
            if([tapPostModel.userId isEqualToString:[XXUserDataCenter currentLoginUser].userId]){
                XXPraiseDetailViewController *praiseDetail = [[XXPraiseDetailViewController alloc]initWithSharePostModel:tapPostModel];
                praiseDetail.title = @"追捧详情";
                [self.navigationController pushViewController:praiseDetail animated:YES];
                [XXCommonUitil setCommonNavigationReturnItemForViewController:praiseDetail];
                
            }else{
                XXConditionModel *conditionModel = [[XXConditionModel alloc]init];
                conditionModel.resType = @"posts";
                conditionModel.resId = tapPostModel.postId;
                
                if (selectState) {
                    [[XXMainDataCenter shareCenter]requestPraisePublishWithCondition:conditionModel withSuccess:^(NSString *successMsg) {
                        DDLogVerbose(@"praise success");
                    } withFaild:^(NSString *faildMsg) {
                        DDLogVerbose(@"praise faild");
                    }];
                }else{
                    [[XXMainDataCenter shareCenter]requestCancelPraiseWithCondition:conditionModel withSuccess:^(NSString *successMsg) {
                        DDLogVerbose(@"un praise success");
                    } withFaild:^(NSString *faildMsg) {
                        DDLogVerbose(@"un praise faild");
                    }];
                }
            }
            
            
        }];
        [cell setTapOnCommentBlock:^(XXShareBaseCell *cell) {
            NSIndexPath *tapIndex = [tableView indexPathForCell:cell];
            XXShareDetailViewController *shareDetail = [[XXShareDetailViewController alloc]initWithSharePost:[self.sharePostModelArray objectAtIndex:tapIndex.row]];
            shareDetail.title = @"故事详情";
            [self.navigationController pushViewController:shareDetail animated:YES];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:shareDetail];
        }];
        [cell setTapOnAudioImageBlock:^(NSURL *audioUrl, XXShareBaseCell *cell) {
            NSIndexPath *tapIndex = [tableView indexPathForCell:cell];
            XXShareDetailViewController *shareDetail = [[XXShareDetailViewController alloc]initWithSharePost:[self.sharePostModelArray objectAtIndex:tapIndex.row]];
            shareDetail.title = @"故事详情";
            [self.navigationController pushViewController:shareDetail animated:YES];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:shareDetail];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *heightNumb = [self.sharePostRowHeightArray objectAtIndex:indexPath.row];
    return [heightNumb floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXShareDetailViewController *shareDetail = [[XXShareDetailViewController alloc]initWithSharePost:[self.sharePostModelArray objectAtIndex:indexPath.row]];
    shareDetail.title = @"故事详情";
    shareDetail.isReplyComment = NO;
    [self.navigationController pushViewController:shareDetail animated:YES];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:shareDetail];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.sharePostModelArray.count-1 && _hiddenLoadMore == NO) {
        XXLoadMoreView *loadMoreView = [[XXLoadMoreView alloc]initWithFrame:CGRectMake(0,0,cell.frame.size.width,44)];
        tableView.tableFooterView = loadMoreView;
        [loadMoreView startLoading];
        [self loadMoreResult];
    }
}

#pragma mark - override api
- (void)detailModelArrayAndRowHeightNow
{
    
}

- (void)requestShareListNow
{
    
}
- (void)refresh
{
    
}
- (void)loadMoreResult
{
    
}

@end
