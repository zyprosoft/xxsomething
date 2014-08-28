//
//  SettingGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "SettingGuideViewController.h"
#import "SettingMoveSchoolViewController.h"
#import "SettingMyProfileGuideViewController.h"
#import "XXSchoolSearchViewController.h"
#import "SettingMyXiaoXiaoGuideViewController.h"

@interface SettingGuideViewController ()

@end

@implementation SettingGuideViewController

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
    NSDictionary *profileSetDict = @{@"title":@"资料设置",@"class":@""};
    NSDictionary *myXiaoXiaoDict = @{@"title":@"我的学霸",@"class":@""};
    NSDictionary *moveHomeDict = @{@"title":@"校园搬家",@"class":@""};
    [_titleArray addObject:profileSetDict];
    [_titleArray addObject:myXiaoXiaoDict];
    [_titleArray addObject:moveHomeDict];
    
    CGFloat totalHeight = XXNavContentHeight-44;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,totalHeight-152) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIButton *loginOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOutButton.frame = CGRectMake(10,182,self.view.frame.size.width-20,44);
    [loginOutButton blueStyle];
    [loginOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginOutButton setTitle:@"退出当前登陆" forState:UIControlStateNormal];
    [loginOutButton addTarget:self action:@selector(loginOutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginOutButton];
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
    return 20.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[_titleArray objectAtIndex:indexPath.section]count]-1) {
        return 46.5;
    }else if(indexPath.row == 0){
        return 46;
    }else{
        return 45.5f;
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

    if (indexPath.row==0) {
        SettingMyProfileGuideViewController *profileVC = [[SettingMyProfileGuideViewController alloc]init];
        [self.navigationController pushViewController:profileVC animated:YES];
        [XXCommonUitil setCommonNavigationReturnItemForViewController:profileVC];

    }
    if (indexPath.row==1) {
        SettingMyXiaoXiaoGuideViewController *myXiaoXiaoVC = [[SettingMyXiaoXiaoGuideViewController alloc]init];
        myXiaoXiaoVC.title = @"我的校校";
        [self.navigationController pushViewController:myXiaoXiaoVC animated:YES];
        [XXCommonUitil setCommonNavigationReturnItemForViewController:myXiaoXiaoVC];
    }
    if (indexPath.row==2) {
        SettingMoveSchoolViewController *moveSchoolVC = [[SettingMoveSchoolViewController alloc]init];
        moveSchoolVC.title = @"校园搬家";
        [moveSchoolVC setNextStepAction:^(NSDictionary *resultDict) {
            
            XXSchoolModel *chooseSchool = [resultDict objectForKey:@"result"];
            
            [[XXMainDataCenter shareCenter]requestMoveHomeWithDestinationSchool:chooseSchool withSuccess:^(NSString *successMsg) {
                
                XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
                cUser.schoolId = chooseSchool.schoolId;
                cUser.schoolName = chooseSchool.schoolName;
                [XXUserDataCenter loginThisUser:cUser];
                [[XXUserCacheCenter shareCenter]saveStrolledSchool:chooseSchool];//save for history
                
                [SVProgressHUD showSuccessWithStatus:@"搬家成功"];

                //post noti
                [[NSNotificationCenter defaultCenter]postNotificationName:XXUserHasMoveHomeSchoolNoti object:chooseSchool];
                [self.navigationController popViewControllerAnimated:YES];
                
            } withFaild:^(NSString *faildMsg) {
                [SVProgressHUD showErrorWithStatus:@"搬家失败"];
            }];
            
        } withNextStepTitle:@"搬家"];
        [self.navigationController pushViewController:moveSchoolVC animated:YES];
        [XXCommonUitil setCommonNavigationReturnItemForViewController:moveSchoolVC];
    }
    
}

- (void)loginOutAction
{
    [[XXCommonUitil appDelegate]loginOut];
}

@end
