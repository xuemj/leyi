//
//  ImageDescCollectionView.h
//  PictureSaying
//
//  Created by tutu on 15/3/3.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDescCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSInteger indexPage;
}
@property(nonatomic, retain)NSArray *urlsArr;
@property(nonatomic, retain)NSArray *titles;

@end
