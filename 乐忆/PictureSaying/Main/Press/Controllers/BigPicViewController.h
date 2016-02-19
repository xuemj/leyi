//
//  BigPicViewController.h
//  PictureSaying
//
//  Created by tutu on 15/1/4.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "BaseViewController.h"

@interface BigPicViewController : BaseViewController
@property(nonatomic, retain)NSArray *urlsArr;
@property(nonatomic, retain)NSIndexPath *indexPath;
- (void)showOrHiddenNavigationBarAndStatusBar;
@end
