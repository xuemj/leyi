//
//  FLSheZHiViewController.h
//  SheZhi
//
//  Created by tutu on 14-12-4.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FLSheZHiViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *but;
    float cacheSize;
    UITableView *tview;
}

@property (nonatomic, copy)NSString *isNewest;

@end
