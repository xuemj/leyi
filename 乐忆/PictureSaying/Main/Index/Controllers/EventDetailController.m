//
//  EventDetailController.m
//  PictureSaying
//
//  Created by tutu on 15/2/5.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "EventDetailController.h"
#import "EventDetailTableView.h"
#import "PSConfigs.h"

@interface EventDetailController ()<UIActionSheetDelegate>
{
    EventDetailTableView *tableView;
}
@end

@implementation EventDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"事件详情";
    if ([self.isMine isEqualToString:@"yes"]) {
        [self _createNavItem];
    }
    [self _initTableView];
    [self _initToolBar];
    [self _initData];
}

-(void)_createNavItem{
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(0, 0, 44, 10);
    [deleteButton setImage:[UIImage imageNamed:@"threePoint.png"] forState:UIControlStateNormal];
    deleteButton.showsTouchWhenHighlighted = YES;
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)deleteAction:(UIButton *)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

-(void)_initTableView{
    tableView = [[EventDetailTableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-50)];
    if (_model == nil) {
        tableView.mmodel = self.mmodel;
    }else{
        tableView.model = self.model;
    }
//    tableView.refreshDelegate = self;
    tableView.backgroundColor = rgb(240, 240, 240, 1);
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

-(void)_initToolBar{
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-64-50, KScreenWidth, 50)];
    [self.view addSubview:toolBar];
    
    [self addLineWithWidth:0 withHeight:0 toView:toolBar];
    
    NSArray *imgNames = @[@"gray.png",
                          @"评论.png",
                          @"share.png",
                          @"lookback.png"];
    NSString *zanCount;
    NSString *commentCount;
    if (_model == nil) {
        if (![self.mmodel.zanCount isKindOfClass:[NSNull class]]&&self.mmodel.zanCount != nil) {
            zanCount = self.mmodel.zanCount;
        }else{
            zanCount = @"0";
        }
        if (![self.mmodel.commentCount isKindOfClass:[NSNull class]]&&self.mmodel.commentCount != nil) {
            commentCount = self.mmodel.commentCount;
        }else{
            commentCount = @"0";
        }
    }else{
        if (![self.model.favNum isKindOfClass:[NSNull class]]&&self.model.favNum != nil) {
            zanCount = self.model.favNum;
        }else{
            zanCount = @"0";
        }
        if (![self.model.commentNum isKindOfClass:[NSNull class]]&&self.model.commentNum != nil) {
            commentCount = self.model.commentNum;
        }else{
            commentCount = @"0";
        }
    }
    NSArray *titleArr = @[zanCount, commentCount, @"分享", @"回顾"];
    
    CGFloat width = KScreenWidth/imgNames.count;
    CGFloat height = CGRectGetHeight(toolBar.frame);
    
    for (int i = 0; i<imgNames.count; i++) {
        NSString *imageName = imgNames[i];
        NSString *title = titleArr[i];
        
        //        定制方法一、添加Button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(i*width, 0, width, height);
        [btn setTitleColor:CommonGray forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateSelected];
            NSString *isZan = self.model.isZan;
            if ([isZan isEqualToString:@"-1"]) {
                btn.selected = NO;
            }else{
                btn.selected = YES;
            }
            if ([title isEqualToString:@"0"]) {
                [btn setTitle:@"" forState:UIControlStateNormal];
            }else{
                [btn setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateNormal];
                
            }
        }
        if (i == 1) {
            if ([title isEqualToString:@"0"]) {
                [btn setTitle:@"" forState:UIControlStateNormal];
            }else{
                [btn setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateNormal];
                
            }
        }
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        btn.titleEdgeInsets = UIEdgeInsetsMake(30, -15, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(-10, 17, 0, 0);
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:btn];
        
        if (i == 2) {
            
        }
    }
}

-(void)_initData{
    if (_model == nil) {
        tableView.data = self.mmodel.pics;
    }else{
        tableView.data = self.model.pics;
    }
    [tableView reloadData];
}

-(void)clickAction:(UIButton *)btn{
    if (btn.tag == 100) {
        [[PSConfigs shareConfigs]likeActionWithType:likeType_Event withZanButton:btn withIndexModel:nil withEventModel:self.model];
    }else if (btn.tag == 101){
        
    }else if (btn.tag == 102){
        
    }else{
        
    }
}

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
