//
//  DiscoveryViewController.h
//  PictureSaying
//
//  Created by tutu on 14/12/3.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "BaseViewController.h"
#import "MainModel.h"
//#import "IndexTableView.h"
#import "CommentViewController.h"
#import "RecordTableView.h"
@interface DiscoveryViewController : BaseViewController<BaseTableViewDelegate,CommentViewControllerDelegate,UIScrollViewDelegate>
{
//    IndexTableView *_tableView;
//    IndexTableView *_tableView1;
    UILabel *finishTipLabel;
}

@property(nonatomic, retain)NSMutableArray *newestData;
@property(nonatomic, retain)NSMutableArray *hotestData;
@property(nonatomic, retain)NSMutableArray *recommandData;
@property(nonatomic, retain)NSMutableArray *storyData;
@property(nonatomic, retain)NSMutableArray *attentionData;
@property(nonatomic,strong) UIScrollView *mainSV;
@end
