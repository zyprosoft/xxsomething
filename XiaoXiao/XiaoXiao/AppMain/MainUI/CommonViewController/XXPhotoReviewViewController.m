//
//  XXPhotoReviewViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-6.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXPhotoReviewViewController.h"


@interface XXPhotoReviewViewController ()

@end

@implementation XXPhotoReviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImagesArray:(NSArray *)imagesArray withStartIndex:(NSInteger)startIndex
{
    if (self = [super init]) {
        
        _reviewImages = [[NSMutableArray alloc]initWithArray:imagesArray];
        _isSharePostPhotoReview  = YES;
        _currentImageIndex = startIndex;
    }
    return self;
}
- (id)initWithImageUrls:(NSArray *)imageUrls withStartIndex:(NSInteger)startIndex
{
    if (self = [super init]) {
        
        _reviewImageUrls = [[NSMutableArray alloc]initWithArray:imageUrls];
        _currentImageIndex = startIndex;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"图片详情";
    
    CGFloat totalHeight = XXNavContentHeight-44;
    _contentScrollView.backgroundColor = [UIColor blackColor];
    
    _contentScrollView = [[UIScrollView alloc]init];
    _contentScrollView.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight);
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = YES;
    if (_isSharePostPhotoReview) {
        _contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width*_reviewImages.count,totalHeight);
    }else{
        _contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width*_reviewImageUrls.count, totalHeight);
    }
    [self.view addSubview:_contentScrollView];
    [_contentScrollView scrollRectToVisible:CGRectMake(_currentImageIndex*_contentScrollView.frame.size.width,0,_contentScrollView.frame.size.width,_contentScrollView.frame.size.height) animated:NO];
    
    _pageIndcatorLabel = [[UILabel alloc]init];
    _pageIndcatorLabel.frame = CGRectMake(110,XXNavContentHeight-80,100,40);
    _pageIndcatorLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_pageIndcatorLabel];
    _pageIndcatorLabel.hidden = YES;
    
    //addImages
#define XXPhotoReviewSubImageViewBaseTag 23300
    
    if (_isSharePostPhotoReview) {
        
        [_reviewImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            CGRect itemRect = CGRectMake(_contentScrollView.frame.size.width*idx,0,_contentScrollView.frame.size.width,_contentScrollView.frame.size.height);
            UIImageView *newImageView = [[UIImageView alloc]initWithFrame:itemRect];
            newImageView.tag = XXPhotoReviewSubImageViewBaseTag+idx;
            newImageView.contentMode = UIViewContentModeScaleAspectFit;
            [_contentScrollView addSubview:newImageView];
            newImageView.image = obj;
        }];
        
        _pageIndcatorLabel.text = [NSString stringWithFormat:@"%d/%d",_currentImageIndex,_reviewImages.count];
    }else{
        
        [_reviewImageUrls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            CGRect itemRect = CGRectMake(_contentScrollView.frame.size.width*idx,0,_contentScrollView.frame.size.width,_contentScrollView.frame.size.height);
            XXImageView *imageView = [[XXImageView alloc]initWithFrame:itemRect withNeedOverlay:NO];
            imageView.tag = XXPhotoReviewSubImageViewBaseTag+idx;
            [imageView setImageUrl:obj];
            [_contentScrollView addSubview:imageView];
            
        }];
        _pageIndcatorLabel.text = [NSString stringWithFormat:@"%d/%d",_currentImageIndex,_reviewImageUrls.count];

    }
    
    //next action
    if (_isSharePostPhotoReview) {
        [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withIconImage:@"nav_photo_delete.png" withNextStepAction:^{
            if (!_actionSheetView) {
                _actionSheetView = [[XXActionSheetView alloc]initWithFrame:CGRectMake(0,totalHeight,self.view.frame.size.width,200) withTitle:@"您确定要删除这张照片吗"];
            }
            [self.view addSubview:_actionSheetView];
            [UIView animateWithDuration:0.3 animations:^{
                _actionSheetView.frame = CGRectMake(0,totalHeight-200,self.view.frame.size.width,200);
            } completion:^(BOOL finished) {
            }];
            XXActionSheetViewDidChooseIndexBlock finishBlock = ^(BOOL checkState){
                if (checkState) {
                    [self removeImageViewAtIndex:_currentImageIndex];
                }
                [UIView animateWithDuration:0.3 animations:^{
                    _actionSheetView.frame = CGRectMake(0,totalHeight,self.view.frame.size.width,200);
                } completion:^(BOOL finished) {
                    
                }];
            };
            [_actionSheetView setFinishChooseIndexBlock:^(BOOL checkState) {
                finishBlock(checkState);
            }];
        }];
        [XXCommonUitil setCommonNavigationReturnItemForViewController:self withBackStepAction:^{
            if (_finishBlock) {
                _finishBlock(_reviewImages);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)loadImageViews
{
    
    [_reviewImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CGRect itemRect = CGRectMake(_contentScrollView.frame.size.width*idx,0,_contentScrollView.frame.size.width,_contentScrollView.frame.size.height);
        UIImageView *newImageView = [[UIImageView alloc]initWithFrame:itemRect];
        newImageView.tag = XXPhotoReviewSubImageViewBaseTag+idx;
        newImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_contentScrollView addSubview:newImageView];
        newImageView.image = obj;
    }];
}

//删除一张照片
- (void)removeImageViewAtIndex:(NSInteger)index
{
    if (index>=_reviewImages.count) {
        return;
    }
    if (_isSharePostPhotoReview) {
        [_reviewImages removeObjectAtIndex:index];
        [_contentScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            if ([obj isKindOfClass:[UIImageView class]]) {
                
                [(UIImageView*)obj removeFromSuperview];
            }
            
        }];
        [self loadImageViews];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFinishReview:(XXPhotoReviewControllerFinishReviewBlock)finishBlock
{
    _finishBlock = [finishBlock copy];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentImageIndex = scrollView.contentOffset.x/self.view.frame.size.width;
    NSString *pageString = [NSString stringWithFormat:@"%d/%d",_currentImageIndex,_reviewImages.count];
    _pageIndcatorLabel.text = pageString;
    
}

@end
