//
//  BaseTableView.h
//  PictureSaying
//
//  Created by tutu on 14/12/3.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
typedef void (^PullDownFinish) (void);
typedef void (^PullUpFinish) (void);
@class BaseTableView;
@protocol BaseTableViewDelegate <NSObject>

@optional
//下拉刷新
- (void)pullDone:(BaseTableView *)tableView;

//上拉加载
- (void)pullUp:(BaseTableView *)tableView;


@end
@interface BaseTableView : UITableView<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    UIView *loadingView;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reLoading;
    @public
    UIButton *_refreshFooter;
    BOOL upLoading;
    UIActivityIndicatorView *loadView;
    UILabel *finishTipLabel;
}

@property (nonatomic, weak) id<BaseTableViewDelegate> refreshDelegate;
@property(nonatomic, strong)NSArray *data;
@property(nonatomic, copy)PullDownFinish finishBlock;
@property(nonatomic, copy)PullUpFinish finishLoadMoreBlock;
@property(nonatomic, assign)BOOL isRefresh;
@property(nonatomic, assign)BOOL isPullDownRefresh;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
-(void)showLoadingView:(BOOL)show;
- (UIViewController *)viewController;

@end
