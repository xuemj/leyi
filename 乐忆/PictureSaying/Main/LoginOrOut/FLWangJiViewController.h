//
//  FLWangJiViewController.h
//  Tushuo
//
//  Created by tutu on 14-12-3.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FLWangJiViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIView *findMima;
    UITextField *sjHaoma;
    UITextField *yzHaoma;
    UITextField *xinMima;
    UIButton *huoquYzheng;
    UIButton *queDing;
    UIAlertView *alt;

}
@end
