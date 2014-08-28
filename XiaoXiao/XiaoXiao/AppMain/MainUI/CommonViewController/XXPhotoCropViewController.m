//
//  XXPhotoCropViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXPhotoCropViewController.h"

@interface XXPhotoCropViewController ()

@end

@implementation XXPhotoCropViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithOriginImage:(UIImage *)originImage withFinishCropBlock:(XXPhotoCropViewControllerFinishCropBlock)finishBlock
{
    if (self = [super init]) {
        
        self.currentImage = originImage;
        _finishBlock = finishBlock;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"裁剪图片";
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    
    CGFloat totalHeight = XXNavContentHeight-44;
    
    //visiableHeight
    if (self.visiableHeight==0) {
        
        if (topVisiableHeight==0) {
            topVisiableHeight = 90;
        }
        if (bottomVisiableHeigh==0) {
            bottomVisiableHeigh = 120;
        }
        self.visiableHeight = totalHeight-topVisiableHeight-bottomVisiableHeigh;
    }else{
        CGFloat coverHeight = totalHeight-self.visiableHeight;
        topVisiableHeight = coverHeight * 2/5;
        bottomVisiableHeigh = coverHeight *3/5;
    }
    
    //progressHUD
    progressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:progressHUD];
    [progressHUD hide:YES];
    
    contentScroller = [[BFImageScroller alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,totalHeight) withTopVisiableHeight:topVisiableHeight];
    contentScroller.contentSize = CGSizeMake(contentScroller.frame.size.width,contentScroller.frame.size.height+topVisiableHeight+bottomVisiableHeigh);
    contentScroller.maximumZoomScale = 3.0f;
    contentScroller.minimumZoomScale = 1.0f;
    contentScroller.contentImageView.image = self.currentImage;
    contentScroller.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:contentScroller];
    

    
    //visiable area
    UIColor *blackColor=[UIColor blackColor];
    CGFloat  boardAlpha = 0.4;
    UIImageView *topBoard = [[UIImageView alloc]init];
    topBoard.frame = CGRectMake(0,0,self.view.frame.size.width,topVisiableHeight);
    topBoard.backgroundColor = blackColor;
    topBoard.alpha = boardAlpha;
    [self.view addSubview:topBoard];
    
    UIImageView *bottomBorad = [[UIImageView alloc]init];
    bottomBorad.frame = CGRectMake(0,totalHeight-bottomVisiableHeigh,self.view.frame.size.width,bottomVisiableHeigh);
    bottomBorad.backgroundColor = blackColor;
    bottomBorad.alpha = boardAlpha;
    [self.view addSubview:bottomBorad];
    
    CGFloat baseBottomOrign = topVisiableHeight+self.visiableHeight;
    
    //cancel button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];

    CGFloat leftMagin = (self.view.frame.size.width-100-100)/3;
    CGFloat topMargin = (bottomVisiableHeigh-40)/2;
    cancelButton.frame = CGRectMake(leftMagin,baseBottomOrign+topMargin,100,40);
    cancelButton.layer.cornerRadius = 5.0f;
    [cancelButton redStyle];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelCropAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];

    //
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseButton.frame = CGRectMake(cancelButton.frame.origin.x+cancelButton.frame.size.width+leftMagin,baseBottomOrign+topMargin,100,40);
    [chooseButton blueStyle];
    [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
    chooseButton.layer.cornerRadius = 5.0f;
    [chooseButton addTarget:self action:@selector(finishCropPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseButton];

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
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([XXCommonUitil appMainTabController]) {
        [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
        CGRect naviRect = self.navigationController.view.frame;
        self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height-49);
    }
}

#pragma mark - finish crop action
- (void)finishCropPhotoAction
{
    //获取当前的截图
    [SVProgressHUD showWithStatus:@"正在裁剪..."];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *visiableImage = [self.view imageByRenderingView];
        //截图图片始终会是定义区域的一半，所以我们需要都放大一倍
        CGImageRef cropImageRef = CGImageCreateWithImageInRect(visiableImage.CGImage,CGRectMake(0,topVisiableHeight*2,self.view.frame.size.width*2,self.visiableHeight*2));
        UIImage *cropImage = [UIImage imageWithCGImage:cropImageRef];
        if (_finishBlock) {
            _finishBlock(cropImage);
        }
        [SVProgressHUD showSuccessWithStatus:@"裁剪完成"];
    });
    
}
- (void)cancelCropAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
