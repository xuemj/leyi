//
//  HeaderViewCell.h
//  Comment
//
//  Created by tutu on 14/12/11.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Info.h"
//#import "IndexModel.h"
//#import "EventModel.h"
#import "MainModel.h"
@interface HeaderViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *_imageview;
@property (weak, nonatomic) IBOutlet UIView *MView;
@property(nonatomic, retain)Info *info;

@property (nonatomic, strong) MainModel *indexModel;
//@property (nonatomic, strong) EventModel *eventModel;

@end
