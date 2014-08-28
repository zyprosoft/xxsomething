//
//  XXPhotoChooseViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetsPickerController.h"

@class XXPhotoChooseViewController;
@protocol XXPhotoChooseViewControllerDelegate <NSObject>

- (void)photoChooseViewController:(XXPhotoChooseViewController*)aChooseController didFinishChooseImages:(NSArray*)resultImages;
- (void)photoChooseViewControllerDidSelectNextStep:(XXPhotoChooseViewController*)aChooseController;

@end

typedef enum{
    XXPhotoChooseTypeSingle=0,
    XXPhotoChooseTypeMutil,
    
}XXPhotoChooseType;

typedef void (^XXPhotoChooseViewControllerFinishChooseBlock) (NSArray *resultImages);
/*
 *通用图库或者现场拍摄选择
 */
@interface XXPhotoChooseViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,CTAssetsPickerControllerDelegate>
{
    XXPhotoChooseViewControllerFinishChooseBlock _chooseBlock;
    XXCommonNavigationNextStepBlock _nextStepBlock;
    XXNavigationNextStepItemBlock _returnStepBlock;
    NSInteger _maxChooseNumber;
}
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, assign) XXPhotoChooseType chooseType;
@property (nonatomic, assign) CGFloat singleImageCropHeight;//单个图片剪辑的时候的高度
@property (nonatomic, assign) BOOL needCrop;
@property (nonatomic, assign) BOOL needFilter;
@property (nonatomic, assign) BOOL isSetHeadImage;
@property (nonatomic, weak)id<XXPhotoChooseViewControllerDelegate> delegate;

- (id)initWithSinglePhotoChooseFinishAction:(XXPhotoChooseViewControllerFinishChooseBlock)chooseBlock;
- (id)initWithMutilPhotoChooseWithMaxChooseNumber:(NSInteger)maxNumber withFinishBlock:(XXPhotoChooseViewControllerFinishChooseBlock)chooseBlock;
- (void)setNextStepAction:(XXCommonNavigationNextStepBlock)nextStepBlock;
- (void)setReturnStepBlock:(XXNavigationNextStepItemBlock)returnStepBlock;
@end
