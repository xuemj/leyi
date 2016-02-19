//
//  ImagePickerMaskView.m
//  ImageViewPickerTest
//
//  Created by zsy on 15/1/5.
//  Copyright (c) 2015年 zsy. All rights reserved.
//

//121.5
#import "ImagePickerMaskView.h"
#define kRadius 80
#define kRadiusAva 130
@implementation ImagePickerMaskView

- (void)layoutSubviews {
    [self addMaskHoleToView];
}

- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type{
    if(self = [super initWithFrame:frame]) {
        self.isAva = type;
        [self addMaskHoleToView];
    }
    
    return self;
}

- (void)addMaskHoleToView {
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    CGRect bounds = self.bounds;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    UIBezierPath *path;
    if ([self.isAva isEqualToString:@"ava"]) {
        _cicleRect = CGRectMake(CGRectGetMidX(bounds) - kRadiusAva,
                                CGRectGetMidY(bounds) - kRadiusAva,
                                2 * kRadiusAva, 2 * kRadiusAva);
        
        path = [UIBezierPath bezierPathWithOvalInRect:_cicleRect];

    }else{
        _cicleRect = CGRectMake(10,
                            CGRectGetMidY(bounds) - kRadius,
                            KScreenWidth-20, 9*(KScreenWidth-20)/16);
        path = [UIBezierPath bezierPathWithRect:_cicleRect];
    }
    [path appendPath:[UIBezierPath bezierPathWithRect:bounds]];
    maskLayer.path = path.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    self.layer.mask = maskLayer;
}


@end
