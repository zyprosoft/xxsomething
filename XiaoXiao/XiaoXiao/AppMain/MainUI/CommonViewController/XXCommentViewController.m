//
//  XXCommentViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXCommentViewController.h"
#import "XXLoadMoreCell.h"

@interface XXCommentViewController ()

@end

@implementation XXCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithSharePost:(XXSharePostModel *)aSharePost withOriginComment:(XXCommentModel *)aComment
{
    if (self = [super initWithSharePost:aSharePost]) {
        
        _originComment = aComment;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.isReplyComment = YES;
    self.originCommentId = _originComment.commentId;
    self.originCommentUserName = _originComment.userName;
    [self.commentModelArray removeAllObjects];
    [self.commentRowHeightArray removeAllObjects];
    _chatToolBar.hidden = NO;
    
    //add origin comment
    CGFloat commentHeight = [XXCommentCell heightForCommentModel:_originComment forWidth:_tableView.frame.size.width];
    [self.commentRowHeightArray addObject:[NSNumber numberWithFloat:commentHeight]];
    [self.commentModelArray addObject:_originComment];
    [_tableView reloadData];
    
    [self requestSharePostDetail];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isGetDetailSuccess) {
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
        }else{
            static NSString *CommentIdentifier = @"CommentIdentifier";
            XXCommentCell *cell = (XXCommentCell*)[tableView dequeueReusableCellWithIdentifier:CommentIdentifier];
            
            if (!cell) {
                cell = [[XXCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentIdentifier];
                cell.delegate = self;
            }
            if (indexPath.row==0) {
                [cell setCellType:XXBaseCellTypeTop];
            }else if(indexPath.row==self.commentModelArray.count-1) {
                [cell setCellType:XXBaseCellTypeBottom];
            }else{
                [cell setCellType:XXBaseCellTypeMiddel];
            }
            [cell setCommentModel:[self.commentModelArray objectAtIndex:indexPath.row]];
            cell.replyThisCommentBtn.hidden = YES;
            
            return cell;
        }
        
    }else{
        static NSString *CommentIdentifier = @"CommentIdentifier";
        XXCommentCell *cell = (XXCommentCell*)[tableView dequeueReusableCellWithIdentifier:CommentIdentifier];
        
        if (!cell) {
            cell = [[XXCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentIdentifier];
            cell.delegate = self;
        }
        if (indexPath.row==0) {
            [cell setCellType:XXBaseCellTypeTop];
        }else if(indexPath.row==self.commentModelArray.count-1) {
            [cell setCellType:XXBaseCellTypeBottom];
        }else{
            [cell setCellType:XXBaseCellTypeMiddel];
        }
        [cell setCommentModel:[self.commentModelArray objectAtIndex:indexPath.row]];
        cell.replyThisCommentBtn.hidden = YES;

        
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *heightNumb = [self.commentRowHeightArray objectAtIndex:indexPath.row];
    return [heightNumb floatValue];
}
- (void)requestCommentListNow
{
    
}
- (void)requestCommentList
{
    XXConditionModel *condition = [[XXConditionModel alloc]init];
    condition.pageIndex = StringInt(_currentPageIndex);
    condition.pageSize = StringInt(_pageSize);
    XXSharePostModel *basePost = [self.commentModelArray objectAtIndex:0];
    condition.postId = basePost.postId;
    condition.resType = @"posts";
    condition.toUserId = _originComment.userId;
    
    [[XXMainDataCenter shareCenter]requestCommentListWithCondition:condition withSuccess:^(NSArray *resultList) {
        [self.commentModelArray removeLastObject];
        [self.commentModelArray addObjectsFromArray:resultList];
        [resultList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CGFloat commentHeight = [XXCommentCell heightForCommentModel:obj forWidth:_tableView.frame.size.width];
            NSNumber *commentHeightNumb = [NSNumber numberWithFloat:commentHeight];
            [self.commentRowHeightArray addObject:commentHeightNumb];
        }];
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


- (void)requestSharePostDetail
{
    XXConditionModel *condition = [[XXConditionModel alloc]init];
    condition.resId = _originComment.resourceId;
    
   [[XXMainDataCenter shareCenter]requestSharePostListWithCondition:condition withSuccess:^(NSArray *resultList) {
       _isGetDetailSuccess = YES;
       XXSharePostModel *detailModel = [resultList objectAtIndex:0];
       [self.commentModelArray insertObject:detailModel atIndex:0];
       CGFloat postHeight = [XXShareBaseCell heightWithSharePostModelForDetail:detailModel forContentWidth:[XXSharePostStyle sharePostContentWidth]];
       [self.commentRowHeightArray insertObject:[NSNumber numberWithFloat:postHeight] atIndex:0];
       [_tableView reloadData];
       [self requestCommentList];
       
   } withFaild:^(NSString *faildMsg) {
       [SVProgressHUD showErrorWithStatus:@"获取故事详情失败"];
       _isGetDetailSuccess = NO;
   }];
    
}

@end
