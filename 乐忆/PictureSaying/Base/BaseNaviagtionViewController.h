//
//  BaseNaviagtionViewController.h
//  SnsSend
//
//  Created by tutu on 14-10-29.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNaviagtionViewController : UINavigationController
{
    UIPanGestureRecognizer *_pan;
    //动画时间
    double animationTime;
}

@property (nonatomic,assign) BOOL canDragBack;
@end
