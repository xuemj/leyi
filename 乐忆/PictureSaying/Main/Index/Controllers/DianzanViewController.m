//
//  DianzanViewController.m
//  PictureSaying
//
//  Created by shixy on 15/1/26.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "DianzanViewController.h"
#import "DianzanTableViewCell.h"
@interface DianzanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *phoneArr;
@property(nonatomic,strong)UITableView *dianZanTableView;
@end

@implementation DianzanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赞过的人";
    self.dianZanTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    self.dianZanTableView.dataSource = self;
    self.dianZanTableView.delegate = self;
    [self.view addSubview:self.dianZanTableView];
    self.dataArr = [NSMutableArray array];
    self.phoneArr = [NSMutableArray array];
    [self getList];
    
}
-(void)getList
{
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSMutableDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    
    NSString *guanzhuUrl = [NSString stringWithFormat:@"/WeiXiao/api/v1/user/userSubscriber/list/%@/0/100",[tempDic objectForKey:@"usn"]];
    [DataService requestWithURL:guanzhuUrl params:nil httpMethod:@"GET" block1:^(id result) {
        NSArray *a = (NSArray*)result;
        for (NSDictionary *d in a) {
            NSString *sPhone = [d objectForKey:@"subscriberUsn"];
            [self.phoneArr addObject:sPhone];
        }
        [self data];
    } failLoad:^(id result) {
        
    }];
}
-(void)data
{
     for(NSDictionary *dd in self.dianzanArr)
     {
         NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
         [dataDic setObject:[dd objectForKey:@"image"] forKey:@"image"];
         [dataDic setObject:[dd objectForKey:@"nickname"] forKey:@"nickname"];
         [dataDic setObject:[dd objectForKey:@"id"] forKey:@"id"];
         [dataDic setObject:[dd objectForKey:@"usn"] forKey:@"usn"];
         [dataDic setObject:[dd objectForKey:@"source"] forKey:@"source"];
         if ([self.phoneArr indexOfObject:[dd objectForKey:@"usn"]]!=NSNotFound)
         {
             [dataDic setObject:@1 forKey:@"guanzhuStatus"];
         }
         else
         {
             [dataDic setObject:@0 forKey:@"guanzhuStatus"];
         }
         [self.dataArr addObject:dataDic];
     }
    [self.dianZanTableView reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *identfier  = @"cell";
   DianzanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
    if (!cell) {
        cell = [[DianzanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    cell.myDic = self.dataArr[indexPath.row];
    cell.button.tag = indexPath.row+1;
    return cell;
    
};
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
