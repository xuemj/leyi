//
//  AttributedLabel.h
//  AttributedStringTest
//
//  Created by sun huayu on 13-2-19.
//  Copyright (c) 2013年 sun huayu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@class AttributedLabel;
@protocol AttributedLabelDelegate <NSObject>

@optional
- (void)attributedLabel:(AttributedLabel *)attributedLabel openUrl:(NSURL *)url;

@end

@interface AttributedLabel : UILabel{
    NSMutableAttributedString           *_attString;
    CTFramesetterRef                    _framesetter;
	CTFrameRef                          _frame;
    CGContextRef                        context;
}

@property (nonatomic,strong) NSMutableDictionary *URLs;
@property (nonatomic) id<AttributedLabelDelegate>   delegate;
@property (nonatomic) int                      topOffset;
@property (nonatomic) BOOL                     isNeedLineBreakMode;//换行目前跟setAutoHeight有冲突，以后用到再调查

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length;

// 设置某段字的带有下划线
- (void)setUnderlineFromIndex:(NSInteger)location length:(NSInteger)length;

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length;

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length;

-(BOOL)labelTap:(UITapGestureRecognizer *)tap;

+(float)getHeightWithLimitWidth:(float)limitWidth string:(NSString *)string font:(UIFont *)font;

@end