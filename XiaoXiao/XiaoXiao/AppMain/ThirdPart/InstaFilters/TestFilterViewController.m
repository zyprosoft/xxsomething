//
//  TestFilterViewController.m
//  InstaFilters
//
//  Created by ZYVincent on 14-1-2.
//  Copyright (c) 2014年 twitter:@diwup. All rights reserved.
//

#import "TestFilterViewController.h"
#import "AGMedallionView.h"

@interface TestFilterViewController ()

@end

@implementation TestFilterViewController

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
    UIImage *imageTest = [UIImage imageNamed:@"girl3.jpg"];
    
    _imageFilter = [[ZYImageFilter alloc]initWithSaveQuality:YES withShowEffectImageViewFrame:CGRectMake(60,100,200,200)];
    _imageFilter.rawImage = imageTest;
    [self.view addSubview:_imageFilter.gpuImageView];
    
    [_imageFilter switchFilter:IF_NASHVILLE_FILTER];
    

    UIButton *showHeadView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showHeadView.frame = CGRectMake(0,0,60,40);
    [showHeadView setTitle:@"set" forState:UIControlStateNormal];
    [showHeadView addTarget:self action:@selector(showHead) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showHeadView];
    
}
- (void)showHead
{
    AGMedallionView *headView = [[AGMedallionView alloc]init];
    headView.frame = CGRectOffset(headView.frame,headView.frame.origin.x,250);
    headView.image = [_imageFilter currentEffectImage];
    headView.borderColor = [UIColor whiteColor];
    headView.borderWidth = 3.0f;
    [self.view addSubview:headView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
