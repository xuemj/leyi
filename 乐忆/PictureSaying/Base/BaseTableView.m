//
//  BaseTableView.m
//  PictureSaying
//
//  Created by tutu on 14/12/3.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initViews];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self _initViews];
}

-(void)_initViews{
    self.delegate = self;
    self.dataSource =self;
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [self addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    _refreshFooter = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshFooter.hidden = YES;
    _refreshFooter.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _refreshFooter.backgroundColor = rgb(245, 245, 245, 1);
    _refreshFooter.titleLabel.textAlignment = 1;
    [_refreshFooter setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_refreshFooter setTitleColor:rgb(190, 190, 190, 1) forState:UIControlStateNormal];
    [_refreshFooter setTitle:@"上拉(点击)加载更多" forState:UIControlStateNormal];
    _refreshFooter.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [_refreshFooter addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
    self.tableFooterView = _refreshFooter;
    
    loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadView.frame = CGRectMake(70, 12, 20, 20);
    [loadView stopAnimating];
    [_refreshFooter addSubview:loadView];
}

-(void)loadMoreAction{
    upLoading = YES;
    _refreshFooter.enabled = NO;
    [_refreshFooter setTitle:@"正在努力加载...." forState:UIControlStateNormal];
    [loadView startAnimating];
    if (self.finishLoadMoreBlock) {
        self.finishLoadMoreBlock();
    }
    if ([self.refreshDelegate respondsToSelector:@selector(pullUp:)]) {
        [self.refreshDelegate pullUp:self];
    }
}

-(void)setIsRefresh:(BOOL)isRefresh{
    if (_isRefresh != isRefresh) {
        _isRefresh = isRefresh;
    }
    if (_isRefresh) {
        [_refreshFooter setTitle:@"上拉(点击)加载更多" forState:UIControlStateNormal];
        _refreshFooter.enabled = YES;
        upLoading = NO;
    }else{
        [_refreshFooter setTitle:@"正在加载...." forState:UIControlStateNormal];
        _refreshFooter.enabled = NO;
    }
    
    [loadView stopAnimating];
}

-(void)setIsPullDownRefresh:(BOOL)isPullDownRefresh{
    if (_isPullDownRefresh != isPullDownRefresh) {
        _isPullDownRefresh = isPullDownRefresh;
    }
    if (!_isPullDownRefresh) {
        [_refreshHeaderView removeFromSuperview];
    }
}

-(void)setData:(NSArray *)data{
    if (_data != data) {
        _data = data;
    }
    if (_data.count >= 15) {
        if (_data.count>15) {
            int ind = _data.count%15;
            if (ind<15&&ind>0) {
                _refreshFooter.enabled  = NO;
                upLoading = YES;
                _refreshFooter.frame = CGRectMake(0, 0, KScreenWidth, 1);
                self.tableFooterView = _refreshFooter;
                _refreshFooter.hidden = YES;
            }else{
                _refreshFooter.hidden = NO;
                self.isRefresh = YES;
                _refreshFooter.frame = CGRectMake(0, 0, KScreenWidth, 44);
                self.tableFooterView = _refreshFooter;
            }
        }else{
            _refreshFooter.hidden = NO;
            self.isRefresh = YES;
            _refreshFooter.frame = CGRectMake(0, 0, KScreenWidth, 44);
            self.tableFooterView = _refreshFooter;
    }
    }else{
        _refreshFooter.enabled  = NO;
        upLoading = YES;
        _refreshFooter.frame = CGRectMake(0, 0, KScreenWidth, 1);
        self.tableFooterView = _refreshFooter;
        _refreshFooter.hidden = YES;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    // Configure the cell.
    return cell;
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
    _reLoading = YES;
}

- (void)doneLoadingTableViewData{
    _reLoading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    float offSet = self.contentOffset.y + self.height - self.contentSize.height;
    if (offSet>30&&!upLoading) {
        [self loadMoreAction];
    }
}


#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    
    //停止加载，弹回下拉
    //	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    if (self.finishBlock) {
        self.finishBlock();
    }
    
    if ([self.refreshDelegate respondsToSelector:@selector(pullDone:)]) {
        [self.refreshDelegate pullDone:self];
    }
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reLoading;
    // should return if data source model is reloading
    
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date];
    // should return date data source was last changed
    
}

-(void)showLoadingView:(BOOL)show{
    if (loadingView == Nil) {
        loadingView = [[UIView alloc] initWithFrame:self.bounds];
        loadingView.backgroundColor=[UIColor grayColor];
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.width, 30)];
        loadingLabel.text = @"正在初始化数据，请稍等....";
        loadingLabel.textAlignment = 1;
        [loadingView addSubview:loadingLabel];
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(140, 150, 40, 40);
        [loadingView addSubview:activityView];
    }
    if (show) {
        [self addSubview:loadingView];
    }else{
        if (loadingView.superview) {
            [loadingView removeFromSuperview];
        }
    }
}

- (UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
    } while (next != nil);
    
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
