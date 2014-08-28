//
//  SquareShareListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "SquareShareListViewController.h"
#import "SharePostGuideViewController.h"
#import "ShareUserFilterViewController.h"

@interface SquareShareListViewController ()

@end

@implementation SquareShareListViewController

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
    self.title = @"校说吧";
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withIconImage:@"nav_share_post_setting.png" withNextStepAction:^{
        ShareUserFilterViewController *filterVC = [[ShareUserFilterViewController alloc]init];
        filterVC.title = @"按条件筛选";
        [self.navigationController pushViewController:filterVC animated:YES];
        [XXCommonUitil setCommonNavigationReturnItemForViewController:filterVC];
    }];
    
    UIImageView *backImageView = [[UIImageView alloc]init];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.layer.shadowOffset = CGSizeMake(0,0.3);
    backImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    backImageView.layer.shadowOpacity = 0.2f;
    backImageView.frame = CGRectMake(0,0,self.view.frame.size.width,44);
    [self.view addSubview:backImageView];
    
    _textShareButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    _textShareButton.frame = CGRectMake(0,0,106.6,44);
    _textShareButton.backgroundColor = [UIColor whiteColor];
    [_textShareButton setNormalIconImage:@"share_post_text_normal.png" withSelectedImage:@"share_post_text_selected.png" withFrame:CGRectMake(33,12.5,19,19)];
    [_textShareButton setTitle:@"文字" withFrame:CGRectMake(33,3,50,44)];
    _textShareButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [_textShareButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_textShareButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_textShareButton addTarget:self action:@selector(tapOnPostButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_textShareButton];
    
    _aduioShareBtton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    _aduioShareBtton.frame = CGRectMake(107,0,106.6,44);
    [_aduioShareBtton setNormalIconImage:@"share_post_audio_normal.png" withSelectedImage:@"share_post_audio_selected.png" withFrame:CGRectMake(37,11,15,21)];
    [_aduioShareBtton setTitle:@"语音" withFrame:CGRectMake(33,3,50,44)];
    _aduioShareBtton.titleLabel.font = [UIFont systemFontOfSize:10];
    [_aduioShareBtton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_aduioShareBtton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_aduioShareBtton addTarget:self action:@selector(tapOnPostButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_aduioShareBtton];
    
    _imageShareButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    _imageShareButton.frame = CGRectMake(214,0,106.6,44);
    _imageShareButton.backgroundColor = [UIColor whiteColor];
    [_imageShareButton setNormalIconImage:@"share_post_image_normal.png" withSelectedImage:@"share_post_image_selected.png" withFrame:CGRectMake(33,14.5,18.5,14.5)];
    [_imageShareButton setTitle:@"图片" withFrame:CGRectMake(33,3,50,44)];
    _imageShareButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [_imageShareButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_imageShareButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_imageShareButton addTarget:self action:@selector(tapOnPostButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_imageShareButton];
    
    CGRect tableViewOldFrame = _shareListTable.frame;
    _shareListTable.frame = CGRectMake(tableViewOldFrame.origin.x,tableViewOldFrame.origin.y+44,tableViewOldFrame.size.width,tableViewOldFrame.size.height-44);
    //start loading
    [_refreshControl beginRefreshing];
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapOnPostButton:(UIButton*)sender
{
    SharePostType postTye;
    if (sender == _textShareButton) {
        postTye = SharePostTypeText;
    }
    if (sender == _aduioShareBtton) {
        postTye = SharePostTypeAudio;
    }
    if (sender == _imageShareButton) {
        postTye = SharePostTypeImage;
    }
    
    SharePostGuideViewController *postGuideVC = [[SharePostGuideViewController alloc]initWithSharePostType:postTye];
    [self.navigationController pushViewController:postGuideVC animated:YES];
}

- (void)requestShareListNow
{
    XXConditionModel *condtion = [[XXConditionModel alloc]init];
    condtion.pageIndex = [NSString stringWithFormat:@"%d",_currentPageIndex];
    condtion.pageSize = [NSString stringWithFormat:@"%d",_pageSize];
    condtion.schoolId = [XXUserDataCenter currentLoginUser].schoolId;
    DDLogVerbose(@"share list school Id:%@",condtion.schoolId);
    
    [[XXMainDataCenter shareCenter]requestSharePostListWithCondition:condtion withSuccess:^(NSArray *resultList) {
        
        if (resultList.count<_pageSize) {
            _hiddenLoadMore = YES;
        }
        if (_isRefresh) {
            [self.sharePostModelArray removeAllObjects];
            [self.sharePostRowHeightArray removeAllObjects];
            _isRefresh = NO;
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
