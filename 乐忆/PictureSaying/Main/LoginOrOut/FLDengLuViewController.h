//
//  FLDengLuViewController.h
//  Tushuo
//
//  Created by tutu on 14-12-3.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FLDengLuViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIView *zcView;
    UITextField *YanZheng;
    UIButton *yanzhengButton;
    UITextField *PassWord;
    UIButton *zhuCeButton;
    UILabel *TelePhoneLabel;
    NSTimer *timer;
    
    UIView *textInput;
    UITextField *first;
    UITextField *second;
    UITextField *third;
    UITextField *fourth;
    
    NSString *YanzhengMaHeji;
    
}
@property(strong,nonatomic)NSString *_telePhon;
@property(strong,nonatomic)NSString *_PassWOrd;
@end
