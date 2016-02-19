//
//  EventDetailCell.m
//  PictureSaying
//
//  Created by tutu on 15/2/5.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "EventDetailCell.h"
#import "PSConfigs.h"

@implementation EventDetailCell

- (void)awakeFromNib {
    // Initialization code
    [self _initViews];
}

-(void)_initViews{
    _aImage.contentMode = UIViewContentModeScaleAspectFill;
    _aImage.image = [UIImage imageNamed:@"noDataShow.png"];
    _aImage.backgroundColor = rgb(221, 221, 221, 1);
    _picDesc.font = [UIFont systemFontOfSize:14.0];
    _picDesc.textColor = rgb(87, 87, 87, 1);
    _picDesc.numberOfLines = 0;
    
}

-(void)setPicDic:(NSDictionary *)picDic{
    if (_picDic != picDic) {
        _picDic = picDic;
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSArray *imageInfo = [self imageUrl:[_picDic objectForKey:@"path"]];
    if ([imageInfo[0] isEqual:@338]) {
        _aImage.frame = CGRectMake(0, 0, KScreenWidth, 9*KScreenWidth/16);
    }else{
        _aImage.frame = CGRectMake(0, 0, KScreenWidth, 3*KScreenWidth/4);
    }
    [_aImage sd_setImageWithURL:imageInfo[1]];
    NSString *picDesc = [_picDic objectForKey:@"txt"];
    CGSize descSize;
    if (![picDesc isKindOfClass:[NSNull class]]) {
        descSize = [picDesc sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(KScreenWidth-20, 1000)];
    }else{
        descSize = CGSizeMake(KScreenWidth-30, 10);
    }
    _picDesc.frame = CGRectMake(10, _aImage.bottom+5, KScreenWidth-20, descSize.height+10);
    _picDesc.text = picDesc;
}

-(NSArray *)imageUrl:(NSString *)path{
    //[_pics[4] objectForKey:@"path"]
    NSMutableString *imageUrl;
    NSInteger imageHeight;
    if ([path rangeOfString:@"http:"].location != NSNotFound) {
        imageUrl = [[NSMutableString alloc] initWithString:path];
        imageUrl = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:imageUrl]];
        NSArray *separatedUrl = [imageUrl componentsSeparatedByString:@"_"];
        NSInteger imageWidth = [separatedUrl[1] integerValue];
        NSInteger imageHeight1 = [separatedUrl[2] integerValue];
            if (imageWidth>imageHeight1) {
                imageUrl = [NSMutableString stringWithString:[imageUrl stringByAppendingString:kImage338]];
                imageHeight = 338;
            }else{
                imageUrl = [NSMutableString stringWithString:[imageUrl stringByAppendingString:kImage422]];
                imageHeight = 422;
            }
    }else{
        imageUrl = [[NSMutableString alloc] initWithString:@""];
    }
    NSArray *imageInfo = @[[NSNumber numberWithInteger:imageHeight],[NSURL URLWithString:imageUrl]];
    return imageInfo;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
