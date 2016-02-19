//
//  SelectStoryViewController.h
//  SelectStory
//
//  Created by tutu on 14/12/10.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SelectStoryViewController : BaseViewController

@property(nonatomic,strong)NSMutableArray *arr;
@property(nonatomic, copy)NSString *storyName;
@property(nonatomic, retain)NSDictionary *storyDic;

@end
