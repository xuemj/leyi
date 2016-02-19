//
//  EventDetailController.h
//  PictureSaying
//
//  Created by tutu on 15/2/5.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "BaseViewController.h"
#import "EventModel.h"
#import "MainModel.h"

@interface EventDetailController : BaseViewController
@property (nonatomic, retain)EventModel *model;
@property (nonatomic, retain)MainModel *mmodel;
@property (nonatomic, retain)NSString *isMine;

@end
