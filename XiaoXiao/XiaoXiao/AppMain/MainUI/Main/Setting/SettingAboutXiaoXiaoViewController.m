//
//  SettingAboutXiaoXiaoViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-26.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "SettingAboutXiaoXiaoViewController.h"

@interface SettingAboutXiaoXiaoViewController ()

@end

@implementation SettingAboutXiaoXiaoViewController

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
    
    UIImageView *logoImgView = [[UIImageView alloc]init];
    logoImgView.frame = CGRectMake(99,30,122,122);
    logoImgView.image = [UIImage imageNamed:@"login_logo.png"];
    [self.view addSubview:logoImgView];
    
    UILabel *introlDuceLabel = [[UILabel alloc]init];
    introlDuceLabel.frame = CGRectMake(20,150, 280,220);
    introlDuceLabel.backgroundColor = [UIColor clearColor];
    introlDuceLabel.numberOfLines = 0;
    introlDuceLabel.font = [UIFont systemFontOfSize:15];
    introlDuceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:introlDuceLabel];
    introlDuceLabel.text = @"学霸是基于校园的陌生人交友神器。核心服务用户是初高中、大学的在校学生 , 在学霸，每个学生都可以成为校园明星，都可以在自己熟知的领域备受关注，让每一个学生充分展示自己的优势，发挥自己的所长，解决自己的需求，学到更多的知识，是学霸的理想";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
