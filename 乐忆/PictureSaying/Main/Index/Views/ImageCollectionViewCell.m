//
//  ImageCollectionViewCell.m
//  PictureSaying
//
//  Created by tutu on 15/3/3.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#import "ImageScrollView.h"
#import "PSConfigs.h"

@implementation ImageCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self _initView];
    }
    return self;
}

-(void)_initView{
    
    _photoSV = [[ImageScrollView alloc] initWithFrame:CGRectZero];
    _photoSV.backgroundColor = [UIColor colorWithRed:251/255.0 green:248/255.0 blue:241/255.0 alpha:1.0];
    [self.contentView addSubview:_photoSV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [_photoSV addGestureRecognizer:tap];
    
    _eventDesc = [[UILabel alloc] initWithFrame:CGRectZero];
    _eventDesc.textColor = [UIColor whiteColor];
//    _eventDesc.backgroundColor = [UIColor blackColor];
    _eventDesc.font = [UIFont systemFontOfSize:15.0];
    _eventDesc.numberOfLines = 0;
    [self.contentView addSubview:_eventDesc];
    
    _labBG = [[UIImageView alloc] initWithFrame:CGRectZero];
    _labBG.image = [UIImage imageNamed:@"bigbgimage.png"];
    [self.contentView addSubview:_labBG];
    
    _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _descLabel.textColor = [UIColor whiteColor];
    _descLabel.font = [UIFont systemFontOfSize:13.0];
    _descLabel.numberOfLines = 0;
    [_labBG addSubview:_descLabel];
    
}

-(void)singleTap:(UITapGestureRecognizer *)tap{
//    if (_labBG.hidden) {
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            _labBG.alpha = 1;
//            
//        } completion:^(BOOL finished) {
//            _labBG.hidden = NO;
//        }];
//    }else{
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            _labBG.alpha = 0;
//            
//        } completion:^(BOOL finished) {
//            _labBG.hidden = YES;
//        }];
//    }
   
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    _eventDesc.hidden = !_eventDesc.hidden;
    _labBG.hidden = !_labBG.hidden;
    [UIView commitAnimations];
}

-(void)setUrl:(NSDictionary *)url{
    if (_url != url) {
        _url = url;
    }
    _photoSV.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64);
    NSString *path = [_url objectForKey:@"path"];
    NSArray *imageSize = [path componentsSeparatedByString:@"_"];
    NSString *sizestring = [NSString stringWithFormat:@"_compression_%@_%@",imageSize[1],imageSize[2]];
    path = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:path]];
    path = [NSMutableString stringWithString:[path stringByAppendingString:sizestring]];
    _photoSV.imgUrl = [NSURL URLWithString:path];
    NSString *desc;
    _eventDesc.frame = CGRectMake(10, 20, KScreenWidth-20, 50);
    _eventDesc.text = self.title;
    
    if ([[url objectForKey:@"txt"] isKindOfClass:[NSNull class]]) {
        desc = @"";
//        _labBG.hidden = YES;
    }else{
        desc = [url objectForKey:@"txt"];
    }
//    CGSize size = [desc sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(KScreenWidth-40, 1000)];
    _labBG.frame = CGRectMake(0, self.height-KScreenWidth*264/640, KScreenWidth, KScreenWidth*264/640);
    _descLabel.frame = CGRectMake(10, 15, KScreenWidth-20, _labBG.height-30);
    _descLabel.text = desc;
    _labBG.hidden = NO;
    _eventDesc.hidden = NO;

}
@end
