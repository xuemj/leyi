//
//  EventCell.h
//  PictureSaying
//
//  Created by tutu on 14/12/17.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventModel.h"
#import "ImageViews.h"
//#import "IndexModel.h"
#import "MainModel.h"

@interface EventCell : UITableViewCell<UIAlertViewDelegate>
{
    __weak IBOutlet UILabel *_dateLabel;
    __weak IBOutlet UILabel *_eventTitleLabel;
    __weak IBOutlet UIButton *_writeButton;
    __weak IBOutlet UIButton *_deleteButton;
    __weak IBOutlet UIButton *_zanButton;
    __weak IBOutlet UIButton *_commentButton;
    __weak IBOutlet UIButton *_shareBuuton;
    ImageViews *imageViews;
    __weak IBOutlet UIImageView *_radisIV;
    __weak IBOutlet UIImageView *_lineIV;
    __weak IBOutlet UILabel *_bottomLine;
    __weak IBOutlet UILabel *oneLine;
    __weak IBOutlet UILabel *twoLine;
}
@property(nonatomic, retain)NSArray *allPics;
@property(nonatomic, strong)MainModel *indexModel;
@property(nonatomic, strong)EventModel *model;
@property(nonatomic, strong)NSString *storyId;
@property(nonatomic, strong)NSString *writable;
@property(nonatomic, strong)NSNumber *row;
@property(nonatomic, strong)UIViewController    *viewController;

@end
