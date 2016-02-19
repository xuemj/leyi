//
//  MyLibraryCell.m
//  PictureSaying
//
//  Created by tutu on 14/12/30.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "MyLibraryCell.h"
#import "MyLibraryDetailVC.h"
#import "PressViewController.h"
#import "UIImageView+WebCache.h"
#import "MyFamilyViewController.h"
#import "PSConfigs.h"

@implementation MyLibraryCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initViews];
        
        
    }
    return  self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark - ViewCell
-(void)_initViews{
    
//    _bgView = [[UIView alloc]init];
//    _bgView.layer.cornerRadius = 0;
//    [self.contentView addSubview:_bgView];
//    _bgView.backgroundColor = [UIColor whiteColor];
    
    imgBig = [[UIImageView alloc]init];
    [imgBig setImage:[UIImage imageNamed:@"AlmbAdd"]];
    imgBig.backgroundColor = [UIColor colorWithWhite:0.940 alpha:1.000];
    imgBig.userInteractionEnabled = YES;
    [self.contentView addSubview:imgBig];
    
    //大图片按钮
    _imageView = [[UIImageView alloc]init];
    _imageView.image = [UIImage imageNamed:@"noDataShow"];
    _imageView.userInteractionEnabled = YES;
    [imgBig addSubview:_imageView];
    
    //标题处理
    _titleLabel = [[UILabel alloc]init];
//    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1];
    [self.contentView addSubview:_titleLabel];
    
    //时间处理
    _TimeLabel = [[UILabel alloc]init];
    _TimeLabel.font = [UIFont systemFontOfSize:15.0];
    _TimeLabel.numberOfLines = 0;
    _TimeLabel.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:147/255.0 alpha:1];
    [self.contentView addSubview:_TimeLabel];
    
    //添加亲人按钮添加
    buttonAdd.frame = CGRectZero;
    buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonAdd setImage:[UIImage imageNamed:@"tianjiaQinqi.png"] forState:UIControlStateNormal];
    buttonAdd.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [buttonAdd addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:buttonAdd];
    
}
#pragma mark - Model
-(void)setModel:(MyPhotos *)model{
    if (_model != model) {
        _model = model;
        [self setNeedsLayout];
    }
}

#pragma mark - layoutSubviews
-(void)layoutSubviews{
    [super layoutSubviews];
//    _bgView.frame = CGRectMake(0, 5, KScreenWidth, 150);

    imgBig.frame = CGRectMake(10, 10, KScreenWidth/4+10, KScreenWidth/4+10);
    _imageView.frame = CGRectMake(3, 3, KScreenWidth/4+4, KScreenWidth/4);
    _imageView.image = [UIImage imageNamed:@"noDataShow@2x.png"];
    if ([self.model.ImageName rangeOfString:@"http:"].location != NSNotFound) {
        NSMutableString *urlHaha = [[NSMutableString alloc] initWithString:self.model.ImageName];
        urlHaha = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:urlHaha]];
        urlHaha = [NSMutableString stringWithString:[urlHaha stringByAppendingString:@"_compression_180_180.jpeg"]];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:urlHaha]];
    }else{
        _imageView.image = [UIImage imageNamed:@"noDataShow"];
    }
    _titleLabel.frame = CGRectMake(imgBig.right+15, (self.height-50)/2, KScreenWidth-imgBig.right-30, 30);
    if (![_model.title isKindOfClass:[NSNull class]]) {
        _titleLabel.text = self.model.title;
        _TimeLabel.text = self.model.Timedate;
    }else{
        _titleLabel.text = @"";
        _TimeLabel.text = self.model.Timedate;
    }
    _TimeLabel.frame = CGRectMake(imgBig.right+15, _titleLabel.bottom, 120, 30);
    buttonAdd.frame = CGRectMake(KScreenWidth-60,self.height-60, 60, 60);
}

#pragma mark - ButtonAction
-(PressViewController *)viewController{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[PressViewController class]]) {
            return (PressViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}

//调到添加亲人页面
-(void)commentAction:(UIButton *)btt{
    MyFamilyViewController *myFamily = [[MyFamilyViewController alloc] init];
    myFamily.isInvite = @"yes";
    myFamily.albumId = self.model.AlumbId;
    [self.viewController.navigationController pushViewController:myFamily animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
}

@end
