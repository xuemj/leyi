//
//  MainViewController.h
//  PictureSaying
//
//  Created by NimoT's Mac on 14-9-22.
//  Copyright (c) 2014年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "ThemeViewController1.h"

@interface MainViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *_tabBarImgView;
    UIImageView *_selectedImgView;
    NSDictionary *imageNames;
    UIImageView *unReadImgView;
}
//@property(nonatomic , retain)ThemeViewController1 *theme1;
@property(nonatomic, assign)NSInteger selectedIndex;
@property(nonatomic, assign)BOOL show;
@property(nonatomic, copy)NSString *fromAlbum;
//-(void)hiddenUnreadImgView;
@end
