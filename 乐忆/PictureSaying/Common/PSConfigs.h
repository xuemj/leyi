//
//  PSConfigs.h
//  PictureSaying
//
//  Created by shixy on 15/1/8.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventModel.h"
//#import "IndexModel.h"
#import "MainModel.h"

enum IphoneType
{
    IphoneType_4s = 4,
    IphoneType_5s = 6,
    IphoneType_6 = 7,
    IphoneType_6plus = 8,
};

enum likeType
{
    likeType_Story,
    likeType_Event,
};

extern NSString *const kPSLikeStatusChangeNotification;

@interface PSConfigs : NSObject<UITextFieldDelegate>
{
    UIViewController    *_shareViewController;
}

@property (nonatomic,strong) NSString   *userid;
@property (nonatomic,strong) NSString   *usn;
@property (nonatomic,strong) NSString   *nickname;
@property (nonatomic,copy) NSString   *image;
@property (nonatomic,strong) NSObject   *obj;
@property(nonatomic,copy)NSString *sid;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *url;
+(PSConfigs *)shareConfigs;

+(enum IphoneType)getIphoneType;

-(void)loadUserInfo;

+(UIView *)lineViewWithWidth:(CGFloat)width withY:(CGFloat)y;

+(BOOL)showProgressWithError:(NSError *)error withView:(UIView *)view operationResponseString:(NSString *)responseString delayShow:(BOOL)delayShow isImage:(BOOL)isImage;

-(void)shareActionWithFromViewController:(UIViewController *)viewController withObject:(NSObject *)obj;
-(void)shareActionWithFromViewController:(UIViewController *)viewController;

#pragma mark -likeAction
//-(void)likeActionWithType:(enum likeType)type withZanButton:(UIButton *)zanButton withZanLabel:(UILabel *)zanLabel withIndexModel:(IndeModel *)indexModel withEventModel:(EventModel *)eventModel;
-(void)likeActionWithType:(enum likeType)type withZanButton:(UIButton *)zanButton withIndexModel:(MainModel *)indexModel withEventModel:(EventModel *)eventModel;
+(UIImage *)getImageWithRemark:(NSString *)remark;

+(NSString *)getImageUrlPrefixWithSourcePath:(NSString *)path;

@end
