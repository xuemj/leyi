//
//  MyPhotoLookCell.m
//  PictureSaying
//
//  Created by tutu on 15/1/4.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "MyPhotoLookCell.h"
#import "PhotoScrollView.h"
#import "PSConfigs.h"

@implementation MyPhotoLookCell

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

    _photoSV = [[PhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    _photoSV.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_photoSV];
}

-(void)setUrl:(NSString *)url{
    if (_url != url) {
        _url = url;
    }
    NSArray *imageSize = [url componentsSeparatedByString:@"_"];
    NSString *sizestring = [NSString stringWithFormat:@"_compression_%@_%@",imageSize[1],imageSize[2]];
    _url = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:_url]];
    _url = [NSMutableString stringWithString:[_url stringByAppendingString:sizestring]];
    _photoSV.imgUrl = [NSURL URLWithString:_url];
}
@end
