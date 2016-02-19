//
//  MDMNoDataBackground.m
//  MaiDouMi
//
//  Created by 郭晓敏 on 14-9-17.
//  Copyright (c) 2014年 MaiDouMi. All rights reserved.
//

#import "MDMNoDataBackground.h"
#import "UIView+Additions.h"
#import "UIView+Additions.h"

@interface MDMNoDataBackground ()
{
    UIImageView *imageView;
    UILabel *lable;
}
@end

@implementation MDMNoDataBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(instancetype)initWithBackGroundImageName:(NSString *)imageName withTitle:(NSString *)title withFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self) {
        self.alpha = 0.3;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height - 30)];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.size = CGSizeMake(100, 100);
        [imageView setCenter_x:self.width/2];
        [imageView setCenter_y:self.height/2];
        [self addSubview:imageView];
        
        lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(imageView.frame), CGRectGetWidth(self.frame), 50)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = title;
        [self addSubview:lable];
        

    }
    return self;
}

-(void)setHeight:(CGFloat)height
{
    [super setHeight:height];
    imageView.height = self.height - 30;
    [lable setFrame_y:[imageView getFrame_Bottom]];
}

-(void)changeTitleWithTitle:(NSString *)title
{
    lable.text = title;
}
@end
