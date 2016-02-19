//
//  SelectStoryViewController.m
//  SelectStory
//
//  Created by tutu on 14/12/10.
//  Copyright (c) 2014年 tutu. All rights reserved.
//  选择故事

#import "SelectStoryViewController.h"
#import "AppDelegate.h"
#import "StoryCell.h"
#import "NewStroryViewController.h"
#import "DataService.h"
#import "CreateStoryViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define ios7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
@interface SelectStoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NewStroryViewController *cv;
}

@property(nonatomic,strong)UITableView *tv;

@end

@implementation SelectStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择故事";
    if (ios7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0,0,60, 44);
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"新建" forState:UIControlStateNormal ];
    [rightBtn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.arr = [NSMutableArray array];
    self.tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth ,KScreenHeight-64)];
    self.tv.rowHeight = kScreenHeight*0.1;
    self.tv.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tv.delegate = self;
    self.tv.dataSource= self;
    self.tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tv];
    self.tv.tableHeaderView = [[UIView alloc] init];
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSString *slistUrl = [NSString stringWithFormat:@"/WeiXiao/api/v1/story/list/%@",[tempDic objectForKey:@"usn"]];
    [DataService requestWithURL:slistUrl params:nil httpMethod:@"GET" block1:^(id result) {
        NSArray *array = (NSArray *)result;
        if (array.count == 0) {
        }
        else{
    
        for (NSDictionary *dic in array) {
            [self.arr addObject:dic];
        }
        [self.tv reloadData];
//        NSString *title = [result[0] objectForKey:@"title"];
            }
    } failLoad:^(id result) {
    
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
//    if (cv.str.length>0) {
//        [self.arr addObject:cv.str];
//        
//        self.tv.frame = CGRectMake(0, 0,kScreenWidth ,self.arr.count*kScreenHeight*0.1) ;
//    }
//    if (self.tv.height <= self.view.height) {
//        self.tv.scrollEnabled = NO;
//    }
//    else
//    {
//        self.tv.scrollEnabled = YES;
//    }
    if (cv.storyDic != nil) {
        NSString *title = [cv.storyDic objectForKey:@"title"];
        NSString *sid = [cv.storyDic objectForKey:@"id"];
        NSArray *keys = @[@"id",@"title"];
        NSArray *values = @[sid,title];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [self.arr addObject:dic];
        [self.tv reloadData];
    }
}

-(void)add:(UIButton*)sender
{
    CreateStoryViewController *cvc = [[CreateStoryViewController alloc]init];
    [self.navigationController pushViewController:cvc animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
//    cv = [[NewStroryViewController alloc]init];
//    [self.navigationController pushViewController:cv animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight*0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenfier = @"cell";
    StoryCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfier];
    if (!cell) {
        
         cell = [[[NSBundle mainBundle]loadNibNamed:@"StoryCell" owner:self options:nil] lastObject];
        cell.text = [self.arr[indexPath.row] objectForKey:@"title"];
        cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.storyName = [self.arr[indexPath.row] objectForKey:@"title"];
    self.storyDic = self.arr[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)backAction{
    
//    if (self.navigationController.viewControllers.count>2) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else if(self.navigationController.viewControllers.count == 2){
//        [self.navigationController popViewControllerAnimated:YES];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
//    }else{
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)
    {
        self.view = nil;
    }

    
}

@end
