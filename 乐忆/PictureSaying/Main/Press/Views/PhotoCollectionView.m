//
//  PhotoCollectionView.m
//  PictureSaying
//
//  Created by tutu on 15/1/4.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "PhotoCollectionView.h"
#import "MyPhotoLookCell.h"
#import "PhotoScrollView.h"
#import "BigPicViewController.h"
#import <UIKit/UIKit.h>

@implementation PhotoCollectionView

{
    NSString *identifier;
}
- (id)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(KScreenWidth, KScreenHeight-64);
    flowLayout.minimumLineSpacing = 0;
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.dataSource = self;
        self.pagingEnabled = YES;
        identifier = @"myPhotoCell";
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor colorWithRed:251/255.0 green:248/255.0 blue:241/255.0 alpha:1.0];
        self.backgroundColor = [UIColor blackColor];
        [self registerClass:[MyPhotoLookCell class] forCellWithReuseIdentifier:identifier];
    }
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.urlsArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyPhotoLookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = rgb(137, 137, 137, 1);
    cell.url = self.urlsArr[indexPath.row];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    MyPhotoLookCell *mpcell = (MyPhotoLookCell *)cell;
    [mpcell.photoSV setZoomScale:1 animated:NO];
    
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    self.getLookingVC.title = [NSString stringWithFormat:@"%d/%d",indexPath.row+1,self.urlsArr.count];
}

-(BigPicViewController *)getLookingVC{
    UIResponder *nextResponder = self.nextResponder;
    do {
        if ([nextResponder isMemberOfClass:[BigPicViewController class]]) {
            return (BigPicViewController *)nextResponder;
        }
        nextResponder = nextResponder.nextResponder;
    } while (nextResponder);
    return Nil;
}

@end
