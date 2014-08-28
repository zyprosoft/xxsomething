//
//  SettingScoreLawViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-26.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "SettingScoreLawViewController.h"

@interface SettingScoreLawViewController ()

@end

@implementation SettingScoreLawViewController

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
    
    //score
    NSString *score = [XXUserDataCenter currentLoginUser].score;
    NSString *scoreTitle = [NSString stringWithFormat:@"当前学分:%@",score];
    NSDictionary *scoreDict = @{@"title":scoreTitle,@"value":@""};
    NSArray *scoreSection = @[scoreDict];
    [_titleArray addObject:scoreSection];
    
    NSMutableArray *lowSection = [NSMutableArray array];
    NSDictionary *lawTitle = @{@"title":@"学分规则",@"count":@""};
    [lowSection addObject:lawTitle];
    
    NSDictionary *registLaw = @{@"title":@"注册成为学霸用户",@"count":@"+100"};
    [lowSection addObject:registLaw];
    
    NSDictionary *shareLaw = @{@"title":@"发表故事",@"count":@"+1/次"};
    [lowSection addObject:shareLaw];
    
    NSDictionary *careLaw = @{@"title":@"被人关心",@"count":@"+1/个"};
    [lowSection addObject:careLaw];
    
    NSDictionary *praiseLaw = @{@"title":@"故事动态被追捧",@"count":@"+1/次"};
    [lowSection addObject:praiseLaw];
    
    NSDictionary *teaseLaw = @{@"title":@"挑逗别人",@"count":@"-5/次"};
    [lowSection addObject:teaseLaw];
    
    NSDictionary *latenceLaw = @{@"title":@"潜伏",@"count":@"-10/次"};
    [lowSection addObject:latenceLaw];
    
    NSDictionary *moveLaw = @{@"title":@"搬家",@"count":@"-100/次"};
    [lowSection addObject:moveLaw];
    
    [_titleArray addObject:lowSection];
    
    CGFloat totalHeight = XXNavContentHeight-44-49;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,totalHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self requestUserDetailAction];
}

#pragma mark - request User detail
- (void)requestUserDetailAction
{
    [[XXMainDataCenter shareCenter]requestUserDetailWithDetinationUser:[XXUserDataCenter currentLoginUser] withSuccess:^(XXUserModel *detailUser) {
        
        [XXUserDataCenter loginThisUser:detailUser];
        [_titleArray removeObjectAtIndex:0];
        //score
        NSString *score = [XXUserDataCenter currentLoginUser].score;
        NSString *scoreTitle = [NSString stringWithFormat:@"当前学分:%@",score];
        NSDictionary *scoreDict = @{@"title":scoreTitle,@"value":@""};
        NSArray *scoreSection = @[scoreDict];
        [_titleArray insertObject:scoreSection atIndex:0];
        [_tableView reloadData];
        
    } withFaild:^(NSString *faildMsg) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_titleArray objectAtIndex:section]count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        static NSString *scoreCellIdentifier = @"scoreCellIdentifier";
        XXBaseCell *cell = (XXBaseCell*)[tableView dequeueReusableCellWithIdentifier:scoreCellIdentifier];
        if (!cell) {
            cell = [[XXBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:scoreCellIdentifier];
            [cell setCellType:XXBaseCellTypeRoundSingle withBottomMargin:0.f withCellHeight:47.f];
            cell.titleLabel.frame = CGRectMake(60,2,200,43);
            cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
        cell.titleLabel.text = [[[_titleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"title"];
        
        return cell;
        
    }else{
        
        static NSString *detailCellIdentifier = @"detailCellIdentifier";
        XXBaseIconLabelCell *cell = (XXBaseIconLabelCell*)[tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
        if (!cell) {
            cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailCellIdentifier];
            cell.iconImageView.hidden = YES;
            
            cell.tagLabel.frame = CGRectMake(20,3,180,40);
            cell.tagLabel.textColor = [XXCommonStyle xxThemeButtonGrayTitleColor];
            cell.detailTagLabel.textColor = [XXCommonStyle xxThemeButtonGrayTitleColor];
            cell.detailTagLabel.frame = CGRectMake(cell.frame.size.width-20-60,3,60,40);
        }
        if (indexPath.row==0) {
            cell.tagLabel.frame = CGRectMake(60,3,200,40);
            cell.tagLabel.textColor = [UIColor blackColor];
            cell.tagLabel.textAlignment = NSTextAlignmentCenter;
            cell.tagLabel.font = [UIFont systemFontOfSize:18];
        }
        if (indexPath.row==0) {
            [cell setCellType:XXBaseCellTypeTop withBottomMargin:0 withCellHeight:46];
        }else if (indexPath.row==[[_titleArray objectAtIndex:indexPath.section]count]-1){
            [cell setCellType:XXBaseCellTypeBottom withBottomMargin:0 withCellHeight:46.5];
        }else{
            [cell setCellType:XXBaseCellTypeMiddel withBottomMargin:0 withCellHeight:45.5];
        }
        [cell setContentDict:[[_titleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
        
        return cell;
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 15.f;
    }else if(section==1){
        return 15.f;
    }else{
        return 0.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 47;
    }else if(indexPath.section == 1){
        
        if (indexPath.row == [[_titleArray objectAtIndex:indexPath.section]count]-1) {
            return 46.5;
        }else if(indexPath.row == 0){
            return 46;
        }else{
            return 45.5;
        }
    }else{
        return 44.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return 20.f;
    }else{
        return 0.f;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}


@end
