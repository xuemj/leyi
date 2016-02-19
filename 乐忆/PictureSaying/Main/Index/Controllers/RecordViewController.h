//
//  RecordViewController.h
//  PictureSaying
//
//  Created by tutu on 15/1/26.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentViewController.h"
#import "RecordTableView.h"

@interface RecordViewController : BaseViewController
<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CommentViewControllerDelegate>

{
    RecordTableView *_tableView;
    UIImageView *_tabBarImgView;
    RecordTableView *_tableView1;
    UILabel *tipLabel;
    UILabel *finishTipLabel;
}

@property(nonatomic, retain)NSMutableArray *data;
@property(nonatomic, retain)NSMutableArray *data1;
@property(nonatomic, retain)NSMutableArray *friendData;
@property(nonatomic, retain)NSMutableArray *mineData;
@end
