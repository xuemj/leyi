//
//  ImageViews.m
//  PictureSaying
//
//  Created by tutu on 14/12/18.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "ImageViews.h"
#import "UIImageView+WebCache.h"
#define ImageUrl @"http://192.168.1.200:8888/"
#import "PSConfigs.h"
//#import "DebugBigViewController.h"
#import "BigImageController.h"
#import "StoryDetailViewController.h"

@implementation ImageViews

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initViews];
    }
    return self;
}

-(void)_initViews{
    iv1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    iv1.tag = 100;
    iv1.contentMode = UIViewContentModeScaleAspectFill;
    iv1.userInteractionEnabled = YES;
    iv1.clipsToBounds = YES;
    [self addSubview:iv1];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToBigVC:)];
    [iv1 addGestureRecognizer:tap1];

    iv2 = [[UIImageView alloc] initWithFrame:CGRectZero];
    iv2.tag = 101;
    iv2.contentMode = UIViewContentModeScaleAspectFill;
    iv2.userInteractionEnabled = YES;
    iv2.clipsToBounds = YES;
    [self addSubview:iv2];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToBigVC:)];
    [iv2 addGestureRecognizer:tap2];

    iv3 = [[UIImageView alloc] initWithFrame:CGRectZero];
    iv3.tag = 102;
    iv3.contentMode = UIViewContentModeScaleAspectFill;
    iv3.userInteractionEnabled = YES;
    iv3.clipsToBounds = YES;
    [self addSubview:iv3];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToBigVC:)];
    [iv3 addGestureRecognizer:tap3];

    iv4 = [[UIImageView alloc] initWithFrame:CGRectZero];
    iv4.tag = 103;
    iv4.contentMode = UIViewContentModeScaleAspectFill;
    iv4.userInteractionEnabled = YES;
    iv4.clipsToBounds = YES;
    [self addSubview:iv4];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToBigVC:)];
    [iv4 addGestureRecognizer:tap4];

    iv5 = [[UIImageView alloc] initWithFrame:CGRectZero];
    iv5.tag = 104;
    iv5.contentMode = UIViewContentModeScaleAspectFill;
    iv5.userInteractionEnabled = YES;
    iv5.clipsToBounds = YES;
    [self addSubview:iv5];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToBigVC:)];
    [iv5 addGestureRecognizer:tap5];

    iv6 = [[UIImageView alloc] initWithFrame:CGRectZero];
    iv6.tag = 105;
    iv6.contentMode = UIViewContentModeScaleAspectFill;
    iv6.userInteractionEnabled = YES;
    iv6.clipsToBounds = YES;
    [self addSubview:iv6];
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToBigVC:)];
    [iv6 addGestureRecognizer:tap6];

    countLabel = [[UILabel alloc] init];
    countLabel.textAlignment = 1;
    countLabel.layer.cornerRadius = 3;
    countLabel.layer.masksToBounds = YES;
    countLabel.backgroundColor = [UIColor blackColor];
    countLabel.alpha = 0.7;
    countLabel.font = [UIFont systemFontOfSize:14.0];
    countLabel.textColor = [UIColor whiteColor];
    [iv6 addSubview:countLabel];
}

-(void)pushToBigVC:(UITapGestureRecognizer *)tap{
    
//    DebugBigViewController *debugBigVC = [[DebugBigViewController alloc] init];
//    debugBigVC.eModel = self.model;
    if (self.pics.count>0) {
        BigImageController *debugBigVC = [[BigImageController alloc] init];
        debugBigVC.mmodel = self.mmodel;
        if ([self.viewController.writable isEqualToString:@"yes"]) {
            debugBigVC.isMine = @"yes";
        }else{
            debugBigVC.isMine = @"NO";
        }
        debugBigVC.data = self.allPics;
        debugBigVC.data = self.viewController.Data;
        NSMutableArray *allPics = [NSMutableArray array];
        for (EventModel *model in self.viewController.Data) {
            //        [allPics addObjectsFromArray:model.pics];
            [allPics addObject:model.pics];
        }
        UIImageView *tapView = (UIImageView *)tap.view;
        NSString *path = [self.pics[tapView.tag-100] objectForKey:@"path"];
        NSInteger section = [allPics indexOfObject:self.pics];
        NSArray *dic = allPics[section];
        NSInteger row = 0;
        for (int i = 0; i<dic.count; i++) {
            NSString *urlstring = [dic[i] objectForKey:@"path"];
            if (![urlstring isKindOfClass:[NSNull class]]) {
                if ([path isEqualToString:urlstring]) {
                    row = i;
                    break;
                }else{
                    row = 0;
                }
            }else{
                row = 0;
            }
        }
        
        NSIndexPath *ip = [NSIndexPath indexPathForItem:row inSection:section];
        debugBigVC.indexPath = ip;
        [self.viewController.navigationController pushViewController:debugBigVC animated:YES];
    }
    
}

-(StoryDetailViewController *)viewController{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[StoryDetailViewController class]]) {
            return (StoryDetailViewController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
}

-(void)setPics:(NSArray *)pics{
    if (_pics != pics) {
        _pics = pics;
        
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_pics.count == 0) {
        iv1.image = nil;
        iv2.image = nil;
        iv3.image = nil;
        iv4.image = nil;
        iv5.image = nil;
        iv5.image = nil;
        iv6.image = nil;
        countLabel.hidden = YES;
    }
    if (_pics.count == 1) {
        iv1.image = [UIImage imageNamed:@"noDataShow.png"];
        if (![[_pics[0] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[0] objectForKey:@"path"] withCount:1] objectAtIndex:1];
            NSNumber *imageHeight = [[self imageUrl:[_pics[0] objectForKey:@"path"] withCount:1] objectAtIndex:0];
            if ([imageHeight isEqual:@338]) {
                iv1.frame = CGRectMake(0, 0, self.width, 9*self.width/16);
            }else{
                iv1.frame = CGRectMake(0, 0, self.width, 3*self.width/4);
            }
            [iv1 sd_setImageWithURL:imageUrl];
        }
        iv2.image = nil;
        iv3.image = nil;
        iv4.image = nil;
        iv5.image = nil;
        iv6.image = nil;
        countLabel.hidden = YES;
    }else if (_pics.count == 2){
        iv1.frame = CGRectMake(0, 0, (self.width-10)/2, 3*((self.width-10)/2)/4);
        iv1.image = [UIImage imageNamed:@"noDataShow.png"];
        if (![[_pics[0] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[0] objectForKey:@"path"] withCount:2] objectAtIndex:1];
            [iv1 sd_setImageWithURL:imageUrl];
        }
        iv2.frame = CGRectMake(iv1.right+10, 0, (self.width-10)/2, 3*((self.width-10)/2)/4);
        iv2.image = [UIImage imageNamed:@"noDataShow.png"];
        if (![[_pics[1] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[1] objectForKey:@"path"] withCount:2] objectAtIndex:1];
            [iv2 sd_setImageWithURL:imageUrl];
        }
        iv3.image = nil;
        iv4.image = nil;
        iv5.image = nil;
        iv6.image = nil;
        countLabel.hidden = YES;
    }else if (_pics.count == 3){
        iv1.frame = CGRectMake(0, 0, (self.width-20)/3, (self.width-20)/3);
        if (![[_pics[0] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[0] objectForKey:@"path"] withCount:3] objectAtIndex:1];
            [iv1 sd_setImageWithURL:imageUrl];
        }
        iv2.frame = CGRectMake(iv1.right+10, 0, (self.width-20)/3, (self.width-20)/3);
        if (![[_pics[1] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[1] objectForKey:@"path"] withCount:3] objectAtIndex:1];
            [iv2 sd_setImageWithURL:imageUrl];
        }
        iv3.frame = CGRectMake(iv2.right+10, 0, (self.width-20)/3, (self.width-20)/3);
        if (![[_pics[2] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[2] objectForKey:@"path"] withCount:3] objectAtIndex:1];
            [iv3 sd_setImageWithURL:imageUrl];
        }
        iv4.image = nil;
        iv5.image = nil;
        iv6.image = nil;
        countLabel.hidden = YES;
    }else if (_pics.count == 4){
        iv1.frame = CGRectMake(0, 0, (self.width-10)/2, 3*((self.width-10)/2)/4);
        if (![[_pics[0] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[0] objectForKey:@"path"] withCount:4] objectAtIndex:1];
            [iv1 sd_setImageWithURL:imageUrl];
        }
        iv2.frame = CGRectMake(iv1.right+10, 0, (self.width-10)/2, 3*((self.width-10)/2)/4);
        if (![[_pics[1] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[1] objectForKey:@"path"] withCount:4] objectAtIndex:1];
            [iv2 sd_setImageWithURL:imageUrl];
        }
        iv3.frame = CGRectMake(0, iv2.bottom+10, (self.width-10)/2, 3*((self.width-10)/2)/4);
        if (![[_pics[2] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[2] objectForKey:@"path"] withCount:4] objectAtIndex:1];
            [iv3 sd_setImageWithURL:imageUrl];
        }
        iv4.frame = CGRectMake(iv1.right+10, iv2.bottom+10, (self.width-10)/2, 3*((self.width-10)/2)/4);
        if (![[_pics[3] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[3] objectForKey:@"path"] withCount:4] objectAtIndex:1];
            [iv4 sd_setImageWithURL:imageUrl];
        }
        iv5.image = nil;
        iv6.image = nil;
        countLabel.hidden = YES;
    }else if (_pics.count == 5){
        iv1.frame = CGRectMake(0, 0, (self.width-20)/3, (self.width-20)/3);
        if (![[_pics[0] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[0] objectForKey:@"path"] withCount:5] objectAtIndex:1];
            [iv1 sd_setImageWithURL:imageUrl];
        }
        iv2.frame = CGRectMake(iv1.right+10, 0, (self.width-20)/3, (self.width-20)/3);
        if (![[_pics[1] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[1] objectForKey:@"path"] withCount:5] objectAtIndex:1];
            [iv2 sd_setImageWithURL:imageUrl];
        }
        iv3.frame = CGRectMake(iv2.right+10, 0, (self.width-20)/3, (self.width-20)/3);
        if (![[_pics[2] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[2] objectForKey:@"path"] withCount:5] objectAtIndex:1];
            [iv3 sd_setImageWithURL:imageUrl];
        }
        iv4.frame = CGRectMake(0, iv2.bottom+10, (self.width-20)/3, (self.width-20)/3);
        if (![[_pics[3] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[3] objectForKey:@"path"] withCount:5] objectAtIndex:1];
            [iv4 sd_setImageWithURL:imageUrl];
        }
        iv5.frame = CGRectMake(iv4.right+10, iv2.bottom+10, (self.width-20)/3, (self.width-20)/3);
        if (![[_pics[4] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[4] objectForKey:@"path"] withCount:5] objectAtIndex:1];
            [iv5 sd_setImageWithURL:imageUrl];
        }
        iv6.image = nil;
        countLabel.hidden = YES;
    }else if (_pics.count > 5){
        iv1.frame = CGRectMake(0, 0, (self.width-20)/3, (self.width-20)/3);
        if (![[_pics[0] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[0] objectForKey:@"path"] withCount:5] objectAtIndex:1];
            [iv1 sd_setImageWithURL:imageUrl];
        }
        iv2.frame = CGRectMake(iv1.right+10, 0, (self.width-20)/3, (self.width-20)/3);
        if (![[_pics[1] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[1] objectForKey:@"path"] withCount:5] objectAtIndex:1];
            [iv2 sd_setImageWithURL:imageUrl];
        }
        iv3.frame = CGRectMake(iv2.right+10, 0, (self.width-20)/3, (self.width-20)/3);
        if (![[_pics[2] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[2] objectForKey:@"path"] withCount:5] objectAtIndex:1];
            [iv3 sd_setImageWithURL:imageUrl];
        }
        iv4.frame = CGRectMake(0, iv2.bottom+10, (self.width-20)/3, (self.width-20)/3);
        if (![[_pics[3] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[3] objectForKey:@"path"] withCount:5] objectAtIndex:1];
            [iv4 sd_setImageWithURL:imageUrl];
        }
        iv5.frame = CGRectMake(iv4.right+10, iv2.bottom+10, (self.width-20)/3, (self.width-20)/3);
        if (![[_pics[4] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[4] objectForKey:@"path"] withCount:5] objectAtIndex:1];
            [iv5 sd_setImageWithURL:imageUrl];
        }
        iv6.frame = CGRectMake(iv5.right+10, iv2.bottom+10, (self.width-20)/3, (self.width-20)/3);
        if (![[_pics[5] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [[self imageUrl:[_pics[5] objectForKey:@"path"] withCount:5] objectAtIndex:1];
            [iv6 sd_setImageWithURL:imageUrl];
            if (_pics.count>6) {
                countLabel.hidden = NO;
                countLabel.frame = CGRectMake(((self.width-20)/3)-50, ((self.width-20)/3)-30, 40, 20);
                countLabel.text = [NSString stringWithFormat:@"%d图",_pics.count];
            }
        }
    }
}

-(NSArray *)imageUrl:(NSString *)path withCount:(NSInteger)count{
    //[_pics[4] objectForKey:@"path"]
    NSMutableString *imageUrl;
    NSInteger imageHeight;
    if ([path rangeOfString:@"http:"].location != NSNotFound) {
        imageUrl = [[NSMutableString alloc] initWithString:path];
        imageUrl = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:imageUrl]];
        NSArray *separatedUrl = [imageUrl componentsSeparatedByString:@"_"];
        NSInteger imageWidth = [separatedUrl[1] integerValue];
        NSInteger imageHeight1 = [separatedUrl[2] integerValue];
        if (count == 1) {
            if (imageWidth<imageHeight1) {
                imageUrl = [NSMutableString stringWithString:[imageUrl stringByAppendingString:kImage338]];
                imageHeight = 338;
            }else{
                imageUrl = [NSMutableString stringWithString:[imageUrl stringByAppendingString:kImage422]];
                imageHeight = 422;
            }
        }else if (count == 2){
            imageUrl = [NSMutableString stringWithString:[imageUrl stringByAppendingString:kImage207]];
            imageHeight = 207;
        }else if (count == 3){
            imageUrl = [NSMutableString stringWithString:[imageUrl stringByAppendingString:kImage180]];
            imageHeight = 108;
        }else if (count == 4){
            imageUrl = [NSMutableString stringWithString:[imageUrl stringByAppendingString:kImage207]];
            imageHeight = 207;
        }else{
            imageUrl = [NSMutableString stringWithString:[imageUrl stringByAppendingString:kImage180]];
            imageHeight = 108;
        }
    }else{
        imageUrl = [[NSMutableString alloc] initWithString:@""];
    }
    NSArray *imageInfo = @[[NSNumber numberWithInteger:imageHeight],[NSURL URLWithString:imageUrl]];
    return imageInfo;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    if (_pics.count == 0) {
//        iv1.image = nil;
//        iv2.image = nil;
//        iv3.image = nil;
//        iv4.image = nil;
//        iv5.image = nil;
//    }
//    if (_pics.count == 1) {
//        iv1.frame = CGRectMake(0, 0, (self.width-20)/3, (self.width-20)/3);
//        iv1.image = [UIImage imageNamed:@"noDataShow@2x.png"];
//        if (![[_pics[0] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            
//            if ([[_pics[0] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[0] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                NSLog(@"1111%@",urlHaha);
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                NSLog(@"2222%@",urlHaha);
//                [iv1 sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
//            }else{
//                [iv1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[0] objectForKey:@"path"]]]];
//            }
//        }
//    }else if (_pics.count == 2){
//        iv1.frame = CGRectMake(0, 0, (self.width-20)/3, (self.width-20)/3);
//        iv1.image = [UIImage imageNamed:@"noDataShow@2x.png"];
//        if (![[_pics[0] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            if ([[_pics[0] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[0] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                NSLog(@"%@",urlHaha);
//                [iv1 sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
//            }else{
//                [iv1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[0] objectForKey:@"path"]]]];
//            }
//        }
//        iv2.frame = CGRectMake(iv1.right+10, 0, (self.width-20)/3, (self.width-20)/3);
//        iv2.image = [UIImage imageNamed:@"noDataShow@2x.png"];
//        if (![[_pics[1] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            if ([[_pics[1] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[1] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                [iv2 sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
//            }else{
//                [iv2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[1] objectForKey:@"path"]]]];
//            }
//        }
//    }else if (_pics.count == 3){
//        iv1.frame = CGRectMake(0, 0, (self.width-20)/3, (self.width-20)/3);
//        if (![[_pics[0] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            if ([[_pics[0] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[0] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                [iv1 sd_setImageWithURL:[NSURL URLWithString:
//                                         urlHaha]];
//            }else{
//                [iv1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[0] objectForKey:@"path"]]]];
//            }
//        }
//        iv2.frame = CGRectMake(iv1.right+10, 0, (self.width-20)/3, (self.width-20)/3);
//        if (![[_pics[1] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            if ([[_pics[1] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[1] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                [iv2 sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
//            }else{
//                [iv2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[1] objectForKey:@"path"]]]];
//            }
//        }
//        iv3.frame = CGRectMake(iv2.right+10, 0, (self.width-20)/3, (self.width-20)/3);
//        if (![[_pics[2] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            if ([[_pics[2] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[2] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                [iv3 sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
//            }else{
//                [iv3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[2] objectForKey:@"path"]]]];
//            }
//        }
//    }else if (_pics.count == 4){
//        iv1.frame = CGRectMake(0, 0, (self.width-20)/3, (self.width-20)/3);
//        if (![[_pics[0] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            if ([[_pics[0] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[0] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                [iv1 sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
//            }else{
//                [iv1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[0] objectForKey:@"path"]]]];
//            }
//        }
//        iv2.frame = CGRectMake(iv1.right+10, 0, (self.width-20)/3, (self.width-20)/3);
//        if (![[_pics[1] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            if ([[_pics[1] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[1] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                [iv2 sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
//            }else{
//                [iv2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[1] objectForKey:@"path"]]]];
//            }
//        }
//        iv3.frame = CGRectMake(iv2.right+10, 0, (self.width-20)/3, (self.width-20)/3);
//        if (![[_pics[2] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            if ([[_pics[2] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[2] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                [iv3 sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
//            }else{
//                [iv3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[2] objectForKey:@"path"]]]];
//            }
//        }
//        iv4.frame = CGRectMake(0, iv2.bottom+5, (self.width-20)/3, (self.width-20)/3);
//        if (![[_pics[3] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            if ([[_pics[3] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[3] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                [iv4 sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
//            }else{
//                [iv4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[3] objectForKey:@"path"]]]];
//            }
//        }
//    }else if (_pics.count == 5){
//        iv1.frame = CGRectMake(0, 0, (self.width-20)/3, (self.width-20)/3);
//        if (![[_pics[0] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            if ([[_pics[0] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[0] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                [iv1 sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
//            }else{
//                [iv1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[0] objectForKey:@"path"]]]];
//            }
//        }
//        iv2.frame = CGRectMake(iv1.right+10, 0, (self.width-20)/3, (self.width-20)/3);
//        if (![[_pics[1] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            if ([[_pics[1] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[1] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                [iv2 sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
//            }else{
//                [iv2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[1] objectForKey:@"path"]]]];
//            }
//        }
//        iv3.frame = CGRectMake(iv2.right+10, 0, (self.width-20)/3, (self.width-20)/3);
//        if (![[_pics[2] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            if ([[_pics[2] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[2] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                [iv3 sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
//            }else{
//                [iv3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[2] objectForKey:@"path"]]]];
//            }
//        }
//        iv4.frame = CGRectMake(0, iv2.bottom+5, (self.width-20)/3, (self.width-20)/3);
//        if (![[_pics[3] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            if ([[_pics[3] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[3] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                [iv4 sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
//            }else{
//                [iv4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[3] objectForKey:@"path"]]]];
//            }
//        }
//        iv5.frame = CGRectMake(iv4.right+10, iv2.bottom+5, (self.width-20)/3, (self.width-20)/3);
//        if (![[_pics[4] objectForKey:@"path"] isKindOfClass:[NSNull class]]) {
//            if ([[_pics[4] objectForKey:@"path"] rangeOfString:@"http:"].location != NSNotFound) {
//                NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:[_pics[4] objectForKey:@"path"]];
//                urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
//                urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:kImage180]];
//                [iv5 sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
//            }else{
//                [iv5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageUrl,[_pics[4] objectForKey:@"path"]]]];
//            }
//        }
//    }
//}

@end
