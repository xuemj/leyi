//
//  StoryDetailViewController.h
//  PictureSaying
//
//  Created by tutu on 14/12/17.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "BaseViewController.h"
//#import "IndexModel.h"
#import "StroyListTableView.h"

@interface StoryDetailViewController : BaseViewController
{
    StroyListTableView *storylistTV;
    UILabel *tipNullLabel;

}
@property(nonatomic, retain)MainModel *model;
@property(nonatomic, retain)NSMutableArray *Data;
@property(nonatomic, copy)NSString *writable;
@property(nonatomic, copy)NSString *storyId;
@end
