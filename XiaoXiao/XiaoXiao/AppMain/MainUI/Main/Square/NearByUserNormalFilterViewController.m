//
//  InSchoolUserFilterViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "NearByUserNormalFilterViewController.h"
#import "XXSegmentControl.h"
#import "XXUserFilterCell.h"
@interface NearByUserNormalFilterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_cellArray;
}

@end

@implementation NearByUserNormalFilterViewController

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
    self.title = @"附近的同学";
    
    [self loadViewAbout];
    
    _cellArray = [[NSMutableArray alloc]initWithCapacity:5];
    
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withIconImage:@"nav_share_post_setting.png" withNextStepAction:^{
        
    }];
    
}
- (void)loadViewAbout
{
    
    
    //男女选择
    NSDictionary *leftIten = @{@"title":@"不限",@"normalBack":@"segment_small_left.png",@"selectBack":@"segment_small_left_selected.png",@"normalColor":[UIColor blackColor],@"selectColor":[UIColor whiteColor]};
    
    NSDictionary *midIten = @{@"title":@"男",@"normalBack":@"segment_small_middle.png",@"selectBack":@"segment_small_middle_selected.png",@"normalColor":[UIColor blackColor],@"selectColor":[UIColor whiteColor]};
    NSDictionary *rightiten = @{@"title":@"女",@"normalBack":@"segment_small_right.png",@"selectBack":@"segment_small_right_selected.png",@"normalColor":[UIColor blackColor],@"selectColor":[UIColor whiteColor]};
    
    XXSegmentControl *segBoyGire =[[XXSegmentControl alloc]initWithFrame:CGRectMake(10, 10, 300, 47) withConfigArray:@[leftIten,midIten,rightiten]];
    segBoyGire.backgroundColor = [UIColor clearColor];
    [self.view addSubview:segBoyGire];
    
    CGFloat originY = IS_IOS_7? 0:10;
    
    UITableView * tableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 70+originY, 320, 46.5*3+46+45.5) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator  = NO;
    tableView.scrollEnabled = NO;
    tableView.layer.cornerRadius = 5;
    tableView.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
}


#pragma mark =======UITableView delegate and Datasoure Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >0&&indexPath.row<4) {
        return 46.5;
    }else if(indexPath.row == 0){
        return 46;
    }else{
        return 45.5;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellStr = @"tableViewcell";
    XXUserFilterCell * cell  =[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[XXUserFilterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        [_cellArray addObject:cell];
        
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.showItemLbl.text = @"不限";
            
            
        }
            break;
        case 1:
        {
            cell.showItemLbl.text = @"一年级";
            
        }
            break;
        case 2:
        {
            cell.showItemLbl.text = @"二年级";
            
            
        }
            break;
        case 3:
        {
            cell.showItemLbl.text = @"三年级";
            
            
        }
            break;
        case 4:
        {
            cell.showItemLbl.text = @"四年级";
            
        }
            break;
            
        default:
            break;
    }
    
    if(indexPath.row==0){
        [cell setCellType:XXBaseCellTypeTop withBottomMargin:0.f withCellHeight:46.f];
    }else if(indexPath.row>0&&indexPath.row<4){
        [cell setCellType:XXBaseCellTypeMiddel withBottomMargin:0.f withCellHeight:46.5f];
    }else{
        [cell setCellType:XXBaseCellTypeBottom withBottomMargin:0.f withCellHeight:45.5f];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
