//
//  ImageViews.h
//  PictureSaying
//
//  Created by tutu on 14/12/18.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventModel.h"
@class MainModel;

@interface ImageViews : UIView
{
    UIImageView *iv1;
    UIImageView *iv2;
    UIImageView *iv3;
    UIImageView *iv4;
    UIImageView *iv5;
    UIImageView *iv6;
    UILabel *countLabel;
}
@property(nonatomic, retain)NSArray *pics;
@property(nonatomic, retain)NSArray *allPics;
@property(nonatomic, retain)EventModel *model;
@property(nonatomic, retain)MainModel *mmodel;
@end
