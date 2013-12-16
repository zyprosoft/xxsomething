//
//  UITestViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "UITestViewController.h"

@interface UITestViewController ()

@end

@implementation UITestViewController

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
    
    DTAttributedTextContentView *contentView = [[DTAttributedTextContentView alloc]init];
    contentView.frame = CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height);
    [self.view addSubview:contentView];

    NSData *htmlData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"xxshare_image_text_0" ofType:@"html"]];
    NSAttributedString *htmlString = [[NSAttributedString alloc]initWithHTMLData:htmlData documentAttributes:nil];
        
    [contentView setAttributedString:htmlString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [XXSimpleAudio playRefreshEffect];
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
