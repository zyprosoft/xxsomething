//
//  SettingMyXiaoXiaoGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-24.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "SettingMyXiaoXiaoGuideViewController.h"
#import "SettingAdivceViewController.h"
#import "SettingAboutXiaoXiaoViewController.h"
#import "SettingScoreLawViewController.h"

@interface SettingMyXiaoXiaoGuideViewController ()

@end

@implementation SettingMyXiaoXiaoGuideViewController

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
    _titleArray = [[NSMutableArray alloc]init];
    
    //
    NSDictionary *profileSetDict = @{@"title":@"关于学霸",@"class":@"SettingAboutXiaoXiaoViewController"};
    NSDictionary *myXiaoXiaoDict = @{@"title":@"我的学分",@"class":@"SettingScoreLawViewController"};
    NSDictionary *moveHomeDict = @{@"title":@"意见反馈",@"class":@"SettingAdivceViewController"};
    [_titleArray addObject:profileSetDict];
    [_titleArray addObject:myXiaoXiaoDict];
    [_titleArray addObject:moveHomeDict];
    
    CGFloat totalHeight = XXNavContentHeight-44;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,totalHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
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
    return _titleArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    XXBaseLabelCell *cell = (XXBaseLabelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXBaseLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.customAccessoryView.hidden = NO;
    }
    if(indexPath.row==0){
        [cell setCellType:XXBaseCellTypeTop withBottomMargin:0.f withCellHeight:46.f];
    }else if(indexPath.row== _titleArray.count-1){
        [cell setCellType:XXBaseCellTypeBottom withBottomMargin:0.f withCellHeight:46.5f];
    }else{
        [cell setCellType:XXBaseCellTypeMiddel withBottomMargin:0.f withCellHeight:45.5f];
    }
    NSDictionary *item = [_titleArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = [item objectForKey:@"title"];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[_titleArray objectAtIndex:indexPath.section]count]-1) {
        return 46.5;
    }else if(indexPath.row == 0){
        return 46;
    }else{
        return 45.5;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *item = [_titleArray objectAtIndex:indexPath.row];
    Class vcClass = NSClassFromString([item objectForKey:@"class"]);
    
    UIViewController *itemVC = [[vcClass alloc]init];
    itemVC.title = [item objectForKey:@"title"];
    [self.navigationController pushViewController:itemVC animated:YES];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:itemVC];

}


@end
