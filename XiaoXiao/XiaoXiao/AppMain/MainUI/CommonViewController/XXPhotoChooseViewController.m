
//
//  XXPhotoChooseViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXPhotoChooseViewController.h"
#import "XXPhotoCropViewController.h"
#import "XXPhotoFilterViewController.h"

@interface XXPhotoChooseViewController ()

@end

@implementation XXPhotoChooseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPhotoChooseFinishAction:(XXPhotoChooseViewControllerFinishChooseBlock)chooseBlock
{
    if (self = [super init]) {
        
        _chooseBlock = chooseBlock;
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        self.chooseType = XXPhotoChooseTypeSingle;
        _maxChooseNumber = 1;
    }
    return self;
}
- (id)initWithMutilPhotoChooseWithMaxChooseNumber:(NSInteger)maxNumber withFinishBlock:(XXPhotoChooseViewControllerFinishChooseBlock)chooseBlock
{
    if (self = [super init]) {
        
        _chooseBlock = chooseBlock;
        _maxChooseNumber = maxNumber;
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        if (maxNumber>1) {
            self.chooseType = XXPhotoChooseTypeMutil;
        }else{
            self.chooseType = XXPhotoChooseTypeSingle;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    DDLogVerbose(@"self.view :%@",NSStringFromCGRect(self.view.frame));
    
    XXCustomButton *chooseCamerou = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    chooseCamerou.frame = CGRectMake(20,20,280,40);
    chooseCamerou.tag = 238790;
    [chooseCamerou blueStyle];
    chooseCamerou.iconImageView.image = [UIImage imageNamed:@"photo_choose_camerou.png"];
    chooseCamerou.iconImageView.frame = CGRectMake(76,10,20,20);
    [chooseCamerou setTitle:@"现场拍照" forState:UIControlStateNormal];
    chooseCamerou.titleLabel.frame = CGRectMake(115,3,80,34);
    [self.view addSubview:chooseCamerou];
    [chooseCamerou addTarget:self action:@selector(chooseTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    XXCustomButton *chooseLibrary = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    chooseLibrary.frame = CGRectMake(20,80,280,40);
    chooseLibrary.tag = 238791;
    [chooseLibrary blueStyle];
    chooseLibrary.iconImageView.image = [UIImage imageNamed:@"photo_choose_lib.png"];
    [chooseLibrary setTitle:@"相册筛选" forState:UIControlStateNormal];
    chooseLibrary.titleLabel.frame = CGRectMake(115,3,80,34);
    chooseLibrary.iconImageView.frame = CGRectMake(76,10,20,20);
    [self.view addSubview:chooseLibrary];
    [chooseLibrary addTarget:self action:@selector(chooseTypeAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([XXCommonUitil appMainTabController]) {
        [[XXCommonUitil appMainTabController] setTabBarHidden:YES];
        CGRect naviRect = self.navigationController.view.frame;
        self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height+49);
    }else{
        
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([XXCommonUitil appMainTabController]) {
        [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
        CGRect naviRect = self.navigationController.view.frame;
        self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height-49);
    }else{
        
    }
    
}

#pragma mark - tap
- (void)chooseTypeAction:(UIButton*)sender
{
    NSInteger type = sender.tag-238790;
    if (type==0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:@"此设备不支持拍照哦～"];
        }
    }
    if (type==1) {
        
        CTAssetsPickerController *pickController=[[CTAssetsPickerController alloc]init];
        pickController.delegate = self;
        [self presentViewController:pickController animated:YES completion:Nil];
    }
}
//CTAssetsPickerController delegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    DDLogVerbose(@"mutil image select :%@",assets);
    if (assets.count==0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        ALAsset *item = (ALAsset*)obj;
        ALAssetRepresentation *itemRepresention = [item defaultRepresentation];
        UIImage *image = [UIImage imageWithCGImage:[itemRepresention fullScreenImage]];
        [imageArray addObject:image];
        
    }];
    
    if (self.needCrop) {
        ALAssetRepresentation *imageRepresentaion = [[assets objectAtIndex:0]defaultRepresentation];
        UIImage *image = [UIImage imageWithCGImage:[imageRepresentaion fullResolutionImage]];
        XXPhotoCropViewController *cropVC = [[XXPhotoCropViewController alloc]initWithOriginImage:image withFinishCropBlock:^(UIImage *resultImage) {
            if (self.needFilter) {
                XXPhotoFilterViewController *filterVC = [[XXPhotoFilterViewController alloc]initWithCurrentImage:resultImage withChooseBlock:^(UIImage *resultImage) {
                    if (_chooseBlock) {
                        NSArray *chooseImages = @[resultImage];
                        if (_chooseBlock) {
                            _chooseBlock(chooseImages);
                        }
                    }
                }];
                filterVC.effectImgViewHeight = self.singleImageCropHeight;
                filterVC.isSettingHeadImage = self.isSetHeadImage;
                filterVC.title = @"选择滤镜";
                [filterVC setNextStepAction:^(NSDictionary *resultDict) {
                    if (_nextStepBlock) {
                        _nextStepBlock(resultDict);
                    }
                }];
                [self.navigationController pushViewController:filterVC animated:YES];
                [XXCommonUitil setCommonNavigationReturnItemForViewController:filterVC withBackStepAction:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                if (_chooseBlock) {
                    NSArray *resultImages = @[resultImage];
                    _chooseBlock(resultImages);
                }
            }
        }];
        cropVC.visiableHeight = self.singleImageCropHeight;
        [self.navigationController pushViewController:cropVC animated:YES];
    }else{
        if (self.needFilter) {
            ALAssetRepresentation *imageRepresentaion = [[assets objectAtIndex:0]defaultRepresentation];
            UIImage *image = [UIImage imageWithCGImage:[imageRepresentaion fullResolutionImage]];
            XXPhotoFilterViewController *filterVC = [[XXPhotoFilterViewController alloc]initWithCurrentImage:image withChooseBlock:^(UIImage *resultImage) {
                if (_chooseBlock) {
                    NSArray *chooseImages = @[resultImage];
                    if (_chooseBlock) {
                        _chooseBlock(chooseImages);
                    }
                }
            }];
            filterVC.effectImgViewHeight = self.singleImageCropHeight;
            filterVC.isSettingHeadImage = self.isSetHeadImage;
            filterVC.title = @"选择滤镜";
            [filterVC setNextStepAction:^(NSDictionary *resultDict) {
                if (_nextStepBlock) {
                    _nextStepBlock(resultDict);
                }
            }];
            [self.navigationController pushViewController:filterVC animated:YES];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:filterVC withBackStepAction:^{
                if (_returnStepBlock) {
                    _returnStepBlock();
                }
            }];
        }else{
            if (_chooseBlock) {
                _chooseBlock(imageArray);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    if (picker.selectedAssets.count >= _maxChooseNumber)
    {
        NSString *maxMessage = [NSString stringWithFormat:@"不能再选择超过%d张照片",_maxChooseNumber];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:maxMessage
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
    
    if (!asset.defaultRepresentation)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"还没有任何照片"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
    
    return (picker.selectedAssets.count < _maxChooseNumber && asset.defaultRepresentation != nil);
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DDLogVerbose(@"need crop:%d",self.needCrop);
    UIImage *resultImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];

    if (self.needCrop) {
        UIImage *image = resultImage;
        XXPhotoCropViewController *cropVC = [[XXPhotoCropViewController alloc]initWithOriginImage:image withFinishCropBlock:^(UIImage *resultImage) {
            if (self.needFilter) {
                XXPhotoFilterViewController *filterVC = [[XXPhotoFilterViewController alloc]initWithCurrentImage:resultImage withChooseBlock:^(UIImage *resultImage) {
                    if (_chooseBlock) {
                        NSArray *chooseImages = @[resultImage];
                        if (_chooseBlock) {
                            _chooseBlock(chooseImages);
                        }
                    }
                }];
                filterVC.effectImgViewHeight = self.singleImageCropHeight;
                filterVC.isSettingHeadImage = self.isSetHeadImage;
                filterVC.title = @"选择滤镜";
                [filterVC setNextStepAction:^(NSDictionary *resultDict) {
                    if (_nextStepBlock) {
                        _nextStepBlock(resultDict);
                    }
                }];
                [self.navigationController pushViewController:filterVC animated:YES];
                [XXCommonUitil setCommonNavigationReturnItemForViewController:filterVC withBackStepAction:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                if (_chooseBlock) {
                    NSArray *resultImages = @[resultImage];
                    _chooseBlock(resultImages);
                }
            }
        }];
        cropVC.visiableHeight = self.singleImageCropHeight;
        [self.navigationController pushViewController:cropVC animated:YES];
    }else{
        if (self.needFilter) {
            UIImage *image = resultImage;
            XXPhotoFilterViewController *filterVC = [[XXPhotoFilterViewController alloc]initWithCurrentImage:image withChooseBlock:^(UIImage *resultImage) {
                if (_chooseBlock) {
                    NSArray *chooseImages = @[resultImage];
                    if (_chooseBlock) {
                        _chooseBlock(chooseImages);
                    }
                }
            }];
            filterVC.effectImgViewHeight = self.singleImageCropHeight;
            filterVC.isSettingHeadImage = self.isSetHeadImage;
            filterVC.title = @"选择滤镜";
            [filterVC setNextStepAction:^(NSDictionary *resultDict) {
                if (_nextStepBlock) {
                    _nextStepBlock(resultDict);
                }
            }];
            [self.navigationController pushViewController:filterVC animated:YES];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:filterVC withBackStepAction:^{
                if (_returnStepBlock) {
                    _returnStepBlock();
                }
            }];
        }else{
            if (_chooseBlock) {
                resultImage = [resultImage resizedImage:CGSizeMake(320,568) interpolationQuality:kCGInterpolationDefault];
                NSArray *images = [NSArray arrayWithObject:resultImage];
                _chooseBlock(images);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - next step
- (void)setNextStepAction:(XXCommonNavigationNextStepBlock)nextStepBlock
{
    _nextStepBlock = nextStepBlock;
}
- (void)setReturnStepBlock:(XXNavigationNextStepItemBlock)returnStepBlock
{
    _returnStepBlock = returnStepBlock;
}
@end
