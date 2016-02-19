//
//  BigImageController.h
//  PictureSaying
//
//  Created by tutu on 15/3/3.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "BaseViewController.h"
@class ImageDescCollectionView;
@class MainModel;

@interface BigImageController : BaseViewController
{
    ImageDescCollectionView *photoCV;
}
@property(nonatomic, retain)NSArray *urlsArr;
@property(nonatomic, retain)NSArray *data;
@property(nonatomic, retain)NSIndexPath *indexPath;
@property(nonatomic, copy)NSString *isOrder;
@property(nonatomic, copy)NSString *isMine;
@property(nonatomic, retain)MainModel *mmodel;
- (void)showOrHiddenNavigationBarAndStatusBar;
@end
