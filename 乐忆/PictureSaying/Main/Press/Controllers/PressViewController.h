//
//  PressViewController.h
//  PictureSaying
//
//  Created by tutu on 14/12/3.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "BaseViewController.h"
#import "MyPhotos.h"

@interface PressViewController : BaseViewController<UIAlertViewDelegate,
UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
    UIButton *butt;
    UILabel *biaotiLabel;
    UILabel *timaLabel;
    UIButton *tianjiaHaoyou;
    
@public
    UITableView *tabView;
    NSMutableArray *dataArray;
    NSDictionary *diccc;
    NSString *ShijianString;
    NSIndexPath *ip;
    MyPhotos *localModel;
}
@property(nonatomic, retain)NSMutableArray *data;

@property(nonatomic,retain)NSString *ChuanZhiId;

-(void)reloadtvData:(NSMutableArray *)data1;

@end
