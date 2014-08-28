//
//  XXGradeChooseViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXGradeChooseViewController.h"
#import "XXSchoolChooseCell.h"

@interface XXGradeChooseViewController ()

@end

@implementation XXGradeChooseViewController

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
    _gradeArray = @[@"一年级",@"二年级",@"三年级",@"四年级"];
    CGFloat totoalHeight = self.view.frame.size.height-44;
    CGFloat totalWidth = self.view.frame.size.width;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,totalWidth,totoalHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withNextStepAction:^{
        if (_nextStepBlock) {
            NSString *resultString = [_gradeArray objectAtIndex:_selectIndex];
            NSDictionary *resultDict = @{@"result":resultString};
            _nextStepBlock(resultDict);
        }
    }];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _gradeArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    XXSchoolChooseCell *cell = (XXSchoolChooseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXSchoolChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setTitle:[_gradeArray objectAtIndex:indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    if (_finishBlock) {
        _finishBlock([_gradeArray objectAtIndex:indexPath.row]);
    }
}
#pragma mark - finish block
- (void)setFinishBlock:(XXGradeChooseViewControllerFinishChooseBlock)finishBlock
{
    _finishBlock = [finishBlock copy];
}
#pragma mark - next step
- (void)setNextStepAction:(XXCommonNavigationNextStepBlock)nextStepBlock
{
    _nextStepBlock = [nextStepBlock copy];
}


@end
