//
//  XXPhotoFilterViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGMedallionView.h"
#import "ZYImageFilter.h"

@class XXPhotoFilterViewController;
@protocol XXPhotoFilterViewControllerDelegate <NSObject>

- (void)photoFilterViewController:(XXPhotoFilterViewController*)aFilterController didFinishWithResultImage:(UIImage*)resultImage;
- (void)photoFilterViewControllerDidSelectNextStep:(XXPhotoFilterViewController*)aFilterController;

@end
/*
 *通用照片滤镜视图
 */
typedef void (^XXPhotoFilterViewControllerFinishChooseEffectBlock) (UIImage *resultImage);

@interface XXPhotoFilterViewController : UIViewController
{
    AGMedallionView *effectHeadImgView;
    UIImageView     *effectImgView;
    ZYImageFilter   *_imageFilter;
    
    XXPhotoFilterViewControllerFinishChooseEffectBlock _chooseBlock;
    XXCommonNavigationNextStepBlock _nextStepBlock;
}
@property (nonatomic,strong)UIImage *currentImage;
@property (nonatomic,assign)CGFloat effectImgViewHeight;
@property (nonatomic,assign)BOOL isSettingHeadImage;
@property (nonatomic,weak)id<XXPhotoFilterViewControllerDelegate> delegate;

- (id)initWithCurrentImage:(UIImage*)aImage withChooseBlock:(XXPhotoFilterViewControllerFinishChooseEffectBlock)chooseBlock;
- (void)setNextStepAction:(XXCommonNavigationNextStepBlock)nextStepBlock;
@end
