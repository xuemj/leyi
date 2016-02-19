//
//  CreateViewController.h
//  PictureSaying
//
//  Created by tutu on 14/12/8.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "BaseViewController.h"
#import "DoImagePickerController.h"

@interface CreateViewController : BaseViewController<DoImagePickerControllerDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    UIScrollView *_scrollView;
    UIScrollView *tempSV;
    UIView *firstView;
    UIView *secondView;
    UIView *thirdView;
    UIView *tempTheView;
//    UIButton *locationButton;
    int imageCount;
    NSMutableArray *_taps;
    NSMutableArray *selectedImages;
    int indexPage;
    int delIndex;
    
    UITextField *BiaoqianText;
    NSMutableArray *arrayQuanju;
    float awidth;
    BOOL isChange;
    UIButton *btnn1;
    UIButton *shujuKuButton;
    UIButton *btnnFirst;
    int _i;
    int _j;
    int _jishu;
    float width;
    UIView *tagView;
    UIButton *ButtJia;
    NSString *eventDesc;
    UILabel *tipTag;
    NSMutableArray *selectedTags;
    NSMutableArray *addTags;
    NSMutableArray *allTags;
}

@property(nonatomic, copy)NSString *storyName;
@property(nonatomic, copy)NSString *storyTitle;
@property(nonatomic, retain)NSDictionary *storyDic;
@property(nonatomic, retain)NSMutableDictionary *pictureDescs;
@property(nonatomic, retain)NSString *isAdded;
@property(nonatomic, retain)NSString *isPopRoot;
@end
