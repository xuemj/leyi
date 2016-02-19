//
//  ImageDescCollectionView.m
//  PictureSaying
//
//  Created by tutu on 15/3/3.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "ImageDescCollectionView.h"
#import "ImageCollectionViewCell.h"
#import "ImageScrollView.h"
#import "BigImageController.h"

@implementation ImageDescCollectionView

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
        identifier = @"imageCell";
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor colorWithRed:251/255.0 green:248/255.0 blue:241/255.0 alpha:1.0];
        self.backgroundColor = [UIColor blackColor];
        [self registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.urlsArr[section] count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.urlsArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.row = indexPath.row;
    cell.backgroundColor = rgb(137, 137, 137, 1);
    if (indexPath.row == 0) {
        NSLog(@"%d",indexPath.section);
        cell.title = self.titles[indexPath.section];
    }else{
        cell.title = @"";
    }
    cell.url = [self.urlsArr[indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell *mpcell = (ImageCollectionViewCell *)cell;
    [mpcell.photoSV setZoomScale:1 animated:NO];
    
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[self.urlsArr[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"time"] floatValue]/1000];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *regStr = [df stringFromDate:date];
    self.getLookingVC.title = regStr;
}

-(BigImageController *)getLookingVC{
    UIResponder *nextResponder = self.nextResponder;
    do {
        if ([nextResponder isMemberOfClass:[BigImageController class]]) {
            return (BigImageController *)nextResponder;
        }
        nextResponder = nextResponder.nextResponder;
    } while (nextResponder);
    return Nil;
}

@end
