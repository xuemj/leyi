//
//  EventDetailTableView.h
//  PictureSaying
//
//  Created by tutu on 15/2/5.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "BaseTableView.h"
#import "EventModel.h"
#import "MainModel.h"

@interface EventDetailTableView : BaseTableView
<UITableViewDataSource,UITableViewDelegate>
{
    UIView *tableHeaderView;
    UIImageView *userAva;
    UIButton *attentionButton;
    
    UILabel *userName;
    
    UIButton *zanBuuton;
    
    UILabel *zanCount;
    
    UIButton *commentBuuton;
    
    UILabel *commentCount;
    
    UIButton *shareBuuton;
    
    UILabel *dateLabel;
    UILabel *titleLabel;
    UILabel *line;
}
@property (nonatomic, retain)EventModel *model;
@property (nonatomic, retain)MainModel *mmodel;
@end
