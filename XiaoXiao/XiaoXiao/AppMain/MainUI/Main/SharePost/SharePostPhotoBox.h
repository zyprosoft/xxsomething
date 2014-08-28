//
//  SharePostPhotoBox.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-4.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SharePhotoBoxDidTapOnAddBlock) (void);
typedef void (^SharePhotoBoxDidTapToReviewPhotoBlock) (NSInteger currentPhotoIndex);
typedef void (^SharePhotoBoxDidChangeFrameBlock) (CGRect newFrame);

@interface SharePostPhotoBox : UIControl
{
    UIButton *_backgroundImageView;
    UIButton    *_addNewButton;
    SharePhotoBoxDidTapOnAddBlock _addNewBlock;
    SharePhotoBoxDidTapToReviewPhotoBlock _reviewBlock;
    NSInteger _currentImagesNumber;
    SharePhotoBoxDidChangeFrameBlock _changeBlock;
}

- (void)setSharePhotoBoxAddNewBlock:(SharePhotoBoxDidTapOnAddBlock)addBlock;
- (void)setSharePhotoBoxReviewPhotoBlock:(SharePhotoBoxDidTapToReviewPhotoBlock)reviewBlock;
- (void)setSharePhotoboxDidChangeFrameBlock:(SharePhotoBoxDidChangeFrameBlock)changeBlock;
- (void)setImagesArray:(NSArray*)imagesArray;
@end
