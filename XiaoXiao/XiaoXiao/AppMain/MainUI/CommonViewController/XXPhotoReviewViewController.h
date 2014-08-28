//
//  XXPhotoReviewViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-6.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXActionSheetView.h"

//支持图片网络大图浏览和本地准备上传图片浏览

typedef void (^XXPhotoReviewControllerFinishReviewBlock) (NSArray *resultImages);
@interface XXPhotoReviewViewController : UIViewController<UIScrollViewDelegate>
{
    NSMutableArray *_reviewImages;
    NSMutableArray *_reviewImageUrls;
    XXPhotoReviewControllerFinishReviewBlock _finishBlock;
    
    UIScrollView   *_contentScrollView;
    UILabel        *_pageIndcatorLabel;
    XXActionSheetView *_actionSheetView;
    BOOL            _isSharePostPhotoReview;
    NSInteger      _currentImageIndex;
    
}
- (id)initWithImagesArray:(NSArray*)imagesArray withStartIndex:(NSInteger)startIndex;
- (id)initWithImageUrls:(NSArray*)imageUrls withStartIndex:(NSInteger)startIndex;
- (void)setFinishReview:(XXPhotoReviewControllerFinishReviewBlock)finishBlock;

@end
