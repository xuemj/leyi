//
//  AddressBookViewController.h
//  WeTime
//
//  Created by tutu on 14/12/1.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "AddressBookViewController.h"
#import <MessageUI/MessageUI.h>
#import "BaseViewController.h"
@protocol addDelegate<NSObject>
-(void)sendToFirstView1:(NSString*)sPhone;
-(void)sendToFirstView2:(NSString*)sName;
@end
@interface AddressBookViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *contacts;
@property(nonatomic,strong)NSMutableArray *fname;
@property(nonatomic,retain)NSArray *filterData;


@property(nonatomic,weak)id<addDelegate>delegate;
@end
