//
//  PSPhotoController.h
//  PictureSaying
//
//  Created by tutu on 15/1/6.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PSPhotoInfo.h"
#import "MDMNoDataBackground.h"

@interface PSPhotoController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView             *_mainTableView;
    MDMNoDataBackground     *_backgroundImageView;
    NSString                *_fileCachePath;
}

@property (nonatomic,strong) NSMutableArray     *photoInfoArray;

-(void)photoBrowserShowWithPhotoInfo:(PSPhotoInfo *)photoInfo withCurrentIndex:(NSInteger)currentIndex withSrcImageView:(UIImageView *)srcImageView;

@end
