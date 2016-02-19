//
//  GuideView.h
//  PictureSaying
//
//  Created by tutu on 15/1/10.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideView : UIView<UIScrollViewDelegate>
{
    UIImageView *pageImgView;
    NSMutableArray *pageImgs;
    NSMutableArray *imgViews;
    NSInteger index;
}

@end
