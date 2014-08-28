//
//  SquareGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "SquareGuideViewController.h"
#import "XXBaseIconLabelCell.h"
#import "InSchoolSearchUserListViewController.h"
#import "NearByUserListViewController.h"
#import "SquareShareListViewController.h"
#import "XXLeftNavItem.h"
#import "LatenceGuideViewController.h"
#import "LonelyShootViewController.h"

@interface SquareGuideViewController ()

@end

@implementation SquareGuideViewController

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
    self.view.backgroundColor=[XXCommonStyle xxThemeBackgroundColor];
    
    //left navigation item
    XXLeftNavItem *customItem = [[XXLeftNavItem alloc]initWithFrame:CGRectMake(0,0,160,44)];
    UIBarButtonItem *leftNavItem = [[UIBarButtonItem alloc]initWithCustomView:customItem];
    self.navigationItem.leftBarButtonItem = leftNavItem;
    [customItem setTitle:[XXUserDataCenter currentLoginUser].schoolName];
    [customItem setIconName:@"nav_location.png"];
    
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withNextStepAction:^{
        LatenceGuideViewController *latenceViewController = [[LatenceGuideViewController alloc]init];
        [self.navigationController pushViewController:latenceViewController animated:YES];
    } withTitle:@"潜伏"];
    
    _guideTitleArray = [[NSMutableArray alloc]init];
    //configArray
    NSMutableArray *firstSecction = [NSMutableArray array];
    NSDictionary *item0 = @{@"icon":@"cell_stroll.png",@"title":@"校内人",@"count":@"",@"class":@"InSchoolSearchUserListViewController"};
    NSDictionary *item1 = @{@"icon":@"cell_square.png",@"title":@"校说吧",@"count":@"",@"class":@"SquareShareListViewController"};
    [firstSecction addObject:item0];
    [firstSecction addObject:item1];
    
    //section 1
    NSMutableArray *secondSecction = [NSMutableArray array];
    NSDictionary *item2 = @{@"icon":@"cell_shoot.png",@"title":@"射孤独",@"count":@"",@"class":@"LonelyShootViewController"};
    NSDictionary *item3 = @{@"icon":@"cell_nearby.png",@"title":@"附近得同学",@"count":@"",@"class":@"NearByUserListViewController"};
    [secondSecction addObject:item2];
    [secondSecction addObject:item3];
    
    //
    [_guideTitleArray addObject:firstSecction];
    [_guideTitleArray addObject:secondSecction];
    
    //
    CGFloat totalHeight = self.view.frame.size.height-44;
    _guideTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,totalHeight) style:UITableViewStylePlain];
    _guideTableView.delegate = self;
    _guideTableView.dataSource = self;
    _guideTableView.backgroundColor = [UIColor clearColor];
    _guideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_guideTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _guideTitleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_guideTitleArray objectAtIndex:section]count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    XXBaseIconLabelCell *cell = (XXBaseIconLabelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        if (indexPath.section==1) {
            cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.customAccessoryView.hidden = NO;
        }else{
            cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.customAccessoryView.hidden = NO;
        }
        cell.tagLabel.font = [UIFont systemFontOfSize:15];
    }
    if (indexPath.section==1) {
        [cell setCellType:XXBaseCellTypeCornerSingle withBottomMargin:5.5f withCellHeight:57.f];
    }else if(indexPath.section==0){
        [cell setCellType:XXBaseCellTypeRoundSingle withBottomMargin:10.f withCellHeight:57.f];
    }
    
    NSDictionary *item = [[_guideTitleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [cell setContentDict:item];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,33)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [[_guideTitleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSString *className = [item objectForKey:@"class"];
    UIViewController *selectVC = [[NSClassFromString(className) alloc]init];
    [self.navigationController pushViewController:selectVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
